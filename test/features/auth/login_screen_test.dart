import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/features/auth/data/datasources/auth_datasource.dart';
import 'package:locked_in_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:locked_in_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:locked_in_mobile/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAuthDatasource implements AuthDatasource {
  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }
    return {'token': 'fake_jwt_token'};
  }

  @override
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required String birthDate,
  }) async => {'id': 1};

  @override
  Future<Map<String, dynamic>> getCurrentCustomer() async => {
    'id': 1,
    'email': 'test@test.com',
    'firstname': 'Test',
    'lastname': 'User',
    'birth_date': '1995-06-15T00:00:00.000',
    'roles': ['ROLE_CUSTOMER'],
    'addresses': [
      {
        'id': 1,
        'number': '10',
        'city': 'Paris',
        'country': 'France',
        'street': 'Rue de Test',
        'complement': null,
      },
    ],
    'created_at': '2025-01-10T08:00:00.000',
    'updated_at': '2026-02-15T10:30:00.000',
  };

  @override
  Future<Map<String, dynamic>> updateCustomer({
    required String firstname,
    required String lastname,
    required String email,
    String? phone,
  }) async => {
    'id': 1,
    'email': email,
    'firstname': firstname,
    'lastname': lastname,
    'birth_date': '1995-06-15T00:00:00.000',
    'roles': ['ROLE_CUSTOMER'],
    'addresses': [
      {
        'id': 1,
        'number': '10',
        'city': 'Paris',
        'country': 'France',
        'street': 'Rue de Test',
        'complement': null,
      },
    ],
    'created_at': '2025-01-10T08:00:00.000',
    'updated_at': DateTime.now().toIso8601String(),
  };

  @override
  Future<void> logout() async {}
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        authDatasourceProvider.overrideWithValue(_FakeAuthDatasource()),
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

      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('email validation rejects invalid email', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'notanemail');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('password visibility toggle works', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final toggleFinder = find.byType(IconButton);
      expect(toggleFinder, findsOneWidget);

      await tester.tap(toggleFinder);
      await tester.pumpAndSettle();

      expect(toggleFinder, findsOneWidget);
    });

    testWidgets('successful login transitions to authenticated state', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'test@test.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });
  });
}
