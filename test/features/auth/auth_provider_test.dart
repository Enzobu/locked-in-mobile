import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/network/api_exception.dart';
import 'package:locked_in_mobile/core/network/token_storage.dart';
import 'package:locked_in_mobile/features/auth/data/datasources/auth_datasource.dart';
import 'package:locked_in_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAuthDatasource implements AuthDatasource {
  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }
    if (email == 'wrong@test.com') {
      throw const ApiException(
        statusCode: 401,
        message: 'Invalid credentials.',
      );
    }
    if (password.length < 6) {
      throw Exception('Invalid credentials');
    }
    return {'token': 'fake_jwt_token_for_$email'};
  }

  @override
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required String birthDate,
    required String phone,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (email.isEmpty || password.isEmpty) {
      throw Exception('All fields are required');
    }
    if (email == 'existing@test.com') {
      throw const ApiException(
        statusCode: 422,
        message: 'Email already exists',
      );
    }
    return {'id': 1, 'email': email};
  }

  @override
  Future<Map<String, dynamic>> getCurrentCustomer() async {
    return {
      'id': 1,
      'email': 'test@test.com',
      'firstname': 'Test',
      'lastname': 'User',
    };
  }

  @override
  Future<void> logout() async {}
}

void main() {
  late ProviderContainer container;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    container = ProviderContainer(
      overrides: [
        authDatasourceProvider.overrideWithValue(_FakeAuthDatasource()),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthNotifier - login', () {
    test('initial state is initial then becomes unauthenticated', () async {
      final state = container.read(authProvider);
      expect(state.status, AuthStatus.initial);

      await Future<void>.delayed(const Duration(milliseconds: 300));

      final updatedState = container.read(authProvider);
      expect(updatedState.status, AuthStatus.unauthenticated);
    });

    test('login with valid credentials sets authenticated state', () async {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      await container
          .read(authProvider.notifier)
          .login('test@test.com', 'password123');

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.authenticated);
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

    test(
      'login with wrong credentials sets error with invalidCredentials',
      () async {
        await Future<void>.delayed(const Duration(milliseconds: 300));

        await container
            .read(authProvider.notifier)
            .login('wrong@test.com', 'password123');

        final state = container.read(authProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'invalidCredentials');
      },
    );

    test('login saves token to storage', () async {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      await container
          .read(authProvider.notifier)
          .login('test@test.com', 'password123');

      final tokenStorage = container.read(tokenStorageProvider);
      final token = await tokenStorage.getAccessToken();
      expect(token, isNotNull);
      expect(token, contains('fake_jwt_token'));
    });

    test('logout clears state and token', () async {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      await container
          .read(authProvider.notifier)
          .login('test@test.com', 'password123');
      expect(container.read(authProvider).status, AuthStatus.authenticated);

      await container.read(authProvider.notifier).logout();

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);

      final tokenStorage = container.read(tokenStorageProvider);
      final token = await tokenStorage.getAccessToken();
      expect(token, isNull);
    });
  });

  group('AuthNotifier - register', () {
    test('register with valid data sets registerSuccess state', () async {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      await container
          .read(authProvider.notifier)
          .register(
            email: 'new@test.com',
            password: 'password123',
            firstname: 'Jean',
            lastname: 'Dupont',
            phone: '+33612345678',
          );

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.registerSuccess);
    });

    test('register with existing email sets error state', () async {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      await container
          .read(authProvider.notifier)
          .register(
            email: 'existing@test.com',
            password: 'password123',
            firstname: 'Jean',
            lastname: 'Dupont',
            phone: '+33612345678',
          );

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Email already exists');
    });

    test('register with empty fields sets error state', () async {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      await container
          .read(authProvider.notifier)
          .register(
            email: '',
            password: '',
            firstname: '',
            lastname: '',
            phone: '',
          );

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.error);
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
