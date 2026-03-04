import '../models/close_reservation_result.dart';
import '../models/payment_intent_result.dart';
import '../models/payment_sheet_result.dart';

abstract class PaymentService {
  Future<PaymentIntentResult> createPaymentIntent({
    required int lockerId,
    required DateTime startsAt,
    required DateTime endsAt,
  });

  Future<PaymentSheetResult> presentPaymentSheet({
    required String clientSecret,
  });

  Future<CloseReservationResult> closeReservation({required int reservationId});
}
