import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in/core/models/address.dart';
import 'package:locked_in/core/models/company.dart';
import 'package:locked_in/core/models/customer.dart';
import 'package:locked_in/core/models/locker.dart';
import 'package:locked_in/core/models/locker_bay.dart';
import 'package:locked_in/core/models/reservation.dart';
import 'package:locked_in/core/models/reservation_status.dart';
import 'package:locked_in/core/models/specification.dart';

void main() {
  final now = DateTime(2025, 1, 1);
  final birthDate = DateTime(1995, 6, 15);
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
  const spec = Specification(
    id: 1,
    width: 40,
    height: 60,
    depth: 30,
    material: 'steel',
    name: 'Medium',
  );
  final lockerBay = LockerBay(
    id: 1,
    name: 'Gare du Nord',
    latitude: 48.8809,
    longitude: 2.3553,
    company: company,
    createdAt: now,
    updatedAt: now,
  );
  final locker = Locker(
    id: 1,
    number: 42,
    specification: spec,
    priceCents: 500,
    lockerBay: lockerBay,
    createdAt: now,
    updatedAt: now,
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

  final startsAt = DateTime(2025, 3, 1, 10, 0);
  final endsAt = DateTime(2025, 3, 1, 14, 0);

  final reservation = Reservation(
    id: 1,
    startsAt: startsAt,
    endsAt: endsAt,
    customer: customer,
    locker: locker,
    status: ReservationStatus.confirmed,
    createdAt: now,
    updatedAt: now,
  );

  group('Reservation', () {
    test('constructor sets all fields correctly', () {
      expect(reservation.id, 1);
      expect(reservation.startsAt, startsAt);
      expect(reservation.endsAt, endsAt);
      expect(reservation.customer, customer);
      expect(reservation.locker, locker);
      expect(reservation.status, ReservationStatus.confirmed);
    });

    test('status defaults to pending', () {
      final defaultReservation = Reservation(
        id: 2,
        startsAt: startsAt,
        endsAt: endsAt,
        customer: customer,
        locker: locker,
        createdAt: now,
        updatedAt: now,
      );
      expect(defaultReservation.status, ReservationStatus.pending);
    });

    test('durationMinutes calculates correctly', () {
      expect(reservation.durationMinutes, 240); // 4 hours = 240 minutes
    });

    test('copyWith creates a new instance with updated fields', () {
      final updated = reservation.copyWith(
        status: ReservationStatus.cancelled,
      );
      expect(updated.status, ReservationStatus.cancelled);
      expect(updated.startsAt, reservation.startsAt);
    });

    test('equality works correctly', () {
      final same = Reservation(
        id: 1,
        startsAt: startsAt,
        endsAt: endsAt,
        customer: customer,
        locker: locker,
        status: ReservationStatus.confirmed,
        createdAt: now,
        updatedAt: now,
      );
      expect(reservation, equals(same));
      expect(reservation.hashCode, same.hashCode);
    });

    test('inequality works correctly', () {
      final different = reservation.copyWith(
        status: ReservationStatus.cancelled,
      );
      expect(reservation, isNot(equals(different)));
    });

    test('toString contains class name and fields', () {
      final str = reservation.toString();
      expect(str, contains('Reservation'));
      expect(str, contains('confirmed'));
      expect(str, contains('John Doe'));
    });
  });
}
