import 'locker_bay.dart';
import 'locker_status.dart';
import 'specification.dart';

class Locker {
  const Locker({
    required this.id,
    required this.number,
    required this.specification,
    required this.priceCents,
    required this.lockerBay,
    required this.createdAt,
    required this.updatedAt,
    this.hardwareId,
    this.status = LockerStatus.available,
    this.lastSeenAt,
  });

  final int id;
  final int number;
  final String? hardwareId;
  final Specification specification;
  final int priceCents;
  final LockerBay lockerBay;
  final LockerStatus status;
  final DateTime? lastSeenAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  double get priceEuros => priceCents / 100.0;

  Locker copyWith({
    int? id,
    int? number,
    String? Function()? hardwareId,
    Specification? specification,
    int? priceCents,
    LockerBay? lockerBay,
    LockerStatus? status,
    DateTime? Function()? lastSeenAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Locker(
      id: id ?? this.id,
      number: number ?? this.number,
      hardwareId: hardwareId != null ? hardwareId() : this.hardwareId,
      specification: specification ?? this.specification,
      priceCents: priceCents ?? this.priceCents,
      lockerBay: lockerBay ?? this.lockerBay,
      status: status ?? this.status,
      lastSeenAt: lastSeenAt != null ? lastSeenAt() : this.lastSeenAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Locker &&
        other.id == id &&
        other.number == number &&
        other.hardwareId == hardwareId &&
        other.specification == specification &&
        other.priceCents == priceCents &&
        other.lockerBay == lockerBay &&
        other.status == status &&
        other.lastSeenAt == lastSeenAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    number,
    hardwareId,
    specification,
    priceCents,
    lockerBay,
    status,
    lastSeenAt,
    createdAt,
    updatedAt,
  );

  @override
  String toString() {
    return 'Locker(id: $id, number: $number, status: ${status.value}, priceCents: $priceCents, specification: ${specification.name}, lockerBay: ${lockerBay.name})';
  }
}
