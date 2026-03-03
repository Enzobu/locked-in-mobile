import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in/core/models/locker_status.dart';

void main() {
  group('LockerStatus', () {
    test('has correct string values', () {
      expect(LockerStatus.available.value, 'available');
      expect(LockerStatus.reserved.value, 'reserved');
      expect(LockerStatus.occupied.value, 'occupied');
      expect(LockerStatus.outOfOrder.value, 'out_of_order');
      expect(LockerStatus.offline.value, 'offline');
    });

    test('fromString returns correct enum value', () {
      expect(LockerStatus.fromString('available'), LockerStatus.available);
      expect(LockerStatus.fromString('reserved'), LockerStatus.reserved);
      expect(LockerStatus.fromString('occupied'), LockerStatus.occupied);
      expect(LockerStatus.fromString('out_of_order'), LockerStatus.outOfOrder);
      expect(LockerStatus.fromString('offline'), LockerStatus.offline);
    });

    test('fromString throws on unknown value', () {
      expect(
        () => LockerStatus.fromString('unknown'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('has 5 values', () {
      expect(LockerStatus.values.length, 5);
    });
  });
}
