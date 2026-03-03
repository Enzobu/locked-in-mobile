import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in/core/models/address.dart';

void main() {
  const address = Address(
    id: 1,
    number: '42',
    city: 'Paris',
    country: 'France',
    street: 'Rue de la Paix',
    complement: 'Apt 3B',
  );

  group('Address', () {
    test('constructor sets all fields correctly', () {
      expect(address.id, 1);
      expect(address.number, '42');
      expect(address.city, 'Paris');
      expect(address.country, 'France');
      expect(address.street, 'Rue de la Paix');
      expect(address.complement, 'Apt 3B');
    });

    test('nullable fields default to null', () {
      const minimal = Address(
        id: 1,
        city: 'Lyon',
        country: 'France',
        street: 'Rue Principale',
      );
      expect(minimal.number, isNull);
      expect(minimal.complement, isNull);
    });

    test('copyWith creates a new instance with updated fields', () {
      final updated = address.copyWith(city: 'Lyon');
      expect(updated.city, 'Lyon');
      expect(updated.id, address.id);
      expect(updated.street, address.street);
    });

    test('copyWith can set nullable fields to null', () {
      final updated = address.copyWith(
        number: () => null,
        complement: () => null,
      );
      expect(updated.number, isNull);
      expect(updated.complement, isNull);
    });

    test('equality works correctly', () {
      const same = Address(
        id: 1,
        number: '42',
        city: 'Paris',
        country: 'France',
        street: 'Rue de la Paix',
        complement: 'Apt 3B',
      );
      expect(address, equals(same));
      expect(address.hashCode, same.hashCode);
    });

    test('inequality works correctly', () {
      final different = address.copyWith(city: 'Lyon');
      expect(address, isNot(equals(different)));
    });

    test('toString contains class name and fields', () {
      final str = address.toString();
      expect(str, contains('Address'));
      expect(str, contains('Paris'));
      expect(str, contains('Rue de la Paix'));
    });
  });
}
