import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/dtos/customer_dto.dart';

void main() {
  final json = {
    'id': 1,
    'email': 'jean.dupont@email.com',
    'firstname': 'Jean',
    'lastname': 'Dupont',
    'birth_date': '1995-06-15T00:00:00.000',
    'address': {
      'id': 16,
      'number': '22',
      'city': 'Paris',
      'country': 'France',
      'street': 'Rue du Faubourg Saint-Honoré',
      'complement': 'Apt 4B',
    },
    'created_at': '2025-01-10T08:00:00.000',
    'updated_at': '2026-02-15T10:30:00.000',
  };

  group('CustomerDto', () {
    test('fromJson creates correct DTO', () {
      final dto = CustomerDto.fromJson(json);

      expect(dto.id, 1);
      expect(dto.email, 'jean.dupont@email.com');
      expect(dto.firstname, 'Jean');
      expect(dto.lastname, 'Dupont');
      expect(dto.birthDate, DateTime.parse('1995-06-15T00:00:00.000'));
      expect(dto.address.city, 'Paris');
    });

    test('round-trip serialization preserves data', () {
      final dto = CustomerDto.fromJson(json);
      final serialized = dto.toJson();
      final restored = CustomerDto.fromJson(serialized);

      expect(restored.id, dto.id);
      expect(restored.email, dto.email);
      expect(restored.firstname, dto.firstname);
      expect(restored.lastname, dto.lastname);
      expect(restored.birthDate, dto.birthDate);
      expect(restored.address.id, dto.address.id);
    });

    test('toDomain creates correct domain model', () {
      final dto = CustomerDto.fromJson(json);
      final domain = dto.toDomain();

      expect(domain.id, dto.id);
      expect(domain.email, dto.email);
      expect(domain.fullName, 'Jean Dupont');
    });

    test('fromDomain creates correct DTO', () {
      final dto = CustomerDto.fromJson(json);
      final domain = dto.toDomain();
      final restored = CustomerDto.fromDomain(domain);

      expect(restored.id, dto.id);
      expect(restored.email, dto.email);
    });
  });
}
