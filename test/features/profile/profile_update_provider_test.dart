import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/customer.dart';
import 'package:locked_in_mobile/core/network/api_exception.dart';
import 'package:locked_in_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:locked_in_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:locked_in_mobile/features/profile/presentation/providers/profile_provider.dart';

final _testCustomer = Customer(
  id: 1,
  email: 'jean@example.com',
  firstname: 'Jean',
  lastname: 'Dupont',
  birthDate: DateTime(1995, 6, 15),
  createdAt: DateTime(2025, 1, 10),
  updatedAt: DateTime(2026, 2, 15),
);

void main() {
  group('ProfileUpdateNotifier', () {
    test('returns true and updates auth state on success', () async {
      final updatedCustomer = _testCustomer.copyWith(
        firstname: 'Pierre',
        lastname: 'Martin',
        email: 'pierre@example.com',
        phone: '+33612345678',
      );

      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => _FakeAuthNotifier(_testCustomer)),
          profileRepositoryProvider.overrideWithValue(
            _FakeProfileRepository(updatedCustomer),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = await container
          .read(profileUpdateProvider.notifier)
          .updateProfile(
            firstname: 'Pierre',
            lastname: 'Martin',
            email: 'pierre@example.com',
            phone: '+33612345678',
          );

      expect(result, isTrue);
      final state = container.read(profileUpdateProvider);
      expect(state.status, ProfileUpdateStatus.success);

      final authState = container.read(authProvider);
      expect(authState.customer?.firstname, 'Pierre');
    });

    test('returns false and sets error on ApiException', () async {
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => _FakeAuthNotifier(_testCustomer)),
          profileRepositoryProvider.overrideWithValue(
            const _ErrorProfileRepository(
              ApiException(message: 'Server error', statusCode: 500),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = await container
          .read(profileUpdateProvider.notifier)
          .updateProfile(
            firstname: 'Jean',
            lastname: 'Dupont',
            email: 'jean@example.com',
          );

      expect(result, isFalse);
      final state = container.read(profileUpdateProvider);
      expect(state.status, ProfileUpdateStatus.error);
      expect(state.errorMessage, 'Server error');
    });

    test('extracts field errors from violations', () async {
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => _FakeAuthNotifier(_testCustomer)),
          profileRepositoryProvider.overrideWithValue(
            const _ErrorProfileRepository(
              ApiException(
                message: 'Validation failed',
                statusCode: 422,
                data: {
                  'violations': [
                    {
                      'propertyPath': 'email',
                      'message': 'This value is already used.',
                    },
                  ],
                },
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = await container
          .read(profileUpdateProvider.notifier)
          .updateProfile(
            firstname: 'Jean',
            lastname: 'Dupont',
            email: 'taken@example.com',
          );

      expect(result, isFalse);
      final state = container.read(profileUpdateProvider);
      expect(state.status, ProfileUpdateStatus.error);
      expect(state.hasFieldErrors, isTrue);
      expect(state.fieldErrors['email'], 'This value is already used.');
      expect(state.errorMessage, isNull);
    });

    test('reset clears state', () async {
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => _FakeAuthNotifier(_testCustomer)),
          profileRepositoryProvider.overrideWithValue(
            const _ErrorProfileRepository(
              ApiException(message: 'error', statusCode: 500),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(profileUpdateProvider.notifier)
          .updateProfile(
            firstname: 'Jean',
            lastname: 'Dupont',
            email: 'jean@example.com',
          );

      expect(
        container.read(profileUpdateProvider).status,
        ProfileUpdateStatus.error,
      );

      container.read(profileUpdateProvider.notifier).reset();

      expect(
        container.read(profileUpdateProvider).status,
        ProfileUpdateStatus.idle,
      );
    });
  });
}

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
  const _FakeProfileRepository(this._customer);

  final Customer _customer;

  @override
  Future<Customer> getProfile() async => _customer;

  @override
  Future<Customer> updateProfile({
    required int customerId,
    required String firstname,
    required String lastname,
    required String email,
    String? phone,
  }) async => _customer;
}

class _ErrorProfileRepository implements ProfileRepository {
  const _ErrorProfileRepository(this._exception);

  final Exception _exception;

  @override
  Future<Customer> getProfile() => throw _exception;

  @override
  Future<Customer> updateProfile({
    required int customerId,
    required String firstname,
    required String lastname,
    required String email,
    String? phone,
  }) => throw _exception;
}
