import 'address.dart';

class Company {
  const Company({
    required this.id,
    required this.name,
    required this.siren,
    required this.address,
  });

  final int id;
  final String name;
  final String siren;
  final Address address;

  Company copyWith({int? id, String? name, String? siren, Address? address}) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      siren: siren ?? this.siren,
      address: address ?? this.address,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Company &&
        other.id == id &&
        other.name == name &&
        other.siren == siren &&
        other.address == address;
  }

  @override
  int get hashCode => Object.hash(id, name, siren, address);

  @override
  String toString() {
    return 'Company(id: $id, name: $name, siren: $siren, address: $address)';
  }
}
