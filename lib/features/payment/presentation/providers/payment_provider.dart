import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/mock_payment_service.dart';
import '../../domain/services/payment_service.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return MockPaymentService();
});
