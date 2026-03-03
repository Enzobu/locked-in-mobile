import '../models/locker.dart';
import '../models/locker_status.dart';
import '../utils/json_helpers.dart';
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
      hardwareId:
          json['hardwareId'] as String? ?? json['hardware_id'] as String?,
      specification: SpecificationDto.fromJson(
        json['specification'] as Map<String, dynamic>,
      ),
      priceCents: JsonHelpers.parseInt(
        json['priceCents'] ?? json['price_cents'],
      ),
      lockerBay: LockerBayDto.fromJson(
        (json['lockerBay'] ?? json['locker_bay']) as Map<String, dynamic>,
      ),
      status: json['status'] as String,
      lastSeenAt: JsonHelpers.parseDateTimeOrNull(
        json,
        'lastSeenAt',
        'last_seen_at',
      ),
      createdAt: JsonHelpers.parseDateTime(json, 'createdAt', 'created_at'),
      updatedAt: JsonHelpers.parseDateTime(json, 'updatedAt', 'updated_at'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'hardwareId': hardwareId,
      'specification': specification.toJson(),
      'priceCents': priceCents,
      'lockerBay': lockerBay.toJson(),
      'status': status,
      'lastSeenAt': lastSeenAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
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
