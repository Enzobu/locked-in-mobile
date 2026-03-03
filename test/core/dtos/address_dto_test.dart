import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/dtos/address_dto.dart';

void main() {
  const json = {
    'id': 1,
    'number': '12',
    'city': 'Paris',
    'country': 'France',
    'street': 'Rue de Rivoli',
    'complement': 'Niveau -1',
  };

  const jsonNullable = {
    'id': 2,
    'number': null,
    'city': 'Lyon',
    'country': 'France',
    'street': 'Place Bellecour',
    'complement': null,
  };

  group('AddressDto', () {
    test('fromJson creates correct DTO', () {
      final dto = AddressDto.fromJson(json);

      expect(dto.id, 1);
      expect(dto.number, '12');
      expect(dto.city, 'Paris');
      expect(dto.country, 'France');
      expect(dto.street, 'Rue de Rivoli');
      expect(dto.complement, 'Niveau -1');
    });

    test('fromJson handles null fields', () {
      final dto = AddressDto.fromJson(jsonNullable);

      expect(dto.number, isNull);
      expect(dto.complement, isNull);
    });

    test('toJson produces correct map', () {
      final dto = AddressDto.fromJson(json);
      final result = dto.toJson();

      expect(result, json);
    });

    test('round-trip serialization preserves data', () {
      final dto = AddressDto.fromJson(json);
      final serialized = dto.toJson();
      final restored = AddressDto.fromJson(serialized);

      expect(restored.id, dto.id);
      expect(restored.number, dto.number);
      expect(restored.city, dto.city);
      expect(restored.country, dto.country);
      expect(restored.street, dto.street);
      expect(restored.complement, dto.complement);
    });

    test('toDomain creates correct domain model', () {
      final dto = AddressDto.fromJson(json);
      final domain = dto.toDomain();

      expect(domain.id, dto.id);
      expect(domain.number, dto.number);
      expect(domain.city, dto.city);
      expect(domain.country, dto.country);
      expect(domain.street, dto.street);
      expect(domain.complement, dto.complement);
    });

    test('fromDomain creates correct DTO', () {
      final dto = AddressDto.fromJson(json);
      final domain = dto.toDomain();
      final restored = AddressDto.fromDomain(domain);

      expect(restored.id, dto.id);
      expect(restored.number, dto.number);
      expect(restored.city, dto.city);
    });
  });
}
