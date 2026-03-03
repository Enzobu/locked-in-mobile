import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/reservation_status.dart';

void main() {
  group('ReservationStatus', () {
    test('has correct string values', () {
      expect(ReservationStatus.pending.value, 'pending');
      expect(ReservationStatus.confirmed.value, 'confirmed');
      expect(ReservationStatus.active.value, 'active');
      expect(ReservationStatus.completed.value, 'completed');
      expect(ReservationStatus.cancelled.value, 'cancelled');
      expect(ReservationStatus.expired.value, 'expired');
    });

    test('fromString returns correct enum value', () {
      expect(
        ReservationStatus.fromString('pending'),
        ReservationStatus.pending,
      );
      expect(
        ReservationStatus.fromString('confirmed'),
        ReservationStatus.confirmed,
      );
      expect(ReservationStatus.fromString('active'), ReservationStatus.active);
      expect(
        ReservationStatus.fromString('completed'),
        ReservationStatus.completed,
      );
      expect(
        ReservationStatus.fromString('cancelled'),
        ReservationStatus.cancelled,
      );
      expect(
        ReservationStatus.fromString('expired'),
        ReservationStatus.expired,
      );
    });

    test('fromString throws on unknown value', () {
      expect(
        () => ReservationStatus.fromString('unknown'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('has 6 values', () {
      expect(ReservationStatus.values.length, 6);
    });
  });
}
