// ignore_for_file: lines_longer_than_80_chars

/// Centralized mock data for the application.
/// Based on the MCD schema with realistic French locations.
class MockData {
  MockData._();

  static const List<Map<String, dynamic>> addresses = [
    {
      'id': 1,
      'number': '12',
      'city': 'Paris',
      'country': 'France',
      'street': 'Rue de Rivoli',
      'complement': null,
    },
    {
      'id': 2,
      'number': '45',
      'city': 'Paris',
      'country': 'France',
      'street': 'Avenue des Champs-Élysées',
      'complement': 'Niveau -1',
    },
    {
      'id': 3,
      'number': '8',
      'city': 'Lyon',
      'country': 'France',
      'street': 'Place Bellecour',
      'complement': null,
    },
    {
      'id': 4,
      'number': '23',
      'city': 'Lyon',
      'country': 'France',
      'street': 'Rue de la République',
      'complement': 'Bâtiment B',
    },
    {
      'id': 5,
      'number': '67',
      'city': 'Marseille',
      'country': 'France',
      'street': 'La Canebière',
      'complement': null,
    },
    {
      'id': 6,
      'number': '3',
      'city': 'Marseille',
      'country': 'France',
      'street': 'Quai du Port',
      'complement': 'Zone portuaire',
    },
    {
      'id': 7,
      'number': '15',
      'city': 'Toulouse',
      'country': 'France',
      'street': 'Place du Capitole',
      'complement': null,
    },
    {
      'id': 8,
      'number': '28',
      'city': 'Nice',
      'country': 'France',
      'street': 'Promenade des Anglais',
      'complement': null,
    },
    {
      'id': 9,
      'number': '5',
      'city': 'Bordeaux',
      'country': 'France',
      'street': 'Place de la Bourse',
      'complement': null,
    },
    {
      'id': 10,
      'number': '42',
      'city': 'Strasbourg',
      'country': 'France',
      'street': 'Place Kléber',
      'complement': 'Galerie commerciale',
    },
    {
      'id': 11,
      'number': '18',
      'city': 'Lille',
      'country': 'France',
      'street': 'Rue Faidherbe',
      'complement': null,
    },
    {
      'id': 12,
      'number': '7',
      'city': 'Nantes',
      'country': 'France',
      'street': 'Place du Commerce',
      'complement': null,
    },
    // Company addresses
    {
      'id': 13,
      'number': '100',
      'city': 'Paris',
      'country': 'France',
      'street': 'Boulevard Haussmann',
      'complement': '3ème étage',
    },
    {
      'id': 14,
      'number': '55',
      'city': 'Lyon',
      'country': 'France',
      'street': 'Rue Garibaldi',
      'complement': null,
    },
    {
      'id': 15,
      'number': '30',
      'city': 'Marseille',
      'country': 'France',
      'street': 'Boulevard Longchamp',
      'complement': null,
    },
    // Customer address
    {
      'id': 16,
      'number': '22',
      'city': 'Paris',
      'country': 'France',
      'street': 'Rue du Faubourg Saint-Honoré',
      'complement': 'Apt 4B',
    },
  ];

  static const List<Map<String, dynamic>> companies = [
    {
      'id': 1,
      'name': 'LockerBox France',
      'siret': '12345678901234',
      'siren': '123456789',
      'ape': '5221Z',
      'juridic_form': 'SAS',
      'phone': '+33 1 23 45 67 89',
      'address': {
        'id': 13,
        'number': '100',
        'city': 'Paris',
        'country': 'France',
        'street': 'Boulevard Haussmann',
        'complement': '3ème étage',
      },
      'created_at': '2024-01-15T10:00:00.000',
      'updated_at': '2024-06-01T14:30:00.000',
    },
    {
      'id': 2,
      'name': 'SmartLocker Lyon',
      'siret': '98765432109876',
      'siren': '987654321',
      'ape': '5221Z',
      'juridic_form': 'SARL',
      'phone': '+33 4 56 78 90 12',
      'address': {
        'id': 14,
        'number': '55',
        'city': 'Lyon',
        'country': 'France',
        'street': 'Rue Garibaldi',
        'complement': null,
      },
      'created_at': '2024-03-20T09:00:00.000',
      'updated_at': '2024-07-15T11:00:00.000',
    },
    {
      'id': 3,
      'name': 'CasierSud',
      'siret': '45678912345678',
      'siren': '456789123',
      'ape': '5221Z',
      'juridic_form': 'SAS',
      'phone': '+33 4 91 23 45 67',
      'address': {
        'id': 15,
        'number': '30',
        'city': 'Marseille',
        'country': 'France',
        'street': 'Boulevard Longchamp',
        'complement': null,
      },
      'created_at': '2024-05-10T08:00:00.000',
      'updated_at': '2024-08-20T16:00:00.000',
    },
  ];

  static const List<Map<String, dynamic>> specifications = [
    {
      'id': 1,
      'name': 'Small',
      'width': 30,
      'height': 40,
      'depth': 50,
      'material': 'Acier',
      'is_rechargeable': false,
    },
    {
      'id': 2,
      'name': 'Medium',
      'width': 40,
      'height': 60,
      'depth': 50,
      'material': 'Acier',
      'is_rechargeable': false,
    },
    {
      'id': 3,
      'name': 'Large',
      'width': 50,
      'height': 80,
      'depth': 60,
      'material': 'Acier',
      'is_rechargeable': false,
    },
    {
      'id': 4,
      'name': 'Small Rechargeable',
      'width': 30,
      'height': 40,
      'depth': 50,
      'material': 'Acier renforcé',
      'is_rechargeable': true,
    },
    {
      'id': 5,
      'name': 'Medium Rechargeable',
      'width': 40,
      'height': 60,
      'depth': 50,
      'material': 'Acier renforcé',
      'is_rechargeable': true,
    },
    {
      'id': 6,
      'name': 'Large Rechargeable',
      'width': 50,
      'height': 80,
      'depth': 60,
      'material': 'Acier renforcé',
      'is_rechargeable': true,
    },
    {
      'id': 7,
      'name': 'XL',
      'width': 60,
      'height': 100,
      'depth': 70,
      'material': 'Aluminium',
      'is_rechargeable': false,
    },
  ];

  static List<Map<String, dynamic>> get lockerBays => [
    _lockerBay(1, 'Gare de Lyon', 48.8443, 2.3744, 1, 1, 60, 30),
    _lockerBay(2, 'Châtelet-Les Halles', 48.8606, 2.3472, 2, 1, 120, 30),
    _lockerBay(3, 'Part-Dieu Lyon', 45.7605, 4.8594, 3, 2, 60, 30),
    _lockerBay(4, 'Bellecour Lyon', 45.7578, 4.8320, 4, 2, 90, 60),
    _lockerBay(5, 'Vieux-Port Marseille', 43.2951, 5.3749, 5, 3, 120, 30),
    _lockerBay(6, 'Port de Marseille', 43.2965, 5.3698, 6, 3, 60, 30),
    _lockerBay(7, 'Capitole Toulouse', 43.6047, 1.4442, 7, 1, 90, 30),
    _lockerBay(8, 'Nice Promenade', 43.6955, 7.2655, 8, 3, 120, 60),
    _lockerBay(
      9,
      'Place de la Bourse Bordeaux',
      44.8413,
      -0.5703,
      9,
      1,
      60,
      30,
    ),
    _lockerBay(10, 'Kléber Strasbourg', 48.5839, 7.7455, 10, 2, 90, 30),
    _lockerBay(11, 'Gare de Lille', 50.6372, 3.0700, 11, 1, 60, 30),
    _lockerBay(12, 'Commerce Nantes', 47.2132, -1.5566, 12, 2, 120, 60),
  ];

  static Map<String, dynamic> _lockerBay(
    int id,
    String name,
    double lat,
    double lng,
    int addressId,
    int companyId,
    int maxDuration,
    int minDuration,
  ) {
    final company = companies.firstWhere((c) => c['id'] == companyId);
    return {
      'id': id,
      'name': name,
      'latitude': lat,
      'longitude': lng,
      'company': company,
      'max_duration': maxDuration,
      'min_duration': minDuration,
      'created_at': '2024-01-01T00:00:00.000',
      'updated_at': '2024-06-01T00:00:00.000',
    };
  }

  static List<Map<String, dynamic>> get lockers {
    final result = <Map<String, dynamic>>[];
    var lockerId = 1;

    for (final bay in lockerBays) {
      final bayId = bay['id'] as int;
      // 4-6 lockers per bay, varied specs
      final lockerCount = 4 + (bayId % 3);
      for (var i = 0; i < lockerCount; i++) {
        final specIndex = (lockerId - 1) % specifications.length;
        final spec = specifications[specIndex];
        final status = _statusForLocker(lockerId);
        result.add({
          'id': lockerId,
          'number': i + 1,
          'hardware_id':
              'HW-${bayId.toString().padLeft(3, '0')}-${(i + 1).toString().padLeft(2, '0')}',
          'specification': spec,
          'price_cents': _priceForSpec(spec['id'] as int),
          'locker_bay': bay,
          'status': status,
          'last_seen_at': '2026-03-01T12:00:00.000',
          'created_at': '2024-01-01T00:00:00.000',
          'updated_at': '2026-03-01T12:00:00.000',
        });
        lockerId++;
      }
    }
    return result;
  }

  static String _statusForLocker(int id) {
    // Most lockers available, some reserved/occupied
    if (id % 7 == 0) return 'reserved';
    if (id % 11 == 0) return 'occupied';
    if (id % 23 == 0) return 'out_of_order';
    return 'available';
  }

  static int _priceForSpec(int specId) {
    switch (specId) {
      case 1:
        return 300; // 3.00 EUR
      case 2:
        return 500; // 5.00 EUR
      case 3:
        return 800; // 8.00 EUR
      case 4:
        return 500; // 5.00 EUR
      case 5:
        return 700; // 7.00 EUR
      case 6:
        return 1000; // 10.00 EUR
      case 7:
        return 1200; // 12.00 EUR
      default:
        return 500;
    }
  }

  static const Map<String, dynamic> currentCustomer = {
    'id': 1,
    'email': 'jean.dupont@email.com',
    'firstname': 'Jean',
    'lastname': 'Dupont',
    'birth_date': '1995-06-15T00:00:00.000',
    'address': {
      'id': 16,
      'number': '22',
      'city': 'Paris',
      'country': 'France',
      'street': 'Rue du Faubourg Saint-Honoré',
      'complement': 'Apt 4B',
    },
    'created_at': '2025-01-10T08:00:00.000',
    'updated_at': '2026-02-15T10:30:00.000',
  };

  static List<Map<String, dynamic>> get reservations {
    final allLockers = lockers;
    return [
      {
        'id': 1,
        'starts_at': '2026-03-03T09:00:00.000',
        'ends_at': '2026-03-03T11:00:00.000',
        'customer': currentCustomer,
        'locker': allLockers[0],
        'status': 'active',
        'created_at': '2026-03-02T18:00:00.000',
        'updated_at': '2026-03-03T09:00:00.000',
      },
      {
        'id': 2,
        'starts_at': '2026-03-05T14:00:00.000',
        'ends_at': '2026-03-05T16:00:00.000',
        'customer': currentCustomer,
        'locker': allLockers[5],
        'status': 'confirmed',
        'created_at': '2026-03-01T10:00:00.000',
        'updated_at': '2026-03-01T10:00:00.000',
      },
      {
        'id': 3,
        'starts_at': '2026-02-20T10:00:00.000',
        'ends_at': '2026-02-20T12:00:00.000',
        'customer': currentCustomer,
        'locker': allLockers[10],
        'status': 'completed',
        'created_at': '2026-02-19T20:00:00.000',
        'updated_at': '2026-02-20T12:00:00.000',
      },
      {
        'id': 4,
        'starts_at': '2026-02-15T08:00:00.000',
        'ends_at': '2026-02-15T10:00:00.000',
        'customer': currentCustomer,
        'locker': allLockers[15],
        'status': 'completed',
        'created_at': '2026-02-14T22:00:00.000',
        'updated_at': '2026-02-15T10:00:00.000',
      },
      {
        'id': 5,
        'starts_at': '2026-01-28T16:00:00.000',
        'ends_at': '2026-01-28T18:00:00.000',
        'customer': currentCustomer,
        'locker': allLockers[20],
        'status': 'cancelled',
        'created_at': '2026-01-27T12:00:00.000',
        'updated_at': '2026-01-28T08:00:00.000',
      },
    ];
  }
}
