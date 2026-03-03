import '../models/customer.dart';
import 'address_dto.dart';

class CustomerDto {
  const CustomerDto({
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
  final AddressDto address;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory CustomerDto.fromJson(Map<String, dynamic> json) {
    return CustomerDto(
      id: json['id'] as int,
      email: json['email'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      birthDate: DateTime.parse(json['birth_date'] as String),
      address: AddressDto.fromJson(json['address'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'birth_date': birthDate.toIso8601String(),
      'address': address.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Customer toDomain() {
    return Customer(
      id: id,
      email: email,
      firstname: firstname,
      lastname: lastname,
      birthDate: birthDate,
      address: address.toDomain(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory CustomerDto.fromDomain(Customer customer) {
    return CustomerDto(
      id: customer.id,
      email: customer.email,
      firstname: customer.firstname,
      lastname: customer.lastname,
      birthDate: customer.birthDate,
      address: AddressDto.fromDomain(customer.address),
      createdAt: customer.createdAt,
      updatedAt: customer.updatedAt,
    );
  }
}
