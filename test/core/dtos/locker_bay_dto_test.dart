import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/dtos/locker_bay_dto.dart';

void main() {
  final json = {
    'id': 1,
    'name': 'Gare de Lyon',
    'latitude': 48.8443,
    'longitude': 2.3744,
    'company': {
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
        'complement': null,
      },
      'created_at': '2024-01-15T10:00:00.000',
      'updated_at': '2024-06-01T14:30:00.000',
    },
    'max_duration': 120,
    'min_duration': 30,
    'created_at': '2024-01-01T00:00:00.000',
    'updated_at': '2024-06-01T00:00:00.000',
  };

  group('LockerBayDto', () {
    test('fromJson creates correct DTO', () {
      final dto = LockerBayDto.fromJson(json);

      expect(dto.id, 1);
      expect(dto.name, 'Gare de Lyon');
      expect(dto.latitude, 48.8443);
      expect(dto.longitude, 2.3744);
      expect(dto.maxDuration, 120);
      expect(dto.minDuration, 30);
      expect(dto.company.name, 'LockerBox France');
    });

    test('fromJson handles null durations', () {
      final jsonNullDuration = Map<String, dynamic>.from(json);
      jsonNullDuration['max_duration'] = null;
      jsonNullDuration['min_duration'] = null;

      final dto = LockerBayDto.fromJson(jsonNullDuration);

      expect(dto.maxDuration, isNull);
      expect(dto.minDuration, isNull);
    });

    test('round-trip serialization preserves data', () {
      final dto = LockerBayDto.fromJson(json);
      final serialized = dto.toJson();
      final restored = LockerBayDto.fromJson(serialized);

      expect(restored.id, dto.id);
      expect(restored.name, dto.name);
      expect(restored.latitude, dto.latitude);
      expect(restored.longitude, dto.longitude);
      expect(restored.maxDuration, dto.maxDuration);
      expect(restored.company.id, dto.company.id);
    });

    test('toDomain creates correct domain model', () {
      final dto = LockerBayDto.fromJson(json);
      final domain = dto.toDomain();

      expect(domain.id, dto.id);
      expect(domain.name, dto.name);
      expect(domain.latitude, dto.latitude);
      expect(domain.company.name, 'LockerBox France');
    });

    test('fromDomain creates correct DTO', () {
      final dto = LockerBayDto.fromJson(json);
      final domain = dto.toDomain();
      final restored = LockerBayDto.fromDomain(domain);

      expect(restored.id, dto.id);
      expect(restored.name, dto.name);
    });
  });
}
