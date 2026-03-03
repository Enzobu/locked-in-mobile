import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/app/locale_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/shared_preferences'),
          (call) async {
            if (call.method == 'getAll') return <String, dynamic>{};
            if (call.method == 'setString') return true;
            return null;
          },
        );
  });

  group('LocaleNotifier', () {
    test('initial locale is French', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final locale = container.read(localeProvider);
      expect(locale, const Locale('fr'));
    });

    test('setLocale updates state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(localeProvider.notifier);
      await notifier.setLocale(const Locale('en'));
      expect(container.read(localeProvider), const Locale('en'));
    });
  });

  group('supportedLocales', () {
    test('contains 4 locales', () {
      expect(supportedLocales, hasLength(4));
    });

    test('contains fr, en, de, it', () {
      expect(
        supportedLocales.map((l) => l.languageCode),
        containsAll(['fr', 'en', 'de', 'it']),
      );
    });
  });
}
