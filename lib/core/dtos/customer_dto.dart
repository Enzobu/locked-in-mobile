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
  final List<AddressDto> addresses;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory CustomerDto.fromJson(Map<String, dynamic> json) {
    final addressesJson = json['addresses'] as List<dynamic>? ?? [];
    return CustomerDto(
      id: json['id'] as int,
      email: json['email'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      phone: json['phone'] as String?,
      birthDate: JsonHelpers.parseDateTime(json, 'birthDate', 'birth_date'),
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      addresses: addressesJson
          .map((e) => AddressDto.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      'phone': phone,
      'birthDate': birthDate.toIso8601String(),
      'roles': roles,
      'addresses': addresses.map((e) => e.toJson()).toList(),
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
      phone: phone,
      birthDate: birthDate,
      roles: roles,
      addresses: addresses.map((e) => e.toDomain()).toList(),
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
      phone: customer.phone,
      birthDate: customer.birthDate,
      roles: customer.roles,
      addresses: customer.addresses
          .map((e) => AddressDto.fromDomain(e))
          .toList(),
      createdAt: customer.createdAt,
      updatedAt: customer.updatedAt,
    );
  }
}
