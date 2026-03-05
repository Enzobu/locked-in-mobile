import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/locker_status.dart';
import 'package:locked_in_mobile/features/home/data/datasources/mock_locker_bay_datasource.dart';
import 'package:locked_in_mobile/features/home/data/repositories/locker_bay_repository_impl.dart';
import 'package:locked_in_mobile/features/home/presentation/providers/home_provider.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        lockerBayDatasourceProvider.overrideWithValue(
          MockLockerBayDatasource(),
        ),
        lockerBayRepositoryProvider.overrideWith((ref) {
          final ds = ref.watch(lockerBayDatasourceProvider);
          return LockerBayRepositoryImpl(datasource: ds);
        }),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('lockerBayDetailProvider', () {
    test('loads a locker bay by id with lockers', () async {
      final summary = await container.read(lockerBayDetailProvider(1).future);

      expect(summary.lockerBay.id, 1);
      expect(summary.lockerBay.name, isNotEmpty);
      expect(summary.lockers, isNotEmpty);
    });

    test('summary has correct computed properties', () async {
      final summary = await container.read(lockerBayDetailProvider(1).future);

      expect(summary.totalCount, summary.lockers.length);
      expect(
        summary.availableCount,
        summary.lockers.where((l) => l.status == LockerStatus.available).length,
      );
    });

    test('lockers have valid specifications', () async {
      final summary = await container.read(lockerBayDetailProvider(1).future);

      for (final locker in summary.lockers) {
        expect(locker.specification.width, greaterThan(0));
        expect(locker.specification.height, greaterThan(0));
        expect(locker.specification.depth, greaterThan(0));
        expect(locker.specification.material, isNotEmpty);
        expect(locker.priceCents, greaterThan(0));
      }
    });

    test('lockers have valid status', () async {
      final summary = await container.read(lockerBayDetailProvider(1).future);

      for (final locker in summary.lockers) {
        expect(LockerStatus.values, contains(locker.status));
      }
    });

    test('price range is computed from lockers', () async {
      final summary = await container.read(lockerBayDetailProvider(1).future);

      if (summary.lockers.isNotEmpty) {
        expect(summary.minPriceCents, isNotNull);
        expect(summary.maxPriceCents, isNotNull);
        expect(
          summary.minPriceCents!,
          lessThanOrEqualTo(summary.maxPriceCents!),
        );
        expect(summary.priceRange, isNotEmpty);
      }
    });

    test('different bay ids return different data', () async {
      final summary1 = await container.read(lockerBayDetailProvider(1).future);
      final summary2 = await container.read(lockerBayDetailProvider(2).future);

      expect(summary1.lockerBay.id, isNot(summary2.lockerBay.id));
    });
  });
}
