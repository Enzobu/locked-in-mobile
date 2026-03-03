import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/address.dart';
import 'package:locked_in_mobile/core/models/company.dart';
import 'package:locked_in_mobile/core/models/locker_bay.dart';

void main() {
  final now = DateTime(2025, 1, 1);
  const address = Address(
    id: 1,
    city: 'Paris',
    country: 'France',
    street: 'Rue de Rivoli',
  );
  final company = Company(
    id: 1,
    name: 'LockerCorp',
    siret: '12345678901234',
    siren: '123456789',
    ape: '6201Z',
    juridicForm: 'SAS',
    phone: '+33123456789',
    address: address,
    createdAt: now,
    updatedAt: now,
  );

  final lockerBay = LockerBay(
    id: 1,
    name: 'Gare du Nord',
    latitude: 48.8809,
    longitude: 2.3553,
    company: company,
    maxDuration: 72,
    minDuration: 1,
    createdAt: now,
    updatedAt: now,
  );

  group('LockerBay', () {
    test('constructor sets all fields correctly', () {
      expect(lockerBay.id, 1);
      expect(lockerBay.name, 'Gare du Nord');
      expect(lockerBay.latitude, 48.8809);
      expect(lockerBay.longitude, 2.3553);
      expect(lockerBay.company, company);
      expect(lockerBay.maxDuration, 72);
      expect(lockerBay.minDuration, 1);
    });

    test('nullable fields default to null', () {
      final minimal = LockerBay(
        id: 2,
        name: 'Test Bay',
        latitude: 0.0,
        longitude: 0.0,
        company: company,
        createdAt: now,
        updatedAt: now,
      );
      expect(minimal.maxDuration, isNull);
      expect(minimal.minDuration, isNull);
    });

    test('copyWith creates a new instance with updated fields', () {
      final updated = lockerBay.copyWith(name: 'Gare de Lyon');
      expect(updated.name, 'Gare de Lyon');
      expect(updated.latitude, lockerBay.latitude);
    });

    test('copyWith can set nullable fields to null', () {
      final updated = lockerBay.copyWith(
        maxDuration: () => null,
        minDuration: () => null,
      );
      expect(updated.maxDuration, isNull);
      expect(updated.minDuration, isNull);
    });

    test('equality works correctly', () {
      final same = LockerBay(
        id: 1,
        name: 'Gare du Nord',
        latitude: 48.8809,
        longitude: 2.3553,
        company: company,
        maxDuration: 72,
        minDuration: 1,
        createdAt: now,
        updatedAt: now,
      );
      expect(lockerBay, equals(same));
      expect(lockerBay.hashCode, same.hashCode);
    });

    test('inequality works correctly', () {
      final different = lockerBay.copyWith(name: 'Gare de Lyon');
      expect(lockerBay, isNot(equals(different)));
    });

    test('toString contains class name and fields', () {
      final str = lockerBay.toString();
      expect(str, contains('LockerBay'));
      expect(str, contains('Gare du Nord'));
    });
  });
}
