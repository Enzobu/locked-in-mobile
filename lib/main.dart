import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'app/app.dart';
import 'core/network/api_constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = ApiConstants.stripePublishableKey;
  runApp(const ProviderScope(child: LockedInApp()));
}
