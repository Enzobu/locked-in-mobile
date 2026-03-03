import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/locker.dart';
import '../../../../core/models/reservation.dart';
import 'reservation_provider.dart';

enum ReservationFlowStep { dateSelection, summary, confirmed }

class ReservationFlowState {
  const ReservationFlowState({
    required this.locker,
    this.step = ReservationFlowStep.dateSelection,
    this.startDate,
    this.endDate,
    this.isSubmitting = false,
    this.reservation,
    this.publicForm,
    this.error,
  });

  final Locker locker;
  final ReservationFlowStep step;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isSubmitting;
  final Reservation? reservation;
  final String? publicForm;
  final String? error;

  bool get canProceed => startDate != null && endDate != null;

  int get durationDays {
    if (startDate == null || endDate == null) return 0;
    return endDate!.difference(startDate!).inDays;
  }

  double get totalPrice {
    if (durationDays == 0) return 0;
    return locker.priceEuros * durationDays;
  }

  ReservationFlowState copyWith({
    Locker? locker,
    ReservationFlowStep? step,
    DateTime? Function()? startDate,
    DateTime? Function()? endDate,
    bool? isSubmitting,
    Reservation? Function()? reservation,
    String? Function()? publicForm,
    String? Function()? error,
  }) {
    return ReservationFlowState(
      locker: locker ?? this.locker,
      step: step ?? this.step,
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      reservation: reservation != null ? reservation() : this.reservation,
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
    : super(ReservationFlowState(locker: locker));

  final Ref _ref;

  void setDateRange(DateTime start, DateTime end) {
    state = state.copyWith(
      startDate: () => start,
      endDate: () => end,
      error: () => null,
    );
  }

  void goToSummary() {
    if (!state.canProceed) return;
    state = state.copyWith(step: ReservationFlowStep.summary);
  }

  void goBackToDateSelection() {
    state = state.copyWith(step: ReservationFlowStep.dateSelection);
  }

  Future<void> confirmReservation() async {
    if (!state.canProceed) return;

    state = state.copyWith(isSubmitting: true, error: () => null);

    try {
      final repository = _ref.read(reservationRepositoryProvider);
      final reservation = await repository.createReservation(
        lockerId: state.locker.id,
        startsAt: state.startDate!,
        endsAt: state.endDate!,
      );

      final publicForm = _generatePublicForm();

      state = state.copyWith(
        step: ReservationFlowStep.confirmed,
        isSubmitting: false,
        reservation: () => reservation,
        publicForm: () => publicForm,
      );

      _ref.read(reservationsProvider.notifier).refresh();
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: () => e.toString());
    }
  }

  String _generatePublicForm() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return 'LI-${List.generate(8, (_) => chars[random.nextInt(chars.length)]).join()}';
  }
}
