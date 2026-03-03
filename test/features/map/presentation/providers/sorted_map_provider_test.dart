import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:locked_in_mobile/core/models/locker_bay.dart';
import 'package:locked_in_mobile/features/home/domain/models/locker_bay_summary.dart';
import 'package:locked_in_mobile/features/map/presentation/providers/geolocation_provider.dart';
import 'package:locked_in_mobile/features/map/presentation/providers/map_provider.dart';

/// A test notifier that starts with a given state.
class _TestGeolocationNotifier extends GeolocationNotifier {
  _TestGeolocationNotifier(GeolocationState initialState) {
    state = initialState;
  }
}

/// Creates a minimal LockerBaySummary for testing with given coordinates.
LockerBaySummary _makeSummary(int id, String name, double lat, double lng) {
  return LockerBaySummary(
    lockerBay: LockerBay(id: id, name: name, latitude: lat, longitude: lng),
    lockers: const [],
  );
}

void main() {
  group('sortedMapLockerBaySummariesProvider', () {
    late ProviderContainer container;

    final paris = _makeSummary(1, 'Paris', 48.8566, 2.3522);
    final lyon = _makeSummary(2, 'Lyon', 45.7640, 4.8357);
    final marseille = _makeSummary(3, 'Marseille', 43.2965, 5.3698);
    final testSummaries = [marseille, paris, lyon]; // Not sorted by proximity

    tearDown(() {
      container.dispose();
    });

    test('returns unsorted when sort mode is default', () {
      container = ProviderContainer(
        overrides: [
          mapLockerBaySummariesProvider.overrideWithValue(
            AsyncValue.data(testSummaries),
          ),
          sortModeProvider.overrideWith((ref) => SortMode.defaultSort),
        ],
      );

      final result = container.read(sortedMapLockerBaySummariesProvider);

      expect(result.value, testSummaries);
      expect(result.value![0].lockerBay.name, 'Marseille');
      expect(result.value![1].lockerBay.name, 'Paris');
      expect(result.value![2].lockerBay.name, 'Lyon');
    });

    test('returns unsorted when proximity mode but no position', () {
      container = ProviderContainer(
        overrides: [
          mapLockerBaySummariesProvider.overrideWithValue(
            AsyncValue.data(testSummaries),
          ),
          sortModeProvider.overrideWith((ref) => SortMode.proximity),
          geolocationProvider.overrideWith((ref) => GeolocationNotifier()),
        ],
      );

      final result = container.read(sortedMapLockerBaySummariesProvider);

      expect(result.value![0].lockerBay.name, 'Marseille');
    });

    test('sorts by proximity when mode is proximity and position available', () {
      // User is in Lyon
      container = ProviderContainer(
        overrides: [
          mapLockerBaySummariesProvider.overrideWithValue(
            AsyncValue.data(testSummaries),
          ),
          sortModeProvider.overrideWith((ref) => SortMode.proximity),
          geolocationProvider.overrideWith(
            (ref) => _TestGeolocationNotifier(
              const GeolocationState(
                status: GeolocationStatus.granted,
                position: LatLng(45.7640, 4.8357),
              ),
            ),
          ),
        ],
      );

      final result = container.read(sortedMapLockerBaySummariesProvider);
      final sorted = result.value!;

      // Lyon should be first (closest to user in Lyon), then Marseille, then Paris
      expect(sorted[0].lockerBay.name, 'Lyon');
      expect(sorted[1].lockerBay.name, 'Marseille');
      expect(sorted[2].lockerBay.name, 'Paris');
    });

    test('sorts correctly when user is in Paris', () {
      container = ProviderContainer(
        overrides: [
          mapLockerBaySummariesProvider.overrideWithValue(
            AsyncValue.data(testSummaries),
          ),
          sortModeProvider.overrideWith((ref) => SortMode.proximity),
          geolocationProvider.overrideWith(
            (ref) => _TestGeolocationNotifier(
              const GeolocationState(
                status: GeolocationStatus.granted,
                position: LatLng(48.8566, 2.3522),
              ),
            ),
          ),
        ],
      );

      final result = container.read(sortedMapLockerBaySummariesProvider);
      final sorted = result.value!;

      // Paris closest, then Lyon, then Marseille
      expect(sorted[0].lockerBay.name, 'Paris');
      expect(sorted[1].lockerBay.name, 'Lyon');
      expect(sorted[2].lockerBay.name, 'Marseille');
    });

    test('does not mutate original list', () {
      container = ProviderContainer(
        overrides: [
          mapLockerBaySummariesProvider.overrideWithValue(
            AsyncValue.data(testSummaries),
          ),
          sortModeProvider.overrideWith((ref) => SortMode.proximity),
          geolocationProvider.overrideWith(
            (ref) => _TestGeolocationNotifier(
              const GeolocationState(
                status: GeolocationStatus.granted,
                position: LatLng(48.8566, 2.3522),
              ),
            ),
          ),
        ],
      );

      container.read(sortedMapLockerBaySummariesProvider);

      // Original list should be unchanged
      expect(testSummaries[0].lockerBay.name, 'Marseille');
      expect(testSummaries[1].lockerBay.name, 'Paris');
      expect(testSummaries[2].lockerBay.name, 'Lyon');
    });

    test('propagates loading state', () {
      container = ProviderContainer(
        overrides: [
          mapLockerBaySummariesProvider.overrideWithValue(
            const AsyncValue<List<LockerBaySummary>>.loading(),
          ),
        ],
      );

      final result = container.read(sortedMapLockerBaySummariesProvider);

      expect(result.isLoading, isTrue);
    });

    test('propagates error state', () {
      container = ProviderContainer(
        overrides: [
          mapLockerBaySummariesProvider.overrideWithValue(
            AsyncValue<List<LockerBaySummary>>.error(
              Exception('test'),
              StackTrace.current,
            ),
          ),
        ],
      );

      final result = container.read(sortedMapLockerBaySummariesProvider);

      expect(result.hasError, isTrue);
    });
  });

  group('sortModeProvider', () {
    test('defaults to defaultSort', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(sortModeProvider), SortMode.defaultSort);
    });

    test('can be toggled to proximity', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(sortModeProvider.notifier).state = SortMode.proximity;

      expect(container.read(sortModeProvider), SortMode.proximity);
    });
  });
}
