import '../models/company.dart';
import 'address_dto.dart';

class CompanyDto {
  const CompanyDto({
    required this.id,
    required this.name,
    required this.siren,
    required this.address,
  });

  final int id;
  final String name;
  final String siren;
  final AddressDto address;

  factory CompanyDto.fromJson(Map<String, dynamic> json) {
    return CompanyDto(
      id: json['id'] as int,
      name: json['name'] as String,
      siren: json['siren'] as String,
      address: AddressDto.fromJson(json['address'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'siren': siren,
      'address': address.toJson(),
    };
  }

  Company toDomain() {
    return Company(
      id: id,
      name: name,
      siren: siren,
      address: address.toDomain(),
    );
  }

  factory CompanyDto.fromDomain(Company company) {
    return CompanyDto(
      id: company.id,
      name: company.name,
      siren: company.siren,
      address: AddressDto.fromDomain(company.address),
    );
  }
}
