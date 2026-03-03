import 'company.dart';

class LockerBay {
  const LockerBay({
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
  final Company? company;
  final int? maxDuration;
  final int? minDuration;

  LockerBay copyWith({
    int? id,
    String? name,
    double? latitude,
    double? longitude,
    Company? Function()? company,
    int? Function()? maxDuration,
    int? Function()? minDuration,
  }) {
    return LockerBay(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      company: company != null ? company() : this.company,
      maxDuration: maxDuration != null ? maxDuration() : this.maxDuration,
      minDuration: minDuration != null ? minDuration() : this.minDuration,
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
        other.minDuration == minDuration;
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
  );

  @override
  String toString() {
    return 'LockerBay(id: $id, name: $name, latitude: $latitude, longitude: $longitude, company: ${company?.name}, maxDuration: $maxDuration, minDuration: $minDuration)';
  }
}
