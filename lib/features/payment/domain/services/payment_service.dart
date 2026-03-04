import '../models/payment_result.dart';

abstract class PaymentService {
  Future<PaymentResult> processPayment({
    required int amountCents,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String cardHolder,
  });
}
