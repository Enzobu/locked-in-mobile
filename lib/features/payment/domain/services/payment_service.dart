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

  /// Confirms the card payment using the clientSecret
  /// (card details are collected via Stripe CardFormField widget)
  Future<PaymentSheetResult> confirmCardPayment({required String clientSecret});

  /// Closes a reservation (calculates overtime costs)
  Future<CloseReservationResult> closeReservation({required int reservationId});
}
