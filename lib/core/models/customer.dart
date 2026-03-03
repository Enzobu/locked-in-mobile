import 'address.dart';

class Customer {
  const Customer({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.birthDate,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final DateTime birthDate;
  final Address address;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get fullName => '$firstname $lastname';

  Customer copyWith({
    int? id,
    String? email,
    String? firstname,
    String? lastname,
    DateTime? birthDate,
    Address? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      email: email ?? this.email,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
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
        other.address == address &&
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
    address,
    createdAt,
    updatedAt,
  );

  @override
  String toString() {
    return 'Customer(id: $id, email: $email, name: $fullName, birthDate: $birthDate)';
  }
}
