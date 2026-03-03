import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/address.dart';
import 'package:locked_in_mobile/core/models/customer.dart';
import 'package:locked_in_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:locked_in_mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:locked_in_mobile/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _testCustomer = Customer(
  id: 1,
  email: 'jean.dupont@email.com',
  firstname: 'Jean',
  lastname: 'Dupont',
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

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestWidget({Customer? customer}) {
    return ProviderScope(
      overrides: [authProvider.overrideWith(() => _FakeAuthNotifier(customer))],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('fr')],
        locale: Locale('fr'),
        home: ProfileScreen(),
      ),
    );
  }

  group('ProfileScreen', () {
    testWidgets('displays user initials in avatar', (tester) async {
      await tester.pumpWidget(createTestWidget(customer: _testCustomer));
      await tester.pumpAndSettle();

      expect(find.text('JD'), findsOneWidget);
    });

    testWidgets('displays user full name', (tester) async {
      await tester.pumpWidget(createTestWidget(customer: _testCustomer));
      await tester.pumpAndSettle();

      expect(find.text('Jean Dupont'), findsOneWidget);
    });

    testWidgets('displays user email', (tester) async {
      await tester.pumpWidget(createTestWidget(customer: _testCustomer));
      await tester.pumpAndSettle();

      expect(find.text('jean.dupont@email.com'), findsAtLeast(1));
    });

    testWidgets('displays section titles', (tester) async {
      await tester.pumpWidget(createTestWidget(customer: _testCustomer));
      await tester.pumpAndSettle();

      expect(find.text('Informations personnelles'), findsOneWidget);
      expect(find.text('Préférences'), findsOneWidget);
    });

    testWidgets('shows logout confirmation on logout tap', (tester) async {
      await tester.pumpWidget(createTestWidget(customer: _testCustomer));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Déconnexion').first,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Déconnexion').first);
      await tester.pumpAndSettle();

      expect(
        find.text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        findsOneWidget,
      );
    });

    testWidgets('displays placeholder when no customer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('?'), findsOneWidget);
      expect(find.text('-'), findsAtLeast(1));
    });
  });
}
