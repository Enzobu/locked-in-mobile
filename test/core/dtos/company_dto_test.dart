import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/dtos/company_dto.dart';

void main() {
  final json = {
    'id': 1,
    'name': 'LockerBox France',
    'siret': '12345678901234',
    'siren': '123456789',
    'ape': '5221Z',
    'juridic_form': 'SAS',
    'phone': '+33 1 23 45 67 89',
    'address': {
      'id': 13,
      'number': '100',
      'city': 'Paris',
      'country': 'France',
      'street': 'Boulevard Haussmann',
      'complement': '3ème étage',
    },
    'created_at': '2024-01-15T10:00:00.000',
    'updated_at': '2024-06-01T14:30:00.000',
  };

  group('CompanyDto', () {
    test('fromJson creates correct DTO', () {
      final dto = CompanyDto.fromJson(json);

      expect(dto.id, 1);
      expect(dto.name, 'LockerBox France');
      expect(dto.siret, '12345678901234');
      expect(dto.siren, '123456789');
      expect(dto.ape, '5221Z');
      expect(dto.juridicForm, 'SAS');
      expect(dto.phone, '+33 1 23 45 67 89');
      expect(dto.address.city, 'Paris');
      expect(dto.createdAt, DateTime.parse('2024-01-15T10:00:00.000'));
    });

    test('toJson produces correct map', () {
      final dto = CompanyDto.fromJson(json);
      final result = dto.toJson();

      expect(result['id'], json['id']);
      expect(result['name'], json['name']);
      expect(result['juridicForm'], json['juridic_form']);
      expect(result['address'], isA<Map<String, dynamic>>());
    });

    test('round-trip serialization preserves data', () {
      final dto = CompanyDto.fromJson(json);
      final serialized = dto.toJson();
      final restored = CompanyDto.fromJson(serialized);

      expect(restored.id, dto.id);
      expect(restored.name, dto.name);
      expect(restored.siret, dto.siret);
      expect(restored.siren, dto.siren);
      expect(restored.juridicForm, dto.juridicForm);
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
