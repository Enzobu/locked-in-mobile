import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/api_payment_datasource.dart';
import '../../data/datasources/payment_datasource.dart';
import '../../data/services/stripe_payment_service.dart';
import '../../domain/services/payment_service.dart';

final paymentDatasourceProvider = Provider<PaymentDatasource>((ref) {
  final client = ref.watch(dioClientProvider);
  return ApiPaymentDatasource(client: client);
});

final paymentServiceProvider = Provider<PaymentService>((ref) {
  final datasource = ref.watch(paymentDatasourceProvider);
  return StripePaymentService(datasource: datasource);
});
