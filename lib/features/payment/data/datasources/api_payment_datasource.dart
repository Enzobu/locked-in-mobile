import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import 'payment_datasource.dart';

class ApiPaymentDatasource implements PaymentDatasource {
  const ApiPaymentDatasource({required DioClient client}) : _client = client;

  final DioClient _client;

  @override
  Future<Map<String, dynamic>> createPaymentIntent({
    required int lockerId,
    required String startsAt,
    required String endsAt,
  }) async {
    final response = await _client.post(
      ApiConstants.paymentIntents,
      data: {
        'locker': ApiConstants.lockerIri(lockerId),
        'startsAt': startsAt,
        'endsAt': endsAt,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> closeReservation(int reservationId) async {
    final response = await _client.post(
      ApiConstants.closeReservation(reservationId),
    );
    return response.data as Map<String, dynamic>;
  }
}
