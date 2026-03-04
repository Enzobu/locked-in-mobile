class CloseReservationResult {
  const CloseReservationResult({
    required this.reservationId,
    required this.status,
    this.overtimeMinutes,
    this.overtimeAmountCents,
    this.overtimePaymentStatus,
  });

  final int reservationId;
  final String status;
  final int? overtimeMinutes;
  final int? overtimeAmountCents;
  final String? overtimePaymentStatus;

  bool get hasOvertime => overtimeMinutes != null && overtimeMinutes! > 0;
}
