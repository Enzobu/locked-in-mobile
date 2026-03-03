import '../models/customer.dart';
import '../utils/json_helpers.dart';
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
      birthDate: JsonHelpers.parseDateTime(json, 'birthDate', 'birth_date'),
      address: AddressDto.fromJson(json['address'] as Map<String, dynamic>),
      createdAt: JsonHelpers.parseDateTime(json, 'createdAt', 'created_at'),
      updatedAt: JsonHelpers.parseDateTime(json, 'updatedAt', 'updated_at'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'birthDate': birthDate.toIso8601String(),
      'address': address.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
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
