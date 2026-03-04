import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/address.dart';
import 'package:locked_in_mobile/core/models/customer.dart';
import 'package:locked_in_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:locked_in_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:locked_in_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:locked_in_mobile/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:locked_in_mobile/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _testCustomer = Customer(
  id: 1,
  email: 'jean.dupont@email.com',
  firstname: 'Jean',
  lastname: 'Dupont',
  phone: '+33612345678',
  birthDate: DateTime(1995, 6, 15),
  addresses: const [
    Address(
      id: 1,
      number: '22',
      city: 'Paris',
      country: 'France',
      street: 'Rue de Test',
    ),
  ],
  createdAt: DateTime(2025, 1, 10),
  updatedAt: DateTime(2026, 2, 15),
);

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier(this._customer);

  final Customer? _customer;

  @override
  AuthState build() {
    return AuthState(
      status: _customer != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated,
      customer: _customer,
    );
  }
}

class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository(this._customer);

  final Customer _customer;

  @override
  Future<Customer> getProfile() async => _customer;

  @override
  Future<Customer> updateProfile({
    required String firstname,
    required String lastname,
    required String email,
    String? phone,
  }) async {
    return _customer.copyWith(
      firstname: firstname,
      lastname: lastname,
      email: email,
      phone: phone,
    );
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestWidget({Customer? customer}) {
    return ProviderScope(
      overrides: [
        authProvider.overrideWith(() => _FakeAuthNotifier(customer)),
        profileRepositoryProvider.overrideWithValue(
          _FakeProfileRepository(customer ?? _testCustomer),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('fr')],
        locale: Locale('fr'),
        home: EditProfileScreen(),
      ),
    );
  }

  group('EditProfileScreen', () {
    testWidgets('pre-fills form fields with customer data', (tester) async {
      await tester.pumpWidget(createTestWidget(customer: _testCustomer));
      await tester.pumpAndSettle();

      expect(find.text('Jean'), findsOneWidget);
      expect(find.text('Dupont'), findsOneWidget);
      expect(find.text('jean.dupont@email.com'), findsOneWidget);
      expect(find.text('+33612345678'), findsOneWidget);
    });

    testWidgets('shows validation errors on empty required fields', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(customer: _testCustomer));
      await tester.pumpAndSettle();

      // Clear firstname field
      final firstnameField = find.text('Jean');
      await tester.tap(firstnameField);
      await tester.pumpAndSettle();
      await tester.enterText(firstnameField, '');
      await tester.pumpAndSettle();

      // Clear lastname field
      final lastnameField = find.text('Dupont');
      await tester.tap(lastnameField);
      await tester.pumpAndSettle();
      await tester.enterText(lastnameField, '');
      await tester.pumpAndSettle();

      // Tap save button
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      expect(find.text('Le prénom est requis'), findsOneWidget);
      expect(find.text('Le nom est requis'), findsOneWidget);
    });

    testWidgets('shows validation error for invalid email', (tester) async {
      await tester.pumpWidget(createTestWidget(customer: _testCustomer));
      await tester.pumpAndSettle();

      final emailField = find.text('jean.dupont@email.com');
      await tester.tap(emailField);
      await tester.pumpAndSettle();
      await tester.enterText(emailField, 'invalid-email');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      expect(find.text("L'email n'est pas valide"), findsOneWidget);
    });

    testWidgets('displays save button in app bar', (tester) async {
      await tester.pumpWidget(createTestWidget(customer: _testCustomer));
      await tester.pumpAndSettle();

      expect(find.text('Enregistrer'), findsOneWidget);
    });

    testWidgets('displays edit profile title', (tester) async {
      await tester.pumpWidget(createTestWidget(customer: _testCustomer));
      await tester.pumpAndSettle();

      expect(find.text('Modifier le profil'), findsOneWidget);
    });

    testWidgets('displays phone field', (tester) async {
      await tester.pumpWidget(createTestWidget(customer: _testCustomer));
      await tester.pumpAndSettle();

      expect(find.text('Téléphone'), findsOneWidget);
    });
  });
}
