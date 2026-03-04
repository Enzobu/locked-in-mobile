import 'package:flutter_stripe/flutter_stripe.dart';

import '../../domain/models/close_reservation_result.dart';
import '../../domain/models/payment_intent_result.dart';
import '../../domain/models/payment_sheet_result.dart';
import '../../domain/services/payment_service.dart';
import '../datasources/payment_datasource.dart';

class StripePaymentService implements PaymentService {
  const StripePaymentService({required PaymentDatasource datasource})
    : _datasource = datasource;

  final PaymentDatasource _datasource;

  @override
  Future<PaymentIntentResult> createPaymentIntent({
    required int lockerId,
    required DateTime startsAt,
    required DateTime endsAt,
  }) async {
    final data = await _datasource.createPaymentIntent(
      lockerId: lockerId,
      startsAt: startsAt.toIso8601String(),
      endsAt: endsAt.toIso8601String(),
    );

    return PaymentIntentResult(
      clientSecret: data['clientSecret'] as String,
      reservationId: data['reservationId'] as int,
      amountCents: data['amountCents'] as int,
      currency: data['currency'] as String,
      status: data['status'] as String,
    );
  }

  @override
  Future<PaymentSheetResult> presentPaymentSheet({
    required String clientSecret,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Locked In',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return const PaymentSheetResult(status: PaymentSheetStatus.success);
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return const PaymentSheetResult(status: PaymentSheetStatus.cancelled);
      }
      return PaymentSheetResult(
        status: PaymentSheetStatus.failed,
        errorMessage: e.error.localizedMessage,
      );
    }
  }

  @override
  Future<CloseReservationResult> closeReservation({
    required int reservationId,
  }) async {
    final data = await _datasource.closeReservation(reservationId);

    return CloseReservationResult(
      reservationId: data['reservationId'] as int,
      status: data['status'] as String,
      overtimeMinutes: data['overtimeMinutes'] as int?,
      overtimeAmountCents: data['overtimeAmountCents'] as int?,
      overtimePaymentStatus: data['overtimePaymentStatus'] as String?,
    );
  }
}
