import '../../../../core/models/reservation.dart';

abstract class ReservationRepository {
  Future<List<Reservation>> getReservations();

  Future<Reservation> getReservationById(int id);

  Future<Reservation> createReservation({
    required int lockerId,
    required DateTime startsAt,
    required DateTime endsAt,
  });

  Future<void> cancelReservation(int id);
}
