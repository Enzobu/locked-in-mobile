import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/app/router.dart';
import 'package:locked_in_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:locked_in_mobile/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestApp({AuthState? initialAuthState}) {
    return ProviderScope(
      overrides: [
        if (initialAuthState != null)
          authProvider.overrideWith(() {
            return _FakeAuthNotifier(initialAuthState);
          }),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final router = ref.watch(routerProvider);
          return MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('fr'),
          );
        },
      ),
    );
  }

  group('Router with auth', () {
    testWidgets('redirects to login when unauthenticated', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          initialAuthState: const AuthState(status: AuthStatus.unauthenticated),
        ),
      );
      await tester.pumpAndSettle();

      // Should show login screen
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('shows navigation when authenticated', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          initialAuthState: const AuthState(status: AuthStatus.authenticated),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationDestination), findsNWidgets(4));
    });

    testWidgets('navigates between tabs when authenticated', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          initialAuthState: const AuthState(status: AuthStatus.authenticated),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Carte'));
      await tester.pumpAndSettle();
      expect(find.text('Carte'), findsWidgets);

      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle();
      expect(find.text('Profil'), findsWidgets);
    });
  });
}

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier(this._initialState);

  final AuthState _initialState;

  @override
  AuthState build() {
    return _initialState;
  }
}
