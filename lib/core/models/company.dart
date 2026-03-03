import 'address.dart';

class Company {
  const Company({
    required this.id,
    required this.name,
    required this.siret,
    required this.siren,
    required this.ape,
    required this.juridicForm,
    required this.phone,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final String siret;
  final String siren;
  final String ape;
  final String juridicForm;
  final String phone;
  final Address address;
  final DateTime createdAt;
  final DateTime updatedAt;

  Company copyWith({
    int? id,
    String? name,
    String? siret,
    String? siren,
    String? ape,
    String? juridicForm,
    String? phone,
    Address? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      siret: siret ?? this.siret,
      siren: siren ?? this.siren,
      ape: ape ?? this.ape,
      juridicForm: juridicForm ?? this.juridicForm,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Company &&
        other.id == id &&
        other.name == name &&
        other.siret == siret &&
        other.siren == siren &&
        other.ape == ape &&
        other.juridicForm == juridicForm &&
        other.phone == phone &&
        other.address == address &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    siret,
    siren,
    ape,
    juridicForm,
    phone,
    address,
    createdAt,
    updatedAt,
  );

  @override
  String toString() {
    return 'Company(id: $id, name: $name, siret: $siret, siren: $siren, ape: $ape, juridicForm: $juridicForm, phone: $phone, address: $address)';
  }
}
