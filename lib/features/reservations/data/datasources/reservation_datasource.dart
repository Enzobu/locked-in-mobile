abstract class ReservationDatasource {
  Future<List<Map<String, dynamic>>> getReservations();

  Future<Map<String, dynamic>> getReservationById(int id);

  Future<Map<String, dynamic>> createReservation({
    required int lockerId,
    required String startsAt,
    required String endsAt,
  });

  Future<void> cancelReservation(int id);
}
