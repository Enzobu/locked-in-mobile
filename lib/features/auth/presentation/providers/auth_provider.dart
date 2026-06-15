import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/dtos/customer_dto.dart';
import '../../../../core/models/customer.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/token_storage.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../data/datasources/api_auth_datasource.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../domain/repositories/auth_repository.dart';

final authDatasourceProvider = Provider<AuthDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ApiAuthDatasource(dioClient: dioClient);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError(
    'Not used directly — login is handled in AuthNotifier',
  );
});

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
  registerSuccess,
}

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.customer,
    this.errorMessage,
  });

  final AuthStatus status;
  final Customer? customer;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    Customer? customer,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      customer: customer ?? this.customer,
      errorMessage: errorMessage,
    );
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _checkAuth();
    return const AuthState();
  }

  AuthDatasource get _datasource => ref.read(authDatasourceProvider);
  TokenStorage get _tokenStorage => ref.read(tokenStorageProvider);

  Future<void> _checkAuth() async {
    final hasToken = await _tokenStorage.hasTokens();
    if (!hasToken) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return;
    }

    try {
      final data = await _datasource.getCurrentCustomer();
      final customer = CustomerDto.fromJson(data).toDomain();
      state = AuthState(status: AuthStatus.authenticated, customer: customer);
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        await _tokenStorage.clearTokens();
      }
      state = const AuthState(status: AuthStatus.unauthenticated);
    } on Exception {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final data = await _datasource.login(email, password);
      final token = data['token'] as String?;
      if (token == null || token.isEmpty) {
        throw const ApiException(
          statusCode: 401,
          message: 'invalidCredentials',
        );
      }
      await _tokenStorage.saveTokens(accessToken: token);
      final customerData = await _datasource.getCurrentCustomer();
      final customer = CustomerDto.fromJson(customerData).toDomain();
      state = AuthState(status: AuthStatus.authenticated, customer: customer);
      // Fresh session: drop cached locker availability so the home re-fetches.
      ref.invalidate(lockerBaySummariesProvider);
    } on ApiException catch (e) {
      final message = switch (e.statusCode) {
        401 => 'invalidCredentials',
        429 => 'tooManyAttempts',
        _ => e.message,
      };
      state = AuthState(status: AuthStatus.error, errorMessage: message);
    } on Exception catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _datasource.register(
        email: email,
        password: password,
        firstname: firstname,
        lastname: lastname,
        birthDate: DateTime.now().toIso8601String(),
      );
      state = const AuthState(status: AuthStatus.registerSuccess);
    } on ApiException catch (e) {
      final message = e.statusCode == 429 ? 'tooManyAttempts' : e.message;
      state = AuthState(status: AuthStatus.error, errorMessage: message);
    } on Exception catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void updateCustomerState(Customer customer) {
    state = state.copyWith(customer: customer);
  }

  Future<void> logout() async {
    await _tokenStorage.clearTokens();
    state = const AuthState(status: AuthStatus.unauthenticated);
    // Avoid leaking the previous session's cached locker availability.
    ref.invalidate(lockerBaySummariesProvider);
  }
}
