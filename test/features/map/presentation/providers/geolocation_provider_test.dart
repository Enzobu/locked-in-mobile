import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:locked_in_mobile/features/map/presentation/providers/geolocation_provider.dart';

void main() {
  group('GeolocationState', () {
    test('default state has initial status and no position', () {
      const state = GeolocationState();

      expect(state.status, GeolocationStatus.initial);
      expect(state.position, isNull);
      expect(state.hasPosition, isFalse);
    });

    test('hasPosition returns true when position is set', () {
      const state = GeolocationState(
        status: GeolocationStatus.granted,
        position: LatLng(48.8566, 2.3522),
      );

      expect(state.hasPosition, isTrue);
    });

    test('copyWith updates status', () {
      const state = GeolocationState();
      final updated = state.copyWith(status: GeolocationStatus.loading);

      expect(updated.status, GeolocationStatus.loading);
      expect(updated.position, isNull);
    });

    test('copyWith updates position', () {
      const state = GeolocationState();
      const pos = LatLng(45.0, 3.0);
      final updated = state.copyWith(position: pos);

      expect(updated.position, pos);
      expect(updated.status, GeolocationStatus.initial);
    });

    test('copyWith preserves existing values when not specified', () {
      const state = GeolocationState(
        status: GeolocationStatus.granted,
        position: LatLng(48.8566, 2.3522),
      );
      final updated = state.copyWith(status: GeolocationStatus.denied);

      expect(updated.status, GeolocationStatus.denied);
      expect(updated.position?.latitude, closeTo(48.86, 0.01));
    });
  });

  group('GeolocationNotifier', () {
    test('initial state is initial with no position', () {
      final notifier = GeolocationNotifier();

      expect(notifier.state.status, GeolocationStatus.initial);
      expect(notifier.state.hasPosition, isFalse);
    });

    test('defaultPosition is Paris', () {
      expect(
        GeolocationNotifier.defaultPosition.latitude,
        closeTo(48.86, 0.01),
      );
      expect(
        GeolocationNotifier.defaultPosition.longitude,
        closeTo(2.35, 0.01),
      );
    });
  });

  group('distanceKm', () {
    test('distance between same point is 0', () {
      const point = LatLng(48.8566, 2.3522);
      expect(distanceKm(point, point), 0.0);
    });

    test('Paris to Lyon is approximately 392 km', () {
      const paris = LatLng(48.8566, 2.3522);
      const lyon = LatLng(45.7640, 4.8357);
      final distance = distanceKm(paris, lyon);

      expect(distance, closeTo(392, 20));
    });

    test('Paris to Marseille is approximately 660 km', () {
      const paris = LatLng(48.8566, 2.3522);
      const marseille = LatLng(43.2965, 5.3698);
      final distance = distanceKm(paris, marseille);

      expect(distance, closeTo(660, 30));
    });

    test('short distance (< 1 km) is calculated correctly', () {
      const pointA = LatLng(48.8566, 2.3522);
      const pointB = LatLng(48.8576, 2.3532);
      final distance = distanceKm(pointA, pointB);

      expect(distance, lessThan(1.0));
      expect(distance, greaterThan(0.0));
    });

    test('distance is symmetric', () {
      const paris = LatLng(48.8566, 2.3522);
      const lyon = LatLng(45.7640, 4.8357);

      expect(distanceKm(paris, lyon), closeTo(distanceKm(lyon, paris), 0.001));
    });
  });

  group('formatDistance', () {
    test('formats meters for distances < 1 km', () {
      expect(formatDistance(0.5), '500 m');
      expect(formatDistance(0.150), '150 m');
      expect(formatDistance(0.012), '12 m');
    });

    test('formats with one decimal for distances < 10 km', () {
      expect(formatDistance(1.5), '1.5 km');
      expect(formatDistance(9.9), '9.9 km');
      expect(formatDistance(3.14), '3.1 km');
    });

    test('formats rounded for distances >= 10 km', () {
      expect(formatDistance(10.0), '10 km');
      expect(formatDistance(42.7), '43 km');
      expect(formatDistance(392.0), '392 km');
    });

    test('formats 0 meters correctly', () {
      expect(formatDistance(0.0), '0 m');
    });
  });

}
