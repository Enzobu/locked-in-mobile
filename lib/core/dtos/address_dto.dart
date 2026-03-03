import '../models/address.dart';

class AddressDto {
  const AddressDto({
    required this.id,
    required this.city,
    required this.country,
    required this.street,
    this.number,
    this.complement,
  });

  final int id;
  final String? number;
  final String city;
  final String country;
  final String street;
  final String? complement;

  factory AddressDto.fromJson(Map<String, dynamic> json) {
    return AddressDto(
      id: json['id'] as int,
      number: json['number'] as String?,
      city: json['city'] as String,
      country: json['country'] as String,
      street: (json['street'] ?? json['address']) as String,
      complement: json['complement'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'city': city,
      'country': country,
      'street': street,
      'complement': complement,
    };
  }

  Address toDomain() {
    return Address(
      id: id,
      number: number,
      city: city,
      country: country,
      street: street,
      complement: complement,
    );
  }

  factory AddressDto.fromDomain(Address address) {
    return AddressDto(
      id: address.id,
      number: address.number,
      city: address.city,
      country: address.country,
      street: address.street,
      complement: address.complement,
    );
  }
}
