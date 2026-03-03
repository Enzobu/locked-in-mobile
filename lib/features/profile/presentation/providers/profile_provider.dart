import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/customer.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final currentCustomerProvider = Provider<Customer?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.customer;
});
