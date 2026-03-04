class ReservationApiFixtures {
  ReservationApiFixtures._();

  static const customerJson = {
    'id': 1,
    'email': 'john@example.com',
    'firstname': 'John',
    'lastname': 'Doe',
    'birthDate': '1990-05-15T00:00:00+00:00',
    'roles': <String>['ROLE_USER'],
    'addresses': <dynamic>[],
    'createdAt': '2026-01-01T00:00:00+00:00',
    'updatedAt': '2026-03-01T00:00:00+00:00',
  };

  static const specificationJson = {
    'id': 1,
    'name': 'Small',
    'width': 30.0,
    'height': 40.0,
    'depth': 50.0,
    'material': 'Acier',
    'isRechargeable': false,
  };

  static const companyJson = {
    'id': 1,
    'name': 'LockerBox France',
    'siren': '123456789',
    'address': {
      'id': 13,
      'city': 'Paris',
      'country': 'France',
      'address': 'Boulevard Haussmann',
    },
  };

  static const lockerBayJson = {
    'id': 1,
    'name': 'Gare de Lyon',
    'latitude': '48.8443',
    'longitude': '2.3744',
    'minDuration': 30,
    'maxDuration': 120,
    'company': companyJson,
    'createdAt': '2026-01-01T00:00:00+00:00',
    'updatedAt': '2026-03-01T00:00:00+00:00',
  };

  static const lockerJson = {
    'id': 5,
    'number': 3,
    'specification': specificationJson,
    'priceCents': 500,
    'lockerBay': lockerBayJson,
    'status': 'available',
    'createdAt': '2026-01-01T00:00:00+00:00',
    'updatedAt': '2026-03-01T00:00:00+00:00',
  };

  /// Reservation as returned by API Platform with IRI relations.
  static const reservationWithIris = {
    '@context': '/api/contexts/Reservation',
    '@id': '/api/reservations/42',
    '@type': 'Reservation',
    'id': 42,
    'startsAt': '2026-03-15T10:00:00+00:00',
    'endsAt': '2026-03-15T14:00:00+00:00',
    'customer': '/api/customers/1',
    'locker': '/api/lockers/5',
    'status': 'pending',
    'createdAt': '2026-03-04T18:00:00+00:00',
    'updatedAt': '2026-03-04T18:00:00+00:00',
  };

  /// Reservation with embedded objects (if backend sends full objects).
  static const reservationWithEmbedded = {
    '@context': '/api/contexts/Reservation',
    '@id': '/api/reservations/42',
    '@type': 'Reservation',
    'id': 42,
    'startsAt': '2026-03-15T10:00:00+00:00',
    'endsAt': '2026-03-15T14:00:00+00:00',
    'customer': customerJson,
    'locker': lockerJson,
    'status': 'pending',
    'createdAt': '2026-03-04T18:00:00+00:00',
    'updatedAt': '2026-03-04T18:00:00+00:00',
  };
}
