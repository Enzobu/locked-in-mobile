import '../models/company.dart';
import '../utils/json_helpers.dart';
import 'address_dto.dart';

class CompanyDto {
  const CompanyDto({
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
  final AddressDto address;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory CompanyDto.fromJson(Map<String, dynamic> json) {
    return CompanyDto(
      id: json['id'] as int,
      name: json['name'] as String,
      siret: json['siret'] as String,
      siren: json['siren'] as String,
      ape: json['ape'] as String,
      juridicForm: (json['juridicForm'] ?? json['juridic_form']) as String,
      phone: json['phone'] as String,
      address: AddressDto.fromJson(json['address'] as Map<String, dynamic>),
      createdAt: JsonHelpers.parseDateTime(json, 'createdAt', 'created_at'),
      updatedAt: JsonHelpers.parseDateTime(json, 'updatedAt', 'updated_at'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'siret': siret,
      'siren': siren,
      'ape': ape,
      'juridicForm': juridicForm,
      'phone': phone,
      'address': address.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Company toDomain() {
    return Company(
      id: id,
      name: name,
      siret: siret,
      siren: siren,
      ape: ape,
      juridicForm: juridicForm,
      phone: phone,
      address: address.toDomain(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory CompanyDto.fromDomain(Company company) {
    return CompanyDto(
      id: company.id,
      name: company.name,
      siret: company.siret,
      siren: company.siren,
      ape: company.ape,
      juridicForm: company.juridicForm,
      phone: company.phone,
      address: AddressDto.fromDomain(company.address),
      createdAt: company.createdAt,
      updatedAt: company.updatedAt,
    );
  }
}
