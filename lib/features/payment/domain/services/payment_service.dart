import '../models/close_reservation_result.dart';
import '../models/payment_intent_result.dart';
import '../models/payment_sheet_result.dart';

abstract class PaymentService {
  /// Creates a PaymentIntent on the backend and returns the clientSecret
  Future<PaymentIntentResult> createPaymentIntent({
    required int lockerId,
    required DateTime startsAt,
    required DateTime endsAt,
  });

  /// Presents the Stripe PaymentSheet to the user
  Future<PaymentSheetResult> presentPaymentSheet({
    required String clientSecret,
  });

  /// Closes a reservation (calculates overtime costs)
  Future<CloseReservationResult> closeReservation({
    required int reservationId,
  });
}
