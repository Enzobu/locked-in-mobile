enum ReservationStatus {
  pending('pending'),
  confirmed('confirmed'),
  active('active'),
  completed('completed'),
  cancelled('cancelled'),
  expired('expired');

  const ReservationStatus(this.value);

  final String value;

  static ReservationStatus fromString(String value) {
    return ReservationStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw ArgumentError('Unknown ReservationStatus: $value'),
    );
  }
}
