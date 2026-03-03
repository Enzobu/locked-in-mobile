import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in/core/models/address.dart';
import 'package:locked_in/core/models/customer.dart';

void main() {
  final now = DateTime(2025, 1, 1);
  final birthDate = DateTime(1995, 6, 15);
  const address = Address(
    id: 1,
    city: 'Paris',
    country: 'France',
    street: 'Rue de Rivoli',
  );

  final customer = Customer(
    id: 1,
    email: 'john@example.com',
    firstname: 'John',
    lastname: 'Doe',
    birthDate: birthDate,
    address: address,
    createdAt: now,
    updatedAt: now,
  );

  group('Customer', () {
    test('constructor sets all fields correctly', () {
      expect(customer.id, 1);
      expect(customer.email, 'john@example.com');
      expect(customer.firstname, 'John');
      expect(customer.lastname, 'Doe');
      expect(customer.birthDate, birthDate);
      expect(customer.address, address);
    });

    test('fullName returns firstname and lastname', () {
      expect(customer.fullName, 'John Doe');
    });

    test('copyWith creates a new instance with updated fields', () {
      final updated = customer.copyWith(
        firstname: 'Jane',
        email: 'jane@example.com',
      );
      expect(updated.firstname, 'Jane');
      expect(updated.email, 'jane@example.com');
      expect(updated.lastname, customer.lastname);
    });

    test('equality works correctly', () {
      final same = Customer(
        id: 1,
        email: 'john@example.com',
        firstname: 'John',
        lastname: 'Doe',
        birthDate: birthDate,
        address: address,
        createdAt: now,
        updatedAt: now,
      );
      expect(customer, equals(same));
      expect(customer.hashCode, same.hashCode);
    });

    test('inequality works correctly', () {
      final different = customer.copyWith(email: 'other@example.com');
      expect(customer, isNot(equals(different)));
    });

    test('toString contains class name and fields', () {
      final str = customer.toString();
      expect(str, contains('Customer'));
      expect(str, contains('john@example.com'));
      expect(str, contains('John Doe'));
    });
  });
}
