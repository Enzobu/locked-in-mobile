import '../../../../core/dtos/reservation_dto.dart';
import '../../../../core/models/reservation.dart';
import '../../domain/repositories/reservation_repository.dart';
import '../datasources/reservation_datasource.dart';

class MockReservationRepository implements ReservationRepository {
  const MockReservationRepository({required this.datasource});

  final ReservationDatasource datasource;

  @override
  Future<List<Reservation>> getReservations() async {
    final data = await datasource.getReservations();
    return data
        .map((json) => ReservationDto.fromJson(json).toDomain())
        .toList();
  }

  @override
  Future<Reservation> getReservationById(int id) async {
    final data = await datasource.getReservationById(id);
    return ReservationDto.fromJson(data).toDomain();
  }

  @override
  Future<Reservation> createReservation({
    required int lockerId,
    required DateTime startsAt,
    required DateTime endsAt,
  }) async {
    final data = await datasource.createReservation(
      lockerId: lockerId,
      startsAt: startsAt.toIso8601String(),
      endsAt: endsAt.toIso8601String(),
    );
    return ReservationDto.fromJson(data).toDomain();
  }

  @override
  Future<void> cancelReservation(int id) async {
    await datasource.cancelReservation(id);
  }
}
