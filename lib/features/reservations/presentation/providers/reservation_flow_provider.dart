import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/locker.dart';
import '../../../../core/models/reservation.dart';
import 'reservation_provider.dart';

enum ReservationFlowStep { dateSelection, summary, confirmed }

class ReservationFlowState {
  const ReservationFlowState({
    required this.locker,
    this.step = ReservationFlowStep.dateSelection,
    this.selectedDate,
    this.selectedTime,
    this.durationMinutes,
    this.isSubmitting = false,
    this.reservation,
    this.publicForm,
    this.error,
  });

  final Locker locker;
  final ReservationFlowStep step;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final int? durationMinutes;
  final bool isSubmitting;
  final Reservation? reservation;
  final String? publicForm;
  final String? error;

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
    Reservation? Function()? reservation,
    String? Function()? publicForm,
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
        startsAt: state.startsAt!,
        endsAt: state.endsAt!,
      );

      state = state.copyWith(
        step: ReservationFlowStep.confirmed,
        isSubmitting: false,
        reservation: () => reservation,
        publicForm: () => reservation.publicForm,
      );

      _ref.read(reservationsProvider.notifier).refresh();
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: () => e.toString());
    }
  }
}
