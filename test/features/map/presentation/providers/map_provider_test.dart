import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:locked_in_mobile/features/home/data/datasources/mock_locker_bay_datasource.dart';
import 'package:locked_in_mobile/features/home/data/repositories/mock_locker_bay_repository.dart';
import 'package:locked_in_mobile/features/home/presentation/providers/home_provider.dart';
import 'package:locked_in_mobile/features/map/presentation/providers/map_provider.dart';

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

  group('mapCenterProvider', () {
    test('has default center at France', () {
      final center = container.read(mapCenterProvider);

      expect(center.latitude, closeTo(46.6, 0.1));
      expect(center.longitude, closeTo(1.9, 0.1));
    });

    test('can be updated', () {
      container.read(mapCenterProvider.notifier).state = const LatLng(
        48.8566,
        2.3522,
      );
      final center = container.read(mapCenterProvider);

      expect(center.latitude, closeTo(48.9, 0.1));
      expect(center.longitude, closeTo(2.4, 0.1));
    });
  });

  group('mapZoomProvider', () {
    test('has default zoom of 6', () {
      final zoom = container.read(mapZoomProvider);

      expect(zoom, 6.0);
    });
  });

  group('selectedLockerBayProvider', () {
    test('is null by default', () {
      final selected = container.read(selectedLockerBayProvider);

      expect(selected, isNull);
    });

    test('can select and deselect a locker bay', () async {
      final summaries = await container.read(lockerBaySummariesProvider.future);
      final first = summaries.first;

      container.read(selectedLockerBayProvider.notifier).state = first;
      expect(container.read(selectedLockerBayProvider), first);

      container.read(selectedLockerBayProvider.notifier).state = null;
      expect(container.read(selectedLockerBayProvider), isNull);
    });
  });

  group('mapLockerBaySummariesProvider', () {
    test('returns same data as lockerBaySummariesProvider', () async {
      final summaries = await container.read(lockerBaySummariesProvider.future);
      final mapSummaries = container.read(mapLockerBaySummariesProvider);

      expect(mapSummaries.value, summaries);
    });

    test('summaries have valid coordinates', () async {
      final summaries = await container.read(lockerBaySummariesProvider.future);

      for (final summary in summaries) {
        expect(summary.lockerBay.latitude, inInclusiveRange(-90.0, 90.0));
        expect(summary.lockerBay.longitude, inInclusiveRange(-180.0, 180.0));
      }
    });
  });
}
