import '../../domain/models/close_reservation_result.dart';
import '../../domain/models/payment_intent_result.dart';
import '../../domain/models/payment_sheet_result.dart';
import '../../domain/services/payment_service.dart';

class MockPaymentService implements PaymentService {
  @override
  Future<PaymentIntentResult> createPaymentIntent({
    required int lockerId,
    required DateTime startsAt,
    required DateTime endsAt,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return PaymentIntentResult(
      clientSecret: 'pi_mock_${DateTime.now().millisecondsSinceEpoch}_secret',
      reservationId: DateTime.now().millisecondsSinceEpoch % 10000,
      amountCents: 500,
      currency: 'eur',
      status: 'requires_payment_method',
    );
  }

  @override
  Future<PaymentSheetResult> confirmCardPayment({
    required String clientSecret,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    return const PaymentSheetResult(status: PaymentSheetStatus.success);
  }

  @override
  Future<CloseReservationResult> closeReservation({
    required int reservationId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return CloseReservationResult(
      reservationId: reservationId,
      status: 'completed',
    );
  }
}
