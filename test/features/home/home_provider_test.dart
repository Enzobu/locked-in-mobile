import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/locker.dart';
import 'package:locked_in_mobile/core/models/locker_bay.dart';
import 'package:locked_in_mobile/features/home/data/datasources/mock_locker_bay_datasource.dart';
import 'package:locked_in_mobile/features/home/data/repositories/mock_locker_bay_repository.dart';
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
          return MockLockerBayRepository(datasource: ds);
        }),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('LockerBaySummariesNotifier', () {
    test('loads locker bay summaries on build', () async {
      final future = container.read(lockerBaySummariesProvider.future);
      final summaries = await future;

      expect(summaries, isNotEmpty);
      expect(summaries.length, 12);
    });

    test('each summary has lockers', () async {
      final summaries = await container.read(lockerBaySummariesProvider.future);

      for (final summary in summaries) {
        expect(summary.lockers, isNotEmpty);
        expect(summary.totalCount, greaterThan(0));
      }
    });

    test('summaries contain correct locker bay data', () async {
      final summaries = await container.read(lockerBaySummariesProvider.future);

      final first = summaries.first;
      expect(first.lockerBay.name, 'Gare de Lyon');
      expect(first.city, 'Paris');
    });

    test('refresh reloads data', () async {
      final summaries1 = await container.read(
        lockerBaySummariesProvider.future,
      );

      await container.read(lockerBaySummariesProvider.notifier).refresh();

      final summaries2 = await container.read(
        lockerBaySummariesProvider.future,
      );

      expect(summaries2.length, summaries1.length);
    });

    test('available count is computed correctly', () async {
      final summaries = await container.read(lockerBaySummariesProvider.future);

      for (final summary in summaries) {
        expect(summary.availableCount, lessThanOrEqualTo(summary.totalCount));
      }
    });
  });

  group('LockerBayRepository', () {
    test('getLockerBays returns all bays', () async {
      final repo = container.read(lockerBayRepositoryProvider);
      final bays = await repo.getLockerBays();

      expect(bays, isA<List<LockerBay>>());
      expect(bays.length, 12);
    });

    test('getLockersByBayId returns lockers for a bay', () async {
      final repo = container.read(lockerBayRepositoryProvider);
      final lockers = await repo.getLockersByBayId(1);

      expect(lockers, isA<List<Locker>>());
      expect(lockers, isNotEmpty);
    });

    test('searchLockerBays filters by query', () async {
      final repo = container.read(lockerBayRepositoryProvider);
      final results = await repo.searchLockerBays('Lyon');

      expect(results, isNotEmpty);
      for (final bay in results) {
        final matches =
            bay.name.toLowerCase().contains('lyon') ||
            bay.company?.address.city.toLowerCase().contains('lyon') == true;
        expect(matches, true);
      }
    });
  });
}
