import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/features/payment/data/services/mock_payment_service.dart';
import 'package:locked_in_mobile/features/payment/domain/models/payment_intent_result.dart';
import 'package:locked_in_mobile/features/payment/domain/models/payment_sheet_result.dart';
import 'package:locked_in_mobile/features/payment/domain/models/close_reservation_result.dart';

void main() {
  late MockPaymentService service;

  setUp(() {
    service = MockPaymentService();
  });

  group('MockPaymentService', () {
    test('createPaymentIntent returns valid result', () async {
      final result = await service.createPaymentIntent(
        lockerId: 1,
        startsAt: DateTime(2026, 4, 1, 14, 0),
        endsAt: DateTime(2026, 4, 1, 15, 0),
      );

      expect(result, isA<PaymentIntentResult>());
      expect(result.clientSecret, startsWith('pi_mock_'));
      expect(result.amountCents, 500);
      expect(result.currency, 'eur');
      expect(result.status, 'requires_payment_method');
    });

    test('createPaymentIntent generates unique clientSecrets', () async {
      final result1 = await service.createPaymentIntent(
        lockerId: 1,
        startsAt: DateTime(2026, 4, 1, 14, 0),
        endsAt: DateTime(2026, 4, 1, 15, 0),
      );

      final result2 = await service.createPaymentIntent(
        lockerId: 2,
        startsAt: DateTime(2026, 4, 2, 10, 0),
        endsAt: DateTime(2026, 4, 2, 11, 0),
      );

      expect(result1.clientSecret, isNot(result2.clientSecret));
    });

    test('confirmCardPayment always returns success', () async {
      final result = await service.confirmCardPayment(
        clientSecret: 'pi_mock_123_secret',
      );

      expect(result.status, PaymentSheetStatus.success);
      expect(result.isSuccess, isTrue);
      expect(result.errorMessage, isNull);
    });

    test('closeReservation returns completed status', () async {
      final result = await service.closeReservation(reservationId: 42);

      expect(result, isA<CloseReservationResult>());
      expect(result.reservationId, 42);
      expect(result.status, 'completed');
      expect(result.hasOvertime, isFalse);
    });
  });

  group('PaymentSheetResult', () {
    test('isSuccess returns true for success status', () {
      const result = PaymentSheetResult(status: PaymentSheetStatus.success);
      expect(result.isSuccess, isTrue);
    });

    test('isSuccess returns false for failed status', () {
      const result = PaymentSheetResult(
        status: PaymentSheetStatus.failed,
        errorMessage: 'Card declined',
      );
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, 'Card declined');
    });

    test('isSuccess returns false for cancelled status', () {
      const result = PaymentSheetResult(status: PaymentSheetStatus.cancelled);
      expect(result.isSuccess, isFalse);
    });
  });

  group('CloseReservationResult', () {
    test('hasOvertime is true when overtimeMinutes > 0', () {
      const result = CloseReservationResult(
        reservationId: 1,
        status: 'completed',
        overtimeMinutes: 15,
        overtimeAmountCents: 200,
      );
      expect(result.hasOvertime, isTrue);
    });

    test('hasOvertime is false when overtimeMinutes is null', () {
      const result = CloseReservationResult(
        reservationId: 1,
        status: 'completed',
      );
      expect(result.hasOvertime, isFalse);
    });

    test('hasOvertime is false when overtimeMinutes is 0', () {
      const result = CloseReservationResult(
        reservationId: 1,
        status: 'completed',
        overtimeMinutes: 0,
      );
      expect(result.hasOvertime, isFalse);
    });
  });
}
