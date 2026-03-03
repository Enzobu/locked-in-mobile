import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/address.dart';
import 'package:locked_in_mobile/core/models/customer.dart';
import 'package:locked_in_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:locked_in_mobile/features/profile/presentation/providers/profile_provider.dart';

void main() {
  group('currentCustomerProvider', () {
    test('returns null when auth state has no customer', () {
      final container = ProviderContainer(
        overrides: [authProvider.overrideWith(() => _FakeAuthNotifier(null))],
      );
      addTearDown(container.dispose);

      final customer = container.read(currentCustomerProvider);
      expect(customer, isNull);
    });

    test('returns customer when auth state has customer', () {
      final testCustomer = Customer(
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

      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => _FakeAuthNotifier(testCustomer)),
        ],
      );
      addTearDown(container.dispose);

      final customer = container.read(currentCustomerProvider);
      expect(customer, isNotNull);
      expect(customer!.email, 'jean.dupont@email.com');
      expect(customer.fullName, 'Jean Dupont');
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
