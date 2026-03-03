import '../models/company.dart';
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
      juridicForm: json['juridic_form'] as String,
      phone: json['phone'] as String,
      address: AddressDto.fromJson(json['address'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'siret': siret,
      'siren': siren,
      'ape': ape,
      'juridic_form': juridicForm,
      'phone': phone,
      'address': address.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
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
