import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/dtos/locker_dto.dart';
import 'package:locked_in_mobile/core/models/locker_status.dart';

void main() {
  final json = {
    'id': 1,
    'number': 1,
    'hardware_id': 'HW-001-01',
    'specification': {
      'id': 1,
      'name': 'Small',
      'width': 30,
      'height': 40,
      'depth': 50,
      'material': 'Acier',
      'is_rechargeable': false,
    },
    'price_cents': 300,
    'locker_bay': {
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
    },
    'status': 'available',
    'last_seen_at': '2026-03-01T12:00:00.000',
    'created_at': '2024-01-01T00:00:00.000',
    'updated_at': '2026-03-01T12:00:00.000',
  };

  group('LockerDto', () {
    test('fromJson creates correct DTO', () {
      final dto = LockerDto.fromJson(json);

      expect(dto.id, 1);
      expect(dto.number, 1);
      expect(dto.hardwareId, 'HW-001-01');
      expect(dto.priceCents, 300);
      expect(dto.status, 'available');
      expect(dto.specification.name, 'Small');
      expect(dto.lockerBay.name, 'Gare de Lyon');
    });

    test('fromJson handles null optional fields', () {
      final jsonNullable = Map<String, dynamic>.from(json);
      jsonNullable['hardware_id'] = null;
      jsonNullable['last_seen_at'] = null;

      final dto = LockerDto.fromJson(jsonNullable);

      expect(dto.hardwareId, isNull);
      expect(dto.lastSeenAt, isNull);
    });

    test('round-trip serialization preserves data', () {
      final dto = LockerDto.fromJson(json);
      final serialized = dto.toJson();
      final restored = LockerDto.fromJson(serialized);

      expect(restored.id, dto.id);
      expect(restored.number, dto.number);
      expect(restored.priceCents, dto.priceCents);
      expect(restored.status, dto.status);
      expect(restored.specification.id, dto.specification.id);
      expect(restored.lockerBay.id, dto.lockerBay.id);
    });

    test('toDomain creates correct domain model', () {
      final dto = LockerDto.fromJson(json);
      final domain = dto.toDomain();

      expect(domain.id, dto.id);
      expect(domain.number, dto.number);
      expect(domain.priceCents, dto.priceCents);
      expect(domain.status, LockerStatus.available);
      expect(domain.priceEuros, 3.0);
    });

    test('fromDomain creates correct DTO', () {
      final dto = LockerDto.fromJson(json);
      final domain = dto.toDomain();
      final restored = LockerDto.fromDomain(domain);

      expect(restored.id, dto.id);
      expect(restored.status, 'available');
    });
  });
}
