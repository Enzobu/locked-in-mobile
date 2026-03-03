import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/address.dart';
import 'package:locked_in_mobile/core/models/company.dart';

void main() {
  const address = Address(
    id: 1,
    city: 'Paris',
    country: 'France',
    street: 'Rue de Rivoli',
  );

  const company = Company(
    id: 1,
    name: 'LockerCorp',
    siren: '123456789',
    address: address,
  );

  group('Company', () {
    test('constructor sets all fields correctly', () {
      expect(company.id, 1);
      expect(company.name, 'LockerCorp');
      expect(company.siren, '123456789');
      expect(company.address, address);
    });

    test('copyWith creates a new instance with updated fields', () {
      final updated = company.copyWith(name: 'NewCorp');
      expect(updated.name, 'NewCorp');
      expect(updated.siren, company.siren);
    });

    test('equality works correctly', () {
      const same = Company(
        id: 1,
        name: 'LockerCorp',
        siren: '123456789',
        address: address,
      );
      expect(company, equals(same));
      expect(company.hashCode, same.hashCode);
    });

    test('inequality works correctly', () {
      final different = company.copyWith(name: 'OtherCorp');
      expect(company, isNot(equals(different)));
    });

    test('toString contains class name and fields', () {
      final str = company.toString();
      expect(str, contains('Company'));
      expect(str, contains('LockerCorp'));
    });
  });
}
