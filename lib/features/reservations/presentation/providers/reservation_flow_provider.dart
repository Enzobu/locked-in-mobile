import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/locker.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import 'reservation_provider.dart';

enum ReservationFlowStep { dateSelection, summary, payment, confirmed }

class ReservationFlowState {
  const ReservationFlowState({
    required this.locker,
    this.step = ReservationFlowStep.dateSelection,
    this.selectedDate,
    this.selectedTime,
    this.durationMinutes,
    this.isSubmitting = false,
    this.isLoadingIntent = false,
    this.clientSecret,
    this.reservationId,
    this.publicForm,
    this.cardComplete = false,
    this.error,
  });

  final Locker locker;
  final ReservationFlowStep step;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final int? durationMinutes;
  final bool isSubmitting;
  final bool isLoadingIntent;
  final String? clientSecret;
  final int? reservationId;
  final String? publicForm;
  final bool cardComplete;
  final String? error;

  bool get canProceed =>
      selectedDate != null && selectedTime != null && durationMinutes != null;

  bool get canPay => cardComplete && clientSecret != null && !isSubmitting;

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
    bool? isLoadingIntent,
    String? Function()? clientSecret,
    int? Function()? reservationId,
    String? Function()? publicForm,
    bool? cardComplete,
    String? Function()? error,
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
      isLoadingIntent: isLoadingIntent ?? this.isLoadingIntent,
      clientSecret: clientSecret != null ? clientSecret() : this.clientSecret,
      reservationId: reservationId != null
          ? reservationId()
          : this.reservationId,
      publicForm: publicForm != null ? publicForm() : this.publicForm,
      cardComplete: cardComplete ?? this.cardComplete,
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

  void setCardComplete(bool complete) {
    state = state.copyWith(cardComplete: complete);
  }

  /// Transition to payment step and create PaymentIntent
  Future<void> goToPayment() async {
    state = state.copyWith(
      step: ReservationFlowStep.payment,
      isLoadingIntent: true,
      error: () => null,
    );

    try {
      final paymentService = _ref.read(paymentServiceProvider);
      final intentResult = await paymentService.createPaymentIntent(
        lockerId: state.locker.id,
        startsAt: state.startsAt!,
        endsAt: state.endsAt!,
      );

      state = state.copyWith(
        isLoadingIntent: false,
        clientSecret: () => intentResult.clientSecret,
        reservationId: () => intentResult.reservationId,
      );
    } catch (e) {
      state = state.copyWith(isLoadingIntent: false, error: () => e.toString());
    }
  }

  void goBackToDateSelection() {
    state = state.copyWith(step: ReservationFlowStep.dateSelection);
  }

  void goBackToSummary() {
    state = state.copyWith(step: ReservationFlowStep.summary);
  }

  /// Confirm payment with card details already collected by CardFormField
  Future<void> processPayment() async {
    if (state.clientSecret == null) return;

    state = state.copyWith(isSubmitting: true, error: () => null);

    try {
      final paymentService = _ref.read(paymentServiceProvider);

      final result = await paymentService.confirmCardPayment(
        clientSecret: state.clientSecret!,
      );

      if (!result.isSuccess) {
        state = state.copyWith(
          isSubmitting: false,
          error: () => result.errorMessage ?? 'Payment failed',
        );
        return;
      }

      state = state.copyWith(
        step: ReservationFlowStep.confirmed,
        isSubmitting: false,
        publicForm: () => 'RES-${state.reservationId}',
      );

      _ref.read(reservationsProvider.notifier).refresh();
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: () => e.toString());
    }
  }
}
