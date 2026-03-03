import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/network/token_storage.dart';
import 'package:locked_in_mobile/features/auth/data/datasources/mock_auth_datasource.dart';
import 'package:locked_in_mobile/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:locked_in_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:locked_in_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          MockAuthRepository(datasource: MockAuthDatasource()),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthNotifier', () {
    test('initial state is initial then becomes unauthenticated', () async {
      final state = container.read(authProvider);
      expect(state.status, AuthStatus.initial);

      // Wait for async _checkAuth to complete
      await Future<void>.delayed(const Duration(milliseconds: 300));

      final updatedState = container.read(authProvider);
      expect(updatedState.status, AuthStatus.unauthenticated);
    });

    test('login with valid credentials sets authenticated state', () async {
      // Wait for initial check
      await Future<void>.delayed(const Duration(milliseconds: 300));

      await container
          .read(authProvider.notifier)
          .login('jean.dupont@email.com', 'password123');

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.customer, isNotNull);
      expect(state.customer!.email, 'jean.dupont@email.com');
    });

    test('login with empty email sets error state', () async {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      await container.read(authProvider.notifier).login('', 'password123');

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, isNotNull);
    });

    test('login with short password sets error state', () async {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      await container.read(authProvider.notifier).login('test@test.com', '123');

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.error);
    });

    test('login saves token to storage', () async {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      await container
          .read(authProvider.notifier)
          .login('jean.dupont@email.com', 'password123');

      final tokenStorage = container.read(tokenStorageProvider);
      final token = await tokenStorage.getAccessToken();
      expect(token, isNotNull);
      expect(token, contains('mock_jwt_token'));
    });

    test('logout clears state and token', () async {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      // Login first
      await container
          .read(authProvider.notifier)
          .login('jean.dupont@email.com', 'password123');
      expect(container.read(authProvider).status, AuthStatus.authenticated);

      // Logout
      await container.read(authProvider.notifier).logout();

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.customer, isNull);

      final tokenStorage = container.read(tokenStorageProvider);
      final token = await tokenStorage.getAccessToken();
      expect(token, isNull);
    });
  });

  group('AuthState', () {
    test('copyWith preserves unchanged values', () {
      const state = AuthState(status: AuthStatus.authenticated);
      final copied = state.copyWith(errorMessage: 'test');
      expect(copied.status, AuthStatus.authenticated);
      expect(copied.errorMessage, 'test');
    });

    test('copyWith clears errorMessage when null passed', () {
      const state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'some error',
      );
      final copied = state.copyWith(status: AuthStatus.loading);
      expect(copied.errorMessage, isNull);
    });
  });
}
