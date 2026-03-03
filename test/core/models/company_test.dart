import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/address.dart';
import 'package:locked_in_mobile/core/models/company.dart';

void main() {
  final now = DateTime(2025, 1, 1);
  const address = Address(
    id: 1,
    city: 'Paris',
    country: 'France',
    street: 'Rue de Rivoli',
  );

  final company = Company(
    id: 1,
    name: 'LockerCorp',
    siret: '12345678901234',
    siren: '123456789',
    ape: '6201Z',
    juridicForm: 'SAS',
    phone: '+33123456789',
    address: address,
    createdAt: now,
    updatedAt: now,
  );

  group('Company', () {
    test('constructor sets all fields correctly', () {
      expect(company.id, 1);
      expect(company.name, 'LockerCorp');
      expect(company.siret, '12345678901234');
      expect(company.siren, '123456789');
      expect(company.ape, '6201Z');
      expect(company.juridicForm, 'SAS');
      expect(company.phone, '+33123456789');
      expect(company.address, address);
      expect(company.createdAt, now);
      expect(company.updatedAt, now);
    });

    test('copyWith creates a new instance with updated fields', () {
      final updated = company.copyWith(name: 'NewCorp');
      expect(updated.name, 'NewCorp');
      expect(updated.siret, company.siret);
    });

    test('equality works correctly', () {
      final same = Company(
        id: 1,
        name: 'LockerCorp',
        siret: '12345678901234',
        siren: '123456789',
        ape: '6201Z',
        juridicForm: 'SAS',
        phone: '+33123456789',
        address: address,
        createdAt: now,
        updatedAt: now,
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
