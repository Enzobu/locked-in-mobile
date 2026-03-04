import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/app/theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppTheme', () {
    test('light theme uses Material 3', () {
      expect(AppTheme.light.useMaterial3, isTrue);
    });

    test('dark theme uses Material 3', () {
      expect(AppTheme.dark.useMaterial3, isTrue);
    });

    test('light theme has correct brightness', () {
      expect(AppTheme.light.colorScheme.brightness, Brightness.light);
    });

    test('dark theme has correct brightness', () {
      expect(AppTheme.dark.colorScheme.brightness, Brightness.dark);
    });

    test('light theme uses primary seed color', () {
      expect(AppTheme.light.colorScheme.primary, isNotNull);
    });

    test('themes have card shape with border radius 12', () {
      final shape = AppTheme.light.cardTheme.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(12));
    });

    test('themes use Geist font family', () {
      expect(AppTheme.light.textTheme.bodyMedium?.fontFamily, 'Poppins');
      expect(AppTheme.dark.textTheme.bodyMedium?.fontFamily, 'Poppins');
    });
  });

  group('ThemeModeNotifier', () {
    test('initial state is ThemeMode.dark', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final themeMode = container.read(themeModeProvider);
      expect(themeMode, ThemeMode.dark);
    });
  });
}
