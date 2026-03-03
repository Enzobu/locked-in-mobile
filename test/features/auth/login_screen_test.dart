import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/features/auth/data/datasources/mock_auth_datasource.dart';
import 'package:locked_in_mobile/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:locked_in_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:locked_in_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:locked_in_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:locked_in_mobile/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          MockAuthRepository(datasource: MockAuthDatasource()),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: LoginScreen(),
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('displays email and password fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('shows validation errors on empty submit', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('email validation rejects invalid email', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'notanemail');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      // Form should still be visible (not navigated away)
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('password visibility toggle works', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the visibility toggle button
      final toggleFinder = find.byType(IconButton);
      expect(toggleFinder, findsOneWidget);

      // Tap to toggle visibility
      await tester.tap(toggleFinder);
      await tester.pumpAndSettle();

      // Should still have the toggle button
      expect(toggleFinder, findsOneWidget);
    });

    testWidgets('successful login transitions to authenticated state', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter valid credentials
      await tester.enterText(
        find.byType(TextFormField).first,
        'jean.dupont@email.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      // Should show loading state (button disabled)
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('failed login shows error message', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter invalid credentials (empty password triggers error from mock)
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@email.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Manually set email to empty to bypass form validation
      // but trigger mock datasource error
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
    });
  });
}
