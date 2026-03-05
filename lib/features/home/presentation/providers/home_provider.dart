import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/models/locker.dart';
import '../../../../core/network/dio_client.dart';
import '../../../map/presentation/providers/geolocation_provider.dart';
import '../../data/datasources/api_locker_bay_datasource.dart';
import '../../data/datasources/locker_bay_datasource.dart';
import '../../data/repositories/locker_bay_repository_impl.dart';
import '../../domain/models/locker_bay_summary.dart';
import '../../domain/models/locker_filter.dart';
import '../../domain/repositories/locker_bay_repository.dart';

final lockerBayDatasourceProvider = Provider<LockerBayDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ApiLockerBayDatasource(dioClient: dioClient);
});

final lockerBayRepositoryProvider = Provider<LockerBayRepository>((ref) {
  final datasource = ref.watch(lockerBayDatasourceProvider);
  return LockerBayRepositoryImpl(datasource: datasource);
});

final lockerBaySummariesProvider =
    AsyncNotifierProvider<LockerBaySummariesNotifier, List<LockerBaySummary>>(
      LockerBaySummariesNotifier.new,
    );

class LockerBaySummariesNotifier extends AsyncNotifier<List<LockerBaySummary>> {
  @override
  Future<List<LockerBaySummary>> build() => _fetchSummaries();

  LockerBayRepository get _repository => ref.read(lockerBayRepositoryProvider);

  Future<List<LockerBaySummary>> _fetchSummaries() async {
    final bays = await _repository.getLockerBays();
    final allLockers = await _repository.getAllLockers();

    // Group lockers by bay id
    final lockersByBay = <int, List<Locker>>{};
    for (final locker in allLockers) {
      lockersByBay.putIfAbsent(locker.lockerBay.id, () => []).add(locker);
    }

    return bays.map((bay) => LockerBaySummary(
      lockerBay: bay,
      lockers: lockersByBay[bay.id] ?? [],
    )).toList();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchSummaries);
  }
}

final searchQueryProvider = StateProvider<String>((ref) => '');

final _debouncedSearchQueryProvider = StateProvider<String>((ref) => '');

final searchDebounceProvider = Provider<_SearchDebounce>((ref) {
  final debounce = _SearchDebounce(ref);
  ref.onDispose(debounce.dispose);
  return debounce;
});

class _SearchDebounce {
  _SearchDebounce(this._ref);

  final Ref _ref;
  Timer? _timer;

  void onQueryChanged(String query) {
    _timer?.cancel();
    if (query.isEmpty) {
      _ref.read(_debouncedSearchQueryProvider.notifier).state = '';
      return;
    }
    _timer = Timer(const Duration(milliseconds: 300), () {
      _ref.read(_debouncedSearchQueryProvider.notifier).state = query;
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}

final lockerFilterProvider = StateProvider<LockerFilter>(
  (ref) => LockerFilter.empty,
);

final availableMaterialsProvider = Provider<Set<String>>((ref) {
  final summariesAsync = ref.watch(lockerBaySummariesProvider);
  return summariesAsync.whenOrNull(
        data: (summaries) {
          final materials = <String>{};
          for (final summary in summaries) {
            for (final locker in summary.lockers) {
              materials.add(locker.specification.material);
            }
          }
          return materials;
        },
      ) ??
      {};
});

final priceRangeProvider = Provider<(int, int)>((ref) {
  final summariesAsync = ref.watch(lockerBaySummariesProvider);
  return summariesAsync.whenOrNull(
        data: (summaries) {
          var min = 0x7FFFFFFF;
          var max = 0;
          for (final summary in summaries) {
            for (final locker in summary.lockers) {
              if (locker.priceCents < min) min = locker.priceCents;
              if (locker.priceCents > max) max = locker.priceCents;
            }
          }
          if (min > max) return (0, 0);
          return (min, max);
        },
      ) ??
      (0, 0);
});

bool _lockerMatchesFilter(Locker locker, LockerFilter filter) {
  if (filter.minPriceCents != null &&
      locker.priceCents < filter.minPriceCents!) {
    return false;
  }
  if (filter.maxPriceCents != null &&
      locker.priceCents > filter.maxPriceCents!) {
    return false;
  }
  if (filter.sizes.isNotEmpty) {
    final lockerSize = LockerSize.fromHeight(locker.specification.height);
    if (!filter.sizes.contains(lockerSize)) return false;
  }
  if (filter.materials.isNotEmpty) {
    if (!filter.materials.contains(locker.specification.material)) return false;
  }
  if (filter.rechargeableOnly && !locker.specification.isRechargeable) {
    return false;
  }
  return true;
}

bool _summaryMatchesFilter(LockerBaySummary summary, LockerFilter filter) {
  return summary.lockers.any((locker) => _lockerMatchesFilter(locker, filter));
}

bool _summaryMatchesQuery(LockerBaySummary summary, String query) {
  final bay = summary.lockerBay;
  final name = bay.name.toLowerCase();
  final city = summary.city.toLowerCase();
  final companyName = bay.company?.name.toLowerCase() ?? '';
  final street = bay.company?.address.street.toLowerCase() ?? '';
  return name.contains(query) ||
      city.contains(query) ||
      companyName.contains(query) ||
      street.contains(query);
}

final lockerBayDetailProvider = FutureProvider.family<LockerBaySummary, int>((
  ref,
  id,
) async {
  final repository = ref.watch(lockerBayRepositoryProvider);
  final bay = await repository.getLockerBayById(id);
  final lockers = await repository.getLockersByBayId(id);
  return LockerBaySummary(lockerBay: bay, lockers: lockers);
});

/// Computes distances (in km) from the user to each locker bay.
/// Returns a `Map<int, double>` (bayId → distance in km).
final bayDistancesProvider = Provider<Map<int, double>>((ref) {
  final geoState = ref.watch(geolocationProvider);
  final summariesAsync = ref.watch(lockerBaySummariesProvider);

  if (!geoState.hasPosition) return {};

  final userPos = geoState.position!;
  return summariesAsync.whenOrNull(
        data: (summaries) {
          final distances = <int, double>{};
          for (final summary in summaries) {
            final bayPos = LatLng(
              summary.lockerBay.latitude,
              summary.lockerBay.longitude,
            );
            distances[summary.lockerBay.id] = distanceKm(userPos, bayPos);
          }
          return distances;
        },
      ) ??
      {};
});

/// Returns a formatted distance string for a specific bay.
final formattedDistanceProvider = Provider.family<String?, int>((ref, bayId) {
  final distances = ref.watch(bayDistancesProvider);
  final km = distances[bayId];
  if (km == null) return null;
  return formatDistance(km);
});

/// Groups all summaries by city, sorted alphabetically.
final citySummariesProvider =
    Provider<Map<String, List<LockerBaySummary>>>((ref) {
  final filtered = ref.watch(filteredSummariesProvider);
  return filtered.whenOrNull(
        data: (summaries) {
          final grouped = <String, List<LockerBaySummary>>{};
          for (final s in summaries) {
            final city = s.city.isNotEmpty ? s.city : '?';
            grouped.putIfAbsent(city, () => []).add(s);
          }
          return Map.fromEntries(
            grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
          );
        },
      ) ??
      {};
});

final filteredSummariesProvider = Provider<AsyncValue<List<LockerBaySummary>>>((
  ref,
) {
  final query = ref.watch(_debouncedSearchQueryProvider).toLowerCase();
  final filter = ref.watch(lockerFilterProvider);
  final summariesAsync = ref.watch(lockerBaySummariesProvider);

  if (query.isEmpty && !filter.isActive) return summariesAsync;

  return summariesAsync.whenData((summaries) {
    return summaries.where((summary) {
      if (query.isNotEmpty && !_summaryMatchesQuery(summary, query)) {
        return false;
      }
      if (filter.isActive && !_summaryMatchesFilter(summary, filter)) {
        return false;
      }
      return true;
    }).toList();
  });
});
