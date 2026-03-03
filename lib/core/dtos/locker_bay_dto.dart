import '../models/locker_bay.dart';
import '../utils/json_helpers.dart';
import 'company_dto.dart';

class LockerBayDto {
  const LockerBayDto({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.company,
    this.maxDuration,
    this.minDuration,
  });

  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final CompanyDto? company;
  final int? maxDuration;
  final int? minDuration;

  factory LockerBayDto.fromJson(Map<String, dynamic> json) {
    final companyJson = json['company'];
    return LockerBayDto(
      id: json['id'] as int,
      name: json['name'] as String,
      latitude: JsonHelpers.parseDouble(json['latitude']),
      longitude: JsonHelpers.parseDouble(json['longitude']),
      company: companyJson is Map<String, dynamic>
          ? CompanyDto.fromJson(companyJson)
          : null,
      maxDuration: json['maxDuration'] as int? ?? json['max_duration'] as int?,
      minDuration: json['minDuration'] as int? ?? json['min_duration'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'company': company?.toJson(),
      'maxDuration': maxDuration,
      'minDuration': minDuration,
    };
  }

  LockerBay toDomain() {
    return LockerBay(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      company: company?.toDomain(),
      maxDuration: maxDuration,
      minDuration: minDuration,
    );
  }

  factory LockerBayDto.fromDomain(LockerBay lockerBay) {
    return LockerBayDto(
      id: lockerBay.id,
      name: lockerBay.name,
      latitude: lockerBay.latitude,
      longitude: lockerBay.longitude,
      company: lockerBay.company != null
          ? CompanyDto.fromDomain(lockerBay.company!)
          : null,
      maxDuration: lockerBay.maxDuration,
      minDuration: lockerBay.minDuration,
    );
  }
}
