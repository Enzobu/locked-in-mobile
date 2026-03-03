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
      'siren': '123456789',
      'address': {
        'id': 13,
        'number': '100',
        'city': 'Paris',
        'country': 'France',
        'street': 'Boulevard Haussmann',
        'complement': null,
      },
    },
    'maxDuration': 120,
    'minDuration': 30,
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
      expect(dto.company!.name, 'LockerBox France');
    });

    test('fromJson handles missing company (nested in locker)', () {
      final nestedJson = {
        'id': 1,
        'name': 'Gare de Lyon',
        'latitude': 48.8443,
        'longitude': 2.3744,
      };

      final dto = LockerBayDto.fromJson(nestedJson);

      expect(dto.company, isNull);
      expect(dto.maxDuration, isNull);
    });

    test('fromJson handles null durations', () {
      final jsonNullDuration = Map<String, dynamic>.from(json);
      jsonNullDuration['maxDuration'] = null;
      jsonNullDuration['minDuration'] = null;

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
      expect(restored.company!.id, dto.company!.id);
    });

    test('toDomain creates correct domain model', () {
      final dto = LockerBayDto.fromJson(json);
      final domain = dto.toDomain();

      expect(domain.id, dto.id);
      expect(domain.name, dto.name);
      expect(domain.latitude, dto.latitude);
      expect(domain.company!.name, 'LockerBox France');
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
