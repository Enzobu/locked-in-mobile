enum LockerStatus {
  available('available'),
  reserved('reserved'),
  occupied('occupied'),
  outOfOrder('out_of_order'),
  offline('offline');

  const LockerStatus(this.value);

  final String value;

  static LockerStatus fromString(String value) {
    return LockerStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw ArgumentError('Unknown LockerStatus: $value'),
    );
  }
}
