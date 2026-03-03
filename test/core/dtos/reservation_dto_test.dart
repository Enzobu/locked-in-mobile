import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/dtos/reservation_dto.dart';
import 'package:locked_in_mobile/core/models/reservation_status.dart';

void main() {
  final json = {
    'id': 1,
    'starts_at': '2026-03-03T09:00:00.000',
    'ends_at': '2026-03-03T11:00:00.000',
    'customer': {
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
    },
    'locker': {
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
    },
    'status': 'active',
    'created_at': '2026-03-02T18:00:00.000',
    'updated_at': '2026-03-03T09:00:00.000',
  };

  group('ReservationDto', () {
    test('fromJson creates correct DTO', () {
      final dto = ReservationDto.fromJson(json);

      expect(dto.id, 1);
      expect(dto.startsAt, DateTime.parse('2026-03-03T09:00:00.000'));
      expect(dto.endsAt, DateTime.parse('2026-03-03T11:00:00.000'));
      expect(dto.status, 'active');
      expect(dto.customer.firstname, 'Jean');
      expect(dto.locker.number, 1);
    });

    test('round-trip serialization preserves data', () {
      final dto = ReservationDto.fromJson(json);
      final serialized = dto.toJson();
      final restored = ReservationDto.fromJson(serialized);

      expect(restored.id, dto.id);
      expect(restored.startsAt, dto.startsAt);
      expect(restored.endsAt, dto.endsAt);
      expect(restored.status, dto.status);
      expect(restored.customer.id, dto.customer.id);
      expect(restored.locker.id, dto.locker.id);
    });

    test('toDomain creates correct domain model', () {
      final dto = ReservationDto.fromJson(json);
      final domain = dto.toDomain();

      expect(domain.id, dto.id);
      expect(domain.status, ReservationStatus.active);
      expect(domain.durationMinutes, 120);
      expect(domain.customer.fullName, 'Jean Dupont');
    });

    test('fromDomain creates correct DTO', () {
      final dto = ReservationDto.fromJson(json);
      final domain = dto.toDomain();
      final restored = ReservationDto.fromDomain(domain);

      expect(restored.id, dto.id);
      expect(restored.status, 'active');
    });
  });
}
