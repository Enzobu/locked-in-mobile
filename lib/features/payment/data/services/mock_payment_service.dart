import '../../domain/models/payment_result.dart';
import '../../domain/services/payment_service.dart';

class MockPaymentService implements PaymentService {
  @override
  Future<PaymentResult> processPayment({
    required int amountCents,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String cardHolder,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock always succeeds
    return PaymentResult(
      status: PaymentStatus.success,
      transactionId:
          'TXN-${DateTime.now().millisecondsSinceEpoch.toRadixString(36).toUpperCase()}',
    );
  }
}
