import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/features/payment/data/services/mock_payment_service.dart';
import 'package:locked_in_mobile/features/payment/domain/models/payment_result.dart';

void main() {
  late MockPaymentService service;

  setUp(() {
    service = MockPaymentService();
  });

  group('MockPaymentService', () {
    test('processPayment always returns success', () async {
      final result = await service.processPayment(
        amountCents: 500,
        cardNumber: '4242424242424242',
        expiryDate: '12/28',
        cvv: '123',
        cardHolder: 'JOHN DOE',
      );

      expect(result.status, PaymentStatus.success);
      expect(result.isSuccess, isTrue);
      expect(result.transactionId, startsWith('TXN-'));
      expect(result.errorMessage, isNull);
    });

    test('generates unique transaction IDs', () async {
      final result1 = await service.processPayment(
        amountCents: 500,
        cardNumber: '4242424242424242',
        expiryDate: '12/28',
        cvv: '123',
        cardHolder: 'JOHN DOE',
      );

      final result2 = await service.processPayment(
        amountCents: 1000,
        cardNumber: '5555555555554444',
        expiryDate: '01/29',
        cvv: '456',
        cardHolder: 'JANE DOE',
      );

      expect(result1.transactionId, isNot(result2.transactionId));
    });
  });

  group('PaymentResult', () {
    test('isSuccess returns true for success status', () {
      const result = PaymentResult(
        status: PaymentStatus.success,
        transactionId: 'TXN-123',
      );
      expect(result.isSuccess, isTrue);
    });

    test('isSuccess returns false for failed status', () {
      const result = PaymentResult(
        status: PaymentStatus.failed,
        transactionId: '',
        errorMessage: 'Insufficient funds',
      );
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, 'Insufficient funds');
    });

    test('isSuccess returns false for cancelled status', () {
      const result = PaymentResult(
        status: PaymentStatus.cancelled,
        transactionId: '',
      );
      expect(result.isSuccess, isFalse);
    });
  });
}
