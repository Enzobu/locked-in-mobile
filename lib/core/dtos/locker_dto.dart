import '../models/locker.dart';
import '../models/locker_status.dart';
import 'locker_bay_dto.dart';
import 'specification_dto.dart';

class LockerDto {
  const LockerDto({
    required this.id,
    required this.number,
    required this.specification,
    required this.priceCents,
    required this.lockerBay,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.hardwareId,
    this.lastSeenAt,
  });

  final int id;
  final int number;
  final String? hardwareId;
  final SpecificationDto specification;
  final int priceCents;
  final LockerBayDto lockerBay;
  final String status;
  final DateTime? lastSeenAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory LockerDto.fromJson(Map<String, dynamic> json) {
    return LockerDto(
      id: json['id'] as int,
      number: json['number'] as int,
      hardwareId: json['hardware_id'] as String?,
      specification: SpecificationDto.fromJson(
        json['specification'] as Map<String, dynamic>,
      ),
      priceCents: json['price_cents'] as int,
      lockerBay: LockerBayDto.fromJson(
        json['locker_bay'] as Map<String, dynamic>,
      ),
      status: json['status'] as String,
      lastSeenAt: json['last_seen_at'] != null
          ? DateTime.parse(json['last_seen_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'hardware_id': hardwareId,
      'specification': specification.toJson(),
      'price_cents': priceCents,
      'locker_bay': lockerBay.toJson(),
      'status': status,
      'last_seen_at': lastSeenAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Locker toDomain() {
    return Locker(
      id: id,
      number: number,
      hardwareId: hardwareId,
      specification: specification.toDomain(),
      priceCents: priceCents,
      lockerBay: lockerBay.toDomain(),
      status: LockerStatus.fromString(status),
      lastSeenAt: lastSeenAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory LockerDto.fromDomain(Locker locker) {
    return LockerDto(
      id: locker.id,
      number: locker.number,
      hardwareId: locker.hardwareId,
      specification: SpecificationDto.fromDomain(locker.specification),
      priceCents: locker.priceCents,
      lockerBay: LockerBayDto.fromDomain(locker.lockerBay),
      status: locker.status.value,
      lastSeenAt: locker.lastSeenAt,
      createdAt: locker.createdAt,
      updatedAt: locker.updatedAt,
    );
  }
}
