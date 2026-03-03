import '../models/locker_bay.dart';
import '../utils/json_helpers.dart';
import 'company_dto.dart';

class LockerBayDto {
  const LockerBayDto({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.company,
    required this.createdAt,
    required this.updatedAt,
    this.maxDuration,
    this.minDuration,
  });

  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final CompanyDto company;
  final int? maxDuration;
  final int? minDuration;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory LockerBayDto.fromJson(Map<String, dynamic> json) {
    return LockerBayDto(
      id: json['id'] as int,
      name: json['name'] as String,
      latitude: JsonHelpers.parseDouble(json['latitude']),
      longitude: JsonHelpers.parseDouble(json['longitude']),
      company: CompanyDto.fromJson(json['company'] as Map<String, dynamic>),
      maxDuration: json['maxDuration'] as int? ?? json['max_duration'] as int?,
      minDuration: json['minDuration'] as int? ?? json['min_duration'] as int?,
      createdAt: JsonHelpers.parseDateTime(json, 'createdAt', 'created_at'),
      updatedAt: JsonHelpers.parseDateTime(json, 'updatedAt', 'updated_at'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'company': company.toJson(),
      'maxDuration': maxDuration,
      'minDuration': minDuration,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  LockerBay toDomain() {
    return LockerBay(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      company: company.toDomain(),
      maxDuration: maxDuration,
      minDuration: minDuration,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory LockerBayDto.fromDomain(LockerBay lockerBay) {
    return LockerBayDto(
      id: lockerBay.id,
      name: lockerBay.name,
      latitude: lockerBay.latitude,
      longitude: lockerBay.longitude,
      company: CompanyDto.fromDomain(lockerBay.company),
      maxDuration: lockerBay.maxDuration,
      minDuration: lockerBay.minDuration,
      createdAt: lockerBay.createdAt,
      updatedAt: lockerBay.updatedAt,
    );
  }
}
