import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../home/domain/models/locker_bay_summary.dart';
import '../../../home/presentation/providers/home_provider.dart';
import 'geolocation_provider.dart';

final mapCenterProvider = StateProvider<LatLng>(
  (ref) => const LatLng(46.603354, 1.888334),
);

final mapZoomProvider = StateProvider<double>((ref) => 6.0);

final selectedLockerBayProvider = StateProvider<LockerBaySummary?>(
  (ref) => null,
);

final mapLockerBaySummariesProvider =
    Provider<AsyncValue<List<LockerBaySummary>>>((ref) {
      return ref.watch(lockerBaySummariesProvider);
    });

/// Summaries sorted by proximity when sort mode is proximity and position available.
final sortedMapLockerBaySummariesProvider =
    Provider<AsyncValue<List<LockerBaySummary>>>((ref) {
  final summariesAsync = ref.watch(mapLockerBaySummariesProvider);
  final sortMode = ref.watch(sortModeProvider);
  final geoState = ref.watch(geolocationProvider);

  return summariesAsync.whenData((summaries) {
    if (sortMode == SortMode.proximity && geoState.hasPosition) {
      final userPos = geoState.position!;
      final sorted = List<LockerBaySummary>.from(summaries)..sort((a, b) {
        final distA = distanceKm(
          userPos,
          LatLng(a.lockerBay.latitude, a.lockerBay.longitude),
        );
        final distB = distanceKm(
          userPos,
          LatLng(b.lockerBay.latitude, b.lockerBay.longitude),
        );
        return distA.compareTo(distB);
      });
      return sorted;
    }
    return summaries;
  });
});
