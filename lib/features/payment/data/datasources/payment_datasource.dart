abstract class PaymentDatasource {
  Future<Map<String, dynamic>> createPaymentIntent({
    required int lockerId,
    required String startsAt,
    required String endsAt,
  });

  Future<Map<String, dynamic>> closeReservation(int reservationId);
}
