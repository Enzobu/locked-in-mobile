import 'company.dart';

class LockerBay {
  const LockerBay({
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
  final Company company;
  final int? maxDuration;
  final int? minDuration;
  final DateTime createdAt;
  final DateTime updatedAt;

  LockerBay copyWith({
    int? id,
    String? name,
    double? latitude,
    double? longitude,
    Company? company,
    int? Function()? maxDuration,
    int? Function()? minDuration,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LockerBay(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      company: company ?? this.company,
      maxDuration: maxDuration != null ? maxDuration() : this.maxDuration,
      minDuration: minDuration != null ? minDuration() : this.minDuration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LockerBay &&
        other.id == id &&
        other.name == name &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.company == company &&
        other.maxDuration == maxDuration &&
        other.minDuration == minDuration &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    latitude,
    longitude,
    company,
    maxDuration,
    minDuration,
    createdAt,
    updatedAt,
  );

  @override
  String toString() {
    return 'LockerBay(id: $id, name: $name, latitude: $latitude, longitude: $longitude, company: ${company.name}, maxDuration: $maxDuration, minDuration: $minDuration)';
  }
}
