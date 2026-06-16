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

    test('isActive returns true when rechargeableOnly is true', () {
      const filter = LockerFilter(rechargeableOnly: true);
      expect(filter.isActive, true);
    });

    test('isActive returns true when maxDistanceKm is set', () {
      const filter = LockerFilter(maxDistanceKm: 5.0);
      expect(filter.isActive, true);
    });

    test('activeFilterCount counts each active category', () {
      const filter = LockerFilter(
        minPriceCents: 100,
        sizes: {LockerSize.small},
        rechargeableOnly: true,
        maxDistanceKm: 10.0,
      );
      expect(filter.activeFilterCount, 4);
    });

    test(
      'activeFilterCount counts price as one even with both min and max',
      () {
        const filter = LockerFilter(minPriceCents: 100, maxPriceCents: 500);
        expect(filter.activeFilterCount, 1);
      },
    );

    test('activeFilterCount returns 1 for single size filter', () {
      const filter = LockerFilter(sizes: {LockerSize.medium});
      expect(filter.activeFilterCount, 1);
    });

    test('activeFilterCount returns 1 for distance only', () {
      const filter = LockerFilter(maxDistanceKm: 3.0);
      expect(filter.activeFilterCount, 1);
    });

    test('activeFilterCount returns 1 for rechargeable only', () {
      const filter = LockerFilter(rechargeableOnly: true);
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

    test('copyWith can set maxDistanceKm', () {
      final updated = LockerFilter.empty.copyWith(maxDistanceKm: () => 5.0);
      expect(updated.maxDistanceKm, 5.0);
      expect(updated.isActive, true);
    });

    test('copyWith can clear maxDistanceKm', () {
      const original = LockerFilter(maxDistanceKm: 5.0);
      final updated = original.copyWith(maxDistanceKm: () => null);
      expect(updated.maxDistanceKm, isNull);
      expect(updated.isActive, false);
    });

    test('equality works correctly', () {
      const a = LockerFilter(minPriceCents: 100, sizes: {LockerSize.small});
      const b = LockerFilter(minPriceCents: 100, sizes: {LockerSize.small});
      expect(a, equals(b));
    });

    test('inequality works correctly', () {
      const a = LockerFilter(minPriceCents: 100);
      const b = LockerFilter(minPriceCents: 200);
      expect(a, isNot(equals(b)));
    });

    test('equality considers maxDistanceKm', () {
      const a = LockerFilter(maxDistanceKm: 5.0);
      const b = LockerFilter(maxDistanceKm: 5.0);
      const c = LockerFilter(maxDistanceKm: 10.0);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });

  group('Filtering logic', () {
    final lockerCheapSmall = makeLocker(
      id: 1,
      priceCents: 300,
      specification: specSmall,
    );
    final lockerMidMedium = makeLocker(
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
        lockerCheapSmall,
        lockerMidMedium,
        lockerExpensiveLargeRechargeable,
      ],
    );

    bool lockerMatchesFilter(Locker locker, LockerFilter filter) {
      if (filter.minPriceCents != null &&
          locker.priceCents < filter.minPriceCents!) {
        return false;
      }
      if (filter.maxPriceCents != null &&
          locker.priceCents > filter.maxPriceCents!) {
        return false;
      }
      if (filter.sizes.isNotEmpty) {
        final size = LockerSize.fromHeight(locker.specification.height);
        if (!filter.sizes.contains(size)) return false;
      }
      if (filter.rechargeableOnly && !locker.specification.isRechargeable) {
        return false;
      }
      return true;
    }

    bool summaryMatchesFilter(LockerBaySummary s, LockerFilter filter) {
      if (!filter.isActive) return true;
      return s.lockers.any((locker) => lockerMatchesFilter(locker, filter));
    }

    test('empty filter matches all summaries', () {
      expect(summaryMatchesFilter(summary, LockerFilter.empty), true);
    });

    test('price filter excludes lockers outside range', () {
      const filter = LockerFilter(minPriceCents: 500, maxPriceCents: 800);
      expect(summaryMatchesFilter(summary, filter), true);

      const tooExpensive = LockerFilter(minPriceCents: 1500);
      expect(summaryMatchesFilter(summary, tooExpensive), false);
    });

    test('minPrice filter only', () {
      const filter = LockerFilter(minPriceCents: 600);
      // medium (600) and large (1200) match
      expect(summaryMatchesFilter(summary, filter), true);

      const tooHigh = LockerFilter(minPriceCents: 1500);
      expect(summaryMatchesFilter(summary, tooHigh), false);
    });

    test('maxPrice filter only', () {
      const filter = LockerFilter(maxPriceCents: 400);
      // cheap small (300) matches
      expect(summaryMatchesFilter(summary, filter), true);

      const tooLow = LockerFilter(maxPriceCents: 100);
      expect(summaryMatchesFilter(summary, tooLow), false);
    });

    test('size filter matches lockers of selected sizes', () {
      const filterSmall = LockerFilter(sizes: {LockerSize.small});
      expect(summaryMatchesFilter(summary, filterSmall), true);

      const filterLarge = LockerFilter(sizes: {LockerSize.large});
      expect(summaryMatchesFilter(summary, filterLarge), true);
    });

    test('rechargeable filter matches only rechargeable lockers', () {
      const filter = LockerFilter(rechargeableOnly: true);
      expect(summaryMatchesFilter(summary, filter), true);

      final nonRechargeableSummary = LockerBaySummary(
        lockerBay: bay,
        lockers: [lockerCheapSmall, lockerMidMedium],
      );
      expect(summaryMatchesFilter(nonRechargeableSummary, filter), false);
    });

    test('combined filters are AND-ed per locker', () {
      // Large + Rechargeable: the large rechargeable locker matches both
      const filter = LockerFilter(
        sizes: {LockerSize.large},
        rechargeableOnly: true,
      );
      expect(summaryMatchesFilter(summary, filter), true);

      // Small + Rechargeable: no locker is both small AND rechargeable
      const impossible = LockerFilter(
        sizes: {LockerSize.small},
        rechargeableOnly: true,
      );
      expect(summaryMatchesFilter(summary, impossible), false);
    });

    test('multi-select sizes are OR-ed within the filter', () {
      const filter = LockerFilter(sizes: {LockerSize.small, LockerSize.large});
      expect(summaryMatchesFilter(summary, filter), true);
    });

    test('bay matches if at least one locker passes all criteria', () {
      // Price 300-400 + Small size → only the cheap small locker
      const filter = LockerFilter(
        maxPriceCents: 400,
        sizes: {LockerSize.small},
      );
      expect(summaryMatchesFilter(summary, filter), true);

      // Price 300-400 + Large size → no locker matches both
      const noMatch = LockerFilter(
        maxPriceCents: 400,
        sizes: {LockerSize.large},
      );
      expect(summaryMatchesFilter(summary, noMatch), false);
    });

    test('price + rechargeable combined', () {
      // Rechargeable locker costs 1200, so max 1000 excludes it
      const filter = LockerFilter(maxPriceCents: 1000, rechargeableOnly: true);
      expect(summaryMatchesFilter(summary, filter), false);

      // Max 1500 includes the rechargeable locker
      const filterOk = LockerFilter(
        maxPriceCents: 1500,
        rechargeableOnly: true,
      );
      expect(summaryMatchesFilter(summary, filterOk), true);
    });

    test('all filters combined - match', () {
      // Large + rechargeable + price 1000-1500 → the 1200 large rechargeable
      const filter = LockerFilter(
        minPriceCents: 1000,
        maxPriceCents: 1500,
        sizes: {LockerSize.large},
        rechargeableOnly: true,
      );
      expect(summaryMatchesFilter(summary, filter), true);
    });

    test('all filters combined - no match', () {
      // Small + rechargeable + cheap → impossible combination
      const filter = LockerFilter(
        maxPriceCents: 400,
        sizes: {LockerSize.small},
        rechargeableOnly: true,
      );
      expect(summaryMatchesFilter(summary, filter), false);
    });

    test('summary with single locker - matches filter', () {
      final singleSummary = LockerBaySummary(
        lockerBay: bay,
        lockers: [lockerCheapSmall],
      );
      const filter = LockerFilter(maxPriceCents: 500);
      expect(summaryMatchesFilter(singleSummary, filter), true);
    });

    test('summary with single locker - does not match filter', () {
      final singleSummary = LockerBaySummary(
        lockerBay: bay,
        lockers: [lockerCheapSmall],
      );
      const filter = LockerFilter(minPriceCents: 500);
      expect(summaryMatchesFilter(singleSummary, filter), false);
    });

    test('empty summary never matches active filter', () {
      const emptySummary = LockerBaySummary(lockerBay: bay, lockers: []);
      const filter = LockerFilter(maxPriceCents: 5000);
      expect(summaryMatchesFilter(emptySummary, filter), false);
    });
  });
}
