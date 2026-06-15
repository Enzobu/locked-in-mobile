import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/locker.dart';
import '../../../../core/network/api_exception.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import 'reservation_provider.dart';

enum ReservationFlowStep { dateSelection, summary, payment, confirmed }

/// Semantic booking failures, mapped to a localized message in the UI.
enum BookingError {
  /// The slot is already booked or the locker is out of service (HTTP 409).
  slotUnavailable,

  /// The requested duration is invalid for this locker (HTTP 422).
  invalidDuration,

  /// Network/connectivity problem.
  network,

  /// The Stripe payment failed or was cancelled.
  paymentFailed,

  /// Anything else.
  generic,
}

BookingError mapBookingError(Object error) {
  if (error is ApiException) {
    return switch (error.statusCode) {
      409 => BookingError.slotUnavailable,
      422 => BookingError.invalidDuration,
      null => BookingError.network,
      _ => BookingError.generic,
    };
  }
  return BookingError.generic;
}

class ReservationFlowState {
  const ReservationFlowState({
    required this.locker,
    this.step = ReservationFlowStep.dateSelection,
    this.selectedDate,
    this.selectedTime,
    this.durationMinutes,
    this.isSubmitting = false,
    this.reservationId,
    this.publicForm,
    this.error,
  });

  final Locker locker;
  final ReservationFlowStep step;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final int? durationMinutes;
  final bool isSubmitting;
  final int? reservationId;
  final String? publicForm;
  final BookingError? error;

  bool get canProceed =>
      selectedDate != null && selectedTime != null && durationMinutes != null;

  int get minDuration => locker.lockerBay.minDuration ?? 30;
  int get maxDuration => locker.lockerBay.maxDuration ?? 120;

  DateTime? get startsAt {
    if (selectedDate == null || selectedTime == null) return null;
    return DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
  }

  DateTime? get endsAt {
    final start = startsAt;
    if (start == null || durationMinutes == null) return null;
    return start.add(Duration(minutes: durationMinutes!));
  }

  /// Total amount actually charged, computed exactly like the backend
  /// ReservationPricingService: priceCents is the hourly rate, so the total is
  /// ceil(durationMinutes * hourlyPriceCents / 60). This must match what Stripe
  /// charges at checkout.
  int get plannedAmountCents {
    final minutes = durationMinutes ?? 0;
    final effectiveMinutes = minutes < 1 ? 1 : minutes;
    return (effectiveMinutes * locker.priceCents / 60).ceil();
  }

  double get plannedAmountEuros => plannedAmountCents / 100;

  String formatDuration(
    String Function(int) formatMinutes,
    String Function(int, String) formatHoursMinutes,
  ) {
    final mins = durationMinutes ?? 0;
    if (mins < 60) return formatMinutes(mins);
    final hours = mins ~/ 60;
    final remaining = mins % 60;
    return formatHoursMinutes(
      hours,
      remaining > 0 ? remaining.toString().padLeft(2, '0') : '00',
    );
  }

  ReservationFlowState copyWith({
    Locker? locker,
    ReservationFlowStep? step,
    DateTime? Function()? selectedDate,
    TimeOfDay? Function()? selectedTime,
    int? Function()? durationMinutes,
    bool? isSubmitting,
    int? Function()? reservationId,
    String? Function()? publicForm,
    BookingError? Function()? error,
  }) {
    return ReservationFlowState(
      locker: locker ?? this.locker,
      step: step ?? this.step,
      selectedDate: selectedDate != null ? selectedDate() : this.selectedDate,
      selectedTime: selectedTime != null ? selectedTime() : this.selectedTime,
      durationMinutes: durationMinutes != null
          ? durationMinutes()
          : this.durationMinutes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      reservationId: reservationId != null
          ? reservationId()
          : this.reservationId,
      publicForm: publicForm != null ? publicForm() : this.publicForm,
      error: error != null ? error() : this.error,
    );
  }
}

final reservationFlowProvider = StateNotifierProvider.autoDispose
    .family<ReservationFlowNotifier, ReservationFlowState, Locker>(
      (ref, locker) => ReservationFlowNotifier(ref, locker),
    );

class ReservationFlowNotifier extends StateNotifier<ReservationFlowState> {
  ReservationFlowNotifier(this._ref, Locker locker)
    : super(
        ReservationFlowState(
          locker: locker,
          durationMinutes: locker.lockerBay.minDuration ?? 30,
        ),
      );

  final Ref _ref;

  void setDate(DateTime date) {
    state = state.copyWith(selectedDate: () => date, error: () => null);
  }

  void setTime(TimeOfDay time) {
    state = state.copyWith(selectedTime: () => time, error: () => null);
  }

  void setDuration(int minutes) {
    final clamped = minutes.clamp(state.minDuration, state.maxDuration);
    state = state.copyWith(durationMinutes: () => clamped, error: () => null);
  }

  void goToSummary() {
    if (!state.canProceed) return;
    state = state.copyWith(step: ReservationFlowStep.summary);
  }

  void goToPayment() {
    state = state.copyWith(step: ReservationFlowStep.payment);
  }

  void goBackToDateSelection() {
    state = state.copyWith(step: ReservationFlowStep.dateSelection);
  }

  void goBackToSummary() {
    state = state.copyWith(step: ReservationFlowStep.summary);
  }

  Future<void> processPayment() async {
    if (!state.canProceed) return;

    state = state.copyWith(isSubmitting: true, error: () => null);

    try {
      final paymentService = _ref.read(paymentServiceProvider);

      final intentResult = await paymentService.createPaymentIntent(
        lockerId: state.locker.id,
        startsAt: state.startsAt!,
        endsAt: state.endsAt!,
      );

      final sheetResult = await paymentService.presentPaymentSheet(
        clientSecret: intentResult.clientSecret,
      );

      if (!sheetResult.isSuccess) {
        state = state.copyWith(
          isSubmitting: false,
          error: () => BookingError.paymentFailed,
        );
        return;
      }

      state = state.copyWith(
        step: ReservationFlowStep.confirmed,
        isSubmitting: false,
        reservationId: () => intentResult.reservationId,
        publicForm: () => 'RES-${intentResult.reservationId}',
      );

      _ref.read(reservationsProvider.notifier).refresh();
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: () => mapBookingError(e),
      );
    }
  }
}
