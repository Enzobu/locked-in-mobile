import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/api_locker_bay_datasource.dart';
import '../../data/datasources/locker_bay_datasource.dart';
import '../../data/repositories/mock_locker_bay_repository.dart';
import '../../domain/models/locker_bay_summary.dart';
import '../../domain/repositories/locker_bay_repository.dart';

final lockerBayDatasourceProvider = Provider<LockerBayDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ApiLockerBayDatasource(dioClient: dioClient);
});

final lockerBayRepositoryProvider = Provider<LockerBayRepository>((ref) {
  final datasource = ref.watch(lockerBayDatasourceProvider);
  return MockLockerBayRepository(datasource: datasource);
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
    final summaries = <LockerBaySummary>[];

    for (final bay in bays) {
      final lockers = await _repository.getLockersByBayId(bay.id);
      summaries.add(LockerBaySummary(lockerBay: bay, lockers: lockers));
    }

    return summaries;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchSummaries);
  }
}
