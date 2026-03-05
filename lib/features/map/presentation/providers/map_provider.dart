import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../home/domain/models/locker_bay_summary.dart';
import '../../../home/presentation/providers/home_provider.dart';

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
