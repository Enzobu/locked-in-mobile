import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/reservation.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/api_reservation_datasource.dart';
import '../../data/datasources/reservation_datasource.dart';
import '../../data/repositories/mock_reservation_repository.dart';
import '../../domain/repositories/reservation_repository.dart';

final reservationDatasourceProvider = Provider<ReservationDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ApiReservationDatasource(dioClient: dioClient);
});

final reservationRepositoryProvider = Provider<ReservationRepository>((ref) {
  final datasource = ref.watch(reservationDatasourceProvider);
  return MockReservationRepository(datasource: datasource);
});

final reservationsProvider =
    AsyncNotifierProvider<ReservationsNotifier, List<Reservation>>(
      ReservationsNotifier.new,
    );

class ReservationsNotifier extends AsyncNotifier<List<Reservation>> {
  @override
  Future<List<Reservation>> build() => _fetch();

  ReservationRepository get _repository =>
      ref.read(reservationRepositoryProvider);

  Future<List<Reservation>> _fetch() async {
    return _repository.getReservations();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> cancelReservation(int id) async {
    await _repository.cancelReservation(id);
    state = await AsyncValue.guard(_fetch);
  }
}
