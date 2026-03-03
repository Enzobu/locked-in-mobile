import '../../../../core/mock/mock_data.dart';
import 'reservation_datasource.dart';

class MockReservationDatasource implements ReservationDatasource {
  late final List<Map<String, dynamic>> _reservations;
  int _nextId = 100;

  MockReservationDatasource() {
    _reservations = List<Map<String, dynamic>>.from(MockData.reservations);
  }

  @override
  Future<List<Map<String, dynamic>>> getReservations() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_reservations);
  }

  @override
  Future<Map<String, dynamic>> getReservationById(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _reservations.firstWhere(
      (r) => r['id'] == id,
      orElse: () => throw Exception('Reservation not found: $id'),
    );
  }

  @override
  Future<Map<String, dynamic>> createReservation({
    required int lockerId,
    required String startsAt,
    required String endsAt,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final locker = MockData.lockers.firstWhere(
      (l) => l['id'] == lockerId,
      orElse: () => throw Exception('Locker not found: $lockerId'),
    );

    final id = _nextId++;
    final reservation = {
      'id': id,
      'public_form': 'RES-2026-${id.toRadixString(36).toUpperCase().padLeft(6, '0')}',
      'starts_at': startsAt,
      'ends_at': endsAt,
      'customer': MockData.currentCustomer,
      'locker': locker,
      'status': 'confirmed',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    _reservations.add(reservation);
    return reservation;
  }

  @override
  Future<void> cancelReservation(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final index = _reservations.indexWhere((r) => r['id'] == id);
    if (index == -1) {
      throw Exception('Reservation not found: $id');
    }

    final reservation = Map<String, dynamic>.from(_reservations[index]);
    reservation['status'] = 'cancelled';
    reservation['updated_at'] = DateTime.now().toIso8601String();
    _reservations[index] = reservation;
  }
}
