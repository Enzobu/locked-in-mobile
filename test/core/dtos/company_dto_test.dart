import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/dtos/company_dto.dart';

void main() {
  final json = {
    'id': 1,
    'name': 'LockerBox France',
    'siren': '123456789',
    'address': {
      'id': 13,
      'number': '100',
      'city': 'Paris',
      'country': 'France',
      'street': 'Boulevard Haussmann',
      'complement': '3ème étage',
    },
  };

  group('CompanyDto', () {
    test('fromJson creates correct DTO', () {
      final dto = CompanyDto.fromJson(json);

      expect(dto.id, 1);
      expect(dto.name, 'LockerBox France');
      expect(dto.siren, '123456789');
      expect(dto.address.city, 'Paris');
    });

    test('toJson produces correct map', () {
      final dto = CompanyDto.fromJson(json);
      final result = dto.toJson();

      expect(result['id'], json['id']);
      expect(result['name'], json['name']);
      expect(result['siren'], json['siren']);
      expect(result['address'], isA<Map<String, dynamic>>());
    });

    test('round-trip serialization preserves data', () {
      final dto = CompanyDto.fromJson(json);
      final serialized = dto.toJson();
      final restored = CompanyDto.fromJson(serialized);

      expect(restored.id, dto.id);
      expect(restored.name, dto.name);
      expect(restored.siren, dto.siren);
      expect(restored.address.city, dto.address.city);
    });

    test('toDomain creates correct domain model', () {
      final dto = CompanyDto.fromJson(json);
      final domain = dto.toDomain();

      expect(domain.id, dto.id);
      expect(domain.name, dto.name);
      expect(domain.address.city, 'Paris');
    });

    test('fromDomain creates correct DTO', () {
      final dto = CompanyDto.fromJson(json);
      final domain = dto.toDomain();
      final restored = CompanyDto.fromDomain(domain);

      expect(restored.id, dto.id);
      expect(restored.name, dto.name);
      expect(restored.siren, dto.siren);
    });
  });
}
