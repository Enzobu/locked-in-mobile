import '../models/locker_bay.dart';
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
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      company: CompanyDto.fromJson(json['company'] as Map<String, dynamic>),
      maxDuration: json['max_duration'] as int?,
      minDuration: json['min_duration'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'company': company.toJson(),
      'max_duration': maxDuration,
      'min_duration': minDuration,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
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
