import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/api_payment_datasource.dart';
import '../../data/datasources/payment_datasource.dart';
import '../../data/services/mock_payment_service.dart';
import '../../data/services/stripe_payment_service.dart';
import '../../domain/services/payment_service.dart';

/// Set to true to use the real Stripe payment flow.
/// Requires the backend to have STRIPE_SECRET_KEY configured.
const _useStripe = false;

final paymentDatasourceProvider = Provider<PaymentDatasource>((ref) {
  final client = ref.watch(dioClientProvider);
  return ApiPaymentDatasource(client: client);
});

final paymentServiceProvider = Provider<PaymentService>((ref) {
  if (_useStripe) {
    final datasource = ref.watch(paymentDatasourceProvider);
    return StripePaymentService(datasource: datasource);
  }
  return MockPaymentService();
});
