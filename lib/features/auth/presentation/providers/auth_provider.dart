import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/customer.dart';
import '../../../../core/network/token_storage.dart';
import '../../data/datasources/mock_auth_datasource.dart';
import '../../data/repositories/mock_auth_repository.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository(datasource: MockAuthDatasource());
});

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

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

  AuthRepository get _repository => ref.read(authRepositoryProvider);
  TokenStorage get _tokenStorage => ref.read(tokenStorageProvider);

  Future<void> _checkAuth() async {
    final hasToken = await _tokenStorage.hasTokens();
    if (hasToken) {
      try {
        final customer = await _repository.getCurrentCustomer();
        state = AuthState(status: AuthStatus.authenticated, customer: customer);
      } on Exception {
        await _tokenStorage.clearTokens();
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final customer = await _repository.login(email, password);
      await _tokenStorage.saveTokens(
        accessToken: 'mock_jwt_token_${customer.id}',
      );
      state = AuthState(status: AuthStatus.authenticated, customer: customer);
    } on Exception catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    await _tokenStorage.clearTokens();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}
