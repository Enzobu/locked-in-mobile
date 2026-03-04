import 'address.dart';

class Customer {
  const Customer({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.birthDate,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.roles = const [],
    this.addresses = const [],
  });

  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final String? phone;
  final DateTime birthDate;
  final List<String> roles;
  final List<Address> addresses;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get fullName => '$firstname $lastname';

  Address? get primaryAddress => addresses.isNotEmpty ? addresses.first : null;

  Customer copyWith({
    int? id,
    String? email,
    String? firstname,
    String? lastname,
    String? phone,
    DateTime? birthDate,
    List<String>? roles,
    List<Address>? addresses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      email: email ?? this.email,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      roles: roles ?? this.roles,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Customer &&
        other.id == id &&
        other.email == email &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.birthDate == birthDate &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    firstname,
    lastname,
    birthDate,
    createdAt,
    updatedAt,
  );

  @override
  String toString() {
    return 'Customer(id: $id, email: $email, name: $fullName, birthDate: $birthDate)';
  }
}
