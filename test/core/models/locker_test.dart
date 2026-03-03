import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/address.dart';
import 'package:locked_in_mobile/core/models/company.dart';
import 'package:locked_in_mobile/core/models/locker.dart';
import 'package:locked_in_mobile/core/models/locker_bay.dart';
import 'package:locked_in_mobile/core/models/locker_status.dart';
import 'package:locked_in_mobile/core/models/specification.dart';

void main() {
  final now = DateTime(2025, 1, 1);
  const address = Address(
    id: 1,
    city: 'Paris',
    country: 'France',
    street: 'Rue de Rivoli',
  );
  const company = Company(
    id: 1,
    name: 'LockerCorp',
    siren: '123456789',
    address: address,
  );
  const spec = Specification(
    id: 1,
    width: 40,
    height: 60,
    depth: 30,
    material: 'steel',
    name: 'Medium',
  );
  const lockerBay = LockerBay(
    id: 1,
    name: 'Gare du Nord',
    latitude: 48.8809,
    longitude: 2.3553,
    company: company,
  );

  final locker = Locker(
    id: 1,
    number: 42,
    hardwareId: 'HW-001',
    specification: spec,
    priceCents: 500,
    lockerBay: lockerBay,
    status: LockerStatus.available,
    createdAt: now,
    updatedAt: now,
  );

  group('Locker', () {
    test('constructor sets all fields correctly', () {
      expect(locker.id, 1);
      expect(locker.number, 42);
      expect(locker.hardwareId, 'HW-001');
      expect(locker.specification, spec);
      expect(locker.priceCents, 500);
      expect(locker.lockerBay, lockerBay);
      expect(locker.status, LockerStatus.available);
    });

    test('priceEuros converts cents to euros', () {
      expect(locker.priceEuros, 5.0);

      final oddPrice = locker.copyWith(priceCents: 1299);
      expect(oddPrice.priceEuros, 12.99);
    });

    test('status defaults to available', () {
      final defaultLocker = Locker(
        id: 2,
        number: 1,
        specification: spec,
        priceCents: 300,
        lockerBay: lockerBay,
        createdAt: now,
        updatedAt: now,
      );
      expect(defaultLocker.status, LockerStatus.available);
      expect(defaultLocker.hardwareId, isNull);
      expect(defaultLocker.lastSeenAt, isNull);
    });

    test('copyWith creates a new instance with updated fields', () {
      final updated = locker.copyWith(
        status: LockerStatus.reserved,
        priceCents: 800,
      );
      expect(updated.status, LockerStatus.reserved);
      expect(updated.priceCents, 800);
      expect(updated.number, locker.number);
    });

    test('copyWith can set nullable fields to null', () {
      final updated = locker.copyWith(
        hardwareId: () => null,
        lastSeenAt: () => null,
      );
      expect(updated.hardwareId, isNull);
      expect(updated.lastSeenAt, isNull);
    });

    test('equality works correctly', () {
      final same = Locker(
        id: 1,
        number: 42,
        hardwareId: 'HW-001',
        specification: spec,
        priceCents: 500,
        lockerBay: lockerBay,
        status: LockerStatus.available,
        createdAt: now,
        updatedAt: now,
      );
      expect(locker, equals(same));
      expect(locker.hashCode, same.hashCode);
    });

    test('inequality works correctly', () {
      final different = locker.copyWith(status: LockerStatus.occupied);
      expect(locker, isNot(equals(different)));
    });

    test('toString contains class name and fields', () {
      final str = locker.toString();
      expect(str, contains('Locker'));
      expect(str, contains('42'));
      expect(str, contains('available'));
    });
  });
}
