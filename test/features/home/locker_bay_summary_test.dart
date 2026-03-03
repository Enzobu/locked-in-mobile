import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/address.dart';
import 'package:locked_in_mobile/core/models/company.dart';
import 'package:locked_in_mobile/core/models/locker.dart';
import 'package:locked_in_mobile/core/models/locker_bay.dart';
import 'package:locked_in_mobile/core/models/locker_status.dart';
import 'package:locked_in_mobile/core/models/specification.dart';
import 'package:locked_in_mobile/features/home/domain/models/locker_bay_summary.dart';

void main() {
  const address = Address(
    id: 1,
    city: 'Paris',
    country: 'France',
    street: 'Rue de Rivoli',
    number: '12',
  );

  final company = Company(
    id: 1,
    name: 'LockerBox',
    siret: '12345678901234',
    siren: '123456789',
    ape: '5221Z',
    juridicForm: 'SAS',
    phone: '+33123456789',
    address: address,
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );

  final bay = LockerBay(
    id: 1,
    name: 'Gare de Lyon',
    latitude: 48.8443,
    longitude: 2.3744,
    company: company,
    maxDuration: 120,
    minDuration: 30,
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );

  const specSmall = Specification(
    id: 1,
    width: 30,
    height: 40,
    depth: 50,
    material: 'Acier',
    name: 'Small',
  );

  const specLargeRechargeable = Specification(
    id: 3,
    width: 50,
    height: 80,
    depth: 60,
    material: 'Acier renforcé',
    name: 'Large Rechargeable',
    isRechargeable: true,
  );

  Locker makeLocker({
    required int id,
    LockerStatus status = LockerStatus.available,
    int priceCents = 300,
    Specification specification = specSmall,
  }) {
    return Locker(
      id: id,
      number: id,
      specification: specification,
      priceCents: priceCents,
      lockerBay: bay,
      status: status,
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024),
    );
  }

  group('LockerBaySummary', () {
    test('totalCount returns the number of lockers', () {
      final summary = LockerBaySummary(
        lockerBay: bay,
        lockers: [makeLocker(id: 1), makeLocker(id: 2), makeLocker(id: 3)],
      );
      expect(summary.totalCount, 3);
    });

    test('availableCount counts only available lockers', () {
      final summary = LockerBaySummary(
        lockerBay: bay,
        lockers: [
          makeLocker(id: 1, status: LockerStatus.available),
          makeLocker(id: 2, status: LockerStatus.reserved),
          makeLocker(id: 3, status: LockerStatus.available),
          makeLocker(id: 4, status: LockerStatus.outOfOrder),
        ],
      );
      expect(summary.availableCount, 2);
    });

    test('minPriceCents returns the lowest price', () {
      final summary = LockerBaySummary(
        lockerBay: bay,
        lockers: [
          makeLocker(id: 1, priceCents: 500),
          makeLocker(id: 2, priceCents: 300),
          makeLocker(id: 3, priceCents: 800),
        ],
      );
      expect(summary.minPriceCents, 300);
    });

    test('maxPriceCents returns the highest price', () {
      final summary = LockerBaySummary(
        lockerBay: bay,
        lockers: [
          makeLocker(id: 1, priceCents: 500),
          makeLocker(id: 2, priceCents: 300),
          makeLocker(id: 3, priceCents: 800),
        ],
      );
      expect(summary.maxPriceCents, 800);
    });

    test('minPriceCents returns null when no lockers', () {
      final summary = LockerBaySummary(lockerBay: bay, lockers: const []);
      expect(summary.minPriceCents, isNull);
    });

    test('maxPriceCents returns null when no lockers', () {
      final summary = LockerBaySummary(lockerBay: bay, lockers: const []);
      expect(summary.maxPriceCents, isNull);
    });

    test('hasRechargeableLockers returns true when rechargeable exists', () {
      final summary = LockerBaySummary(
        lockerBay: bay,
        lockers: [
          makeLocker(id: 1),
          makeLocker(id: 2, specification: specLargeRechargeable),
        ],
      );
      expect(summary.hasRechargeableLockers, true);
    });

    test('hasRechargeableLockers returns false when none rechargeable', () {
      final summary = LockerBaySummary(
        lockerBay: bay,
        lockers: [makeLocker(id: 1), makeLocker(id: 2)],
      );
      expect(summary.hasRechargeableLockers, false);
    });

    test('city returns company address city', () {
      final summary = LockerBaySummary(lockerBay: bay, lockers: const []);
      expect(summary.city, 'Paris');
    });

    test('priceRange formats single price correctly', () {
      final summary = LockerBaySummary(
        lockerBay: bay,
        lockers: [
          makeLocker(id: 1, priceCents: 500),
          makeLocker(id: 2, priceCents: 500),
        ],
      );
      expect(summary.priceRange, '5.00\u00a0\u20ac');
    });

    test('priceRange formats range correctly', () {
      final summary = LockerBaySummary(
        lockerBay: bay,
        lockers: [
          makeLocker(id: 1, priceCents: 300),
          makeLocker(id: 2, priceCents: 800),
        ],
      );
      expect(summary.priceRange, '3.00\u00a0-\u00a08.00\u00a0\u20ac');
    });

    test('priceRange returns empty string when no lockers', () {
      final summary = LockerBaySummary(lockerBay: bay, lockers: const []);
      expect(summary.priceRange, '');
    });

    test('equality works based on lockerBay and locker count', () {
      final summary1 = LockerBaySummary(
        lockerBay: bay,
        lockers: [makeLocker(id: 1)],
      );
      final summary2 = LockerBaySummary(
        lockerBay: bay,
        lockers: [makeLocker(id: 2)],
      );
      expect(summary1, equals(summary2));
    });
  });
}
