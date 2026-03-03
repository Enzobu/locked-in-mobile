import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/address.dart';
import 'package:locked_in_mobile/core/models/company.dart';
import 'package:locked_in_mobile/core/models/locker.dart';
import 'package:locked_in_mobile/core/models/locker_bay.dart';
import 'package:locked_in_mobile/core/models/specification.dart';
import 'package:locked_in_mobile/features/home/domain/models/locker_bay_summary.dart';
import 'package:locked_in_mobile/features/home/domain/models/locker_filter.dart';

void main() {
  const address = Address(
    id: 1,
    city: 'Paris',
    country: 'France',
    street: 'Rue de Rivoli',
    number: '12',
  );

  const company = Company(
    id: 1,
    name: 'LockerBox',
    siren: '123456789',
    address: address,
  );

  const bay = LockerBay(
    id: 1,
    name: 'Gare de Lyon',
    latitude: 48.8443,
    longitude: 2.3744,
    company: company,
    maxDuration: 120,
    minDuration: 30,
  );

  const specSmall = Specification(
    id: 1,
    width: 30,
    height: 40,
    depth: 50,
    material: 'Acier',
    name: 'Small',
  );

  const specMedium = Specification(
    id: 2,
    width: 40,
    height: 60,
    depth: 55,
    material: 'Aluminium',
    name: 'Medium',
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
    int priceCents = 300,
    Specification specification = specSmall,
  }) {
    return Locker(
      id: id,
      number: id,
      specification: specification,
      priceCents: priceCents,
      lockerBay: bay,
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024),
    );
  }

  group('LockerSize', () {
    test('fromHeight returns small for height <= 40', () {
      expect(LockerSize.fromHeight(30), LockerSize.small);
      expect(LockerSize.fromHeight(40), LockerSize.small);
    });

    test('fromHeight returns medium for height <= 60', () {
      expect(LockerSize.fromHeight(41), LockerSize.medium);
      expect(LockerSize.fromHeight(60), LockerSize.medium);
    });

    test('fromHeight returns large for height > 60', () {
      expect(LockerSize.fromHeight(61), LockerSize.large);
      expect(LockerSize.fromHeight(80), LockerSize.large);
    });
  });

  group('LockerFilter', () {
    test('empty filter is not active', () {
      expect(LockerFilter.empty.isActive, false);
      expect(LockerFilter.empty.activeFilterCount, 0);
    });

    test('isActive returns true when minPriceCents is set', () {
      const filter = LockerFilter(minPriceCents: 100);
      expect(filter.isActive, true);
    });

    test('isActive returns true when maxPriceCents is set', () {
      const filter = LockerFilter(maxPriceCents: 500);
      expect(filter.isActive, true);
    });

    test('isActive returns true when sizes is not empty', () {
      const filter = LockerFilter(sizes: {LockerSize.small});
      expect(filter.isActive, true);
    });

    test('isActive returns true when materials is not empty', () {
      const filter = LockerFilter(materials: {'Acier'});
      expect(filter.isActive, true);
    });

    test('isActive returns true when rechargeableOnly is true', () {
      const filter = LockerFilter(rechargeableOnly: true);
      expect(filter.isActive, true);
    });

    test('activeFilterCount counts each active category', () {
      const filter = LockerFilter(
        minPriceCents: 100,
        sizes: {LockerSize.small},
        materials: {'Acier'},
        rechargeableOnly: true,
      );
      expect(filter.activeFilterCount, 4);
    });

    test('activeFilterCount counts price as one even with both min and max',
        () {
      const filter = LockerFilter(minPriceCents: 100, maxPriceCents: 500);
      expect(filter.activeFilterCount, 1);
    });

    test('copyWith creates new instance with updated values', () {
      const original = LockerFilter(
        minPriceCents: 100,
        rechargeableOnly: false,
      );
      final updated = original.copyWith(
        minPriceCents: () => 200,
        rechargeableOnly: true,
      );
      expect(updated.minPriceCents, 200);
      expect(updated.rechargeableOnly, true);
      expect(original.minPriceCents, 100);
    });

    test('copyWith can set nullable fields to null', () {
      const original = LockerFilter(minPriceCents: 100);
      final updated = original.copyWith(minPriceCents: () => null);
      expect(updated.minPriceCents, isNull);
    });

    test('equality works correctly', () {
      const a = LockerFilter(
        minPriceCents: 100,
        sizes: {LockerSize.small},
      );
      const b = LockerFilter(
        minPriceCents: 100,
        sizes: {LockerSize.small},
      );
      expect(a, equals(b));
    });

    test('inequality works correctly', () {
      const a = LockerFilter(minPriceCents: 100);
      const b = LockerFilter(minPriceCents: 200);
      expect(a, isNot(equals(b)));
    });
  });

  group('Filtering logic', () {
    final lockerCheapSmallSteel = makeLocker(
      id: 1,
      priceCents: 300,
      specification: specSmall,
    );
    final lockerMidMediumAluminium = makeLocker(
      id: 2,
      priceCents: 600,
      specification: specMedium,
    );
    final lockerExpensiveLargeRechargeable = makeLocker(
      id: 3,
      priceCents: 1200,
      specification: specLargeRechargeable,
    );

    final summary = LockerBaySummary(
      lockerBay: bay,
      lockers: [
        lockerCheapSmallSteel,
        lockerMidMediumAluminium,
        lockerExpensiveLargeRechargeable,
      ],
    );

    bool summaryMatchesFilter(LockerBaySummary s, LockerFilter filter) {
      if (!filter.isActive) return true;
      return s.lockers.any((locker) {
        if (filter.minPriceCents != null &&
            locker.priceCents < filter.minPriceCents!) return false;
        if (filter.maxPriceCents != null &&
            locker.priceCents > filter.maxPriceCents!) return false;
        if (filter.sizes.isNotEmpty) {
          final size = LockerSize.fromHeight(locker.specification.height);
          if (!filter.sizes.contains(size)) return false;
        }
        if (filter.materials.isNotEmpty &&
            !filter.materials.contains(locker.specification.material)) {
          return false;
        }
        if (filter.rechargeableOnly && !locker.specification.isRechargeable) {
          return false;
        }
        return true;
      });
    }

    test('empty filter matches all summaries', () {
      expect(summaryMatchesFilter(summary, LockerFilter.empty), true);
    });

    test('price filter excludes lockers outside range', () {
      const filter = LockerFilter(minPriceCents: 500, maxPriceCents: 800);
      expect(summaryMatchesFilter(summary, filter), true);

      // Only the medium locker (600) matches
      const tooExpensive = LockerFilter(minPriceCents: 1500);
      expect(summaryMatchesFilter(summary, tooExpensive), false);
    });

    test('size filter matches lockers of selected sizes', () {
      const filterSmall = LockerFilter(sizes: {LockerSize.small});
      expect(summaryMatchesFilter(summary, filterSmall), true);

      const filterLarge = LockerFilter(sizes: {LockerSize.large});
      expect(summaryMatchesFilter(summary, filterLarge), true);
    });

    test('material filter matches lockers with selected materials', () {
      const filterSteel = LockerFilter(materials: {'Acier'});
      expect(summaryMatchesFilter(summary, filterSteel), true);

      const filterUnknown = LockerFilter(materials: {'Bois'});
      expect(summaryMatchesFilter(summary, filterUnknown), false);
    });

    test('rechargeable filter matches only rechargeable lockers', () {
      const filter = LockerFilter(rechargeableOnly: true);
      expect(summaryMatchesFilter(summary, filter), true);

      final nonRechargeableSummary = LockerBaySummary(
        lockerBay: bay,
        lockers: [lockerCheapSmallSteel, lockerMidMediumAluminium],
      );
      expect(summaryMatchesFilter(nonRechargeableSummary, filter), false);
    });

    test('combined filters are AND-ed', () {
      // Large + Rechargeable: only the large rechargeable locker matches
      const filter = LockerFilter(
        sizes: {LockerSize.large},
        rechargeableOnly: true,
      );
      expect(summaryMatchesFilter(summary, filter), true);

      // Small + Rechargeable: no locker is both small and rechargeable
      const impossible = LockerFilter(
        sizes: {LockerSize.small},
        rechargeableOnly: true,
      );
      expect(summaryMatchesFilter(summary, impossible), false);
    });

    test('multi-select within a filter is OR-ed', () {
      const filter = LockerFilter(
        sizes: {LockerSize.small, LockerSize.large},
      );
      expect(summaryMatchesFilter(summary, filter), true);
    });

    test('bay matches if at least one locker passes all criteria', () {
      // Price 300-400 + Material Acier → only the cheap small steel locker
      const filter = LockerFilter(
        maxPriceCents: 400,
        materials: {'Acier'},
      );
      expect(summaryMatchesFilter(summary, filter), true);

      // Price 300-400 + Material Aluminium → no locker matches both
      const noMatch = LockerFilter(
        maxPriceCents: 400,
        materials: {'Aluminium'},
      );
      expect(summaryMatchesFilter(summary, noMatch), false);
    });
  });
}
