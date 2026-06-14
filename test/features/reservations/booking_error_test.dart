import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/network/api_exception.dart';
import 'package:locked_in_mobile/features/reservations/presentation/providers/reservation_flow_provider.dart';

void main() {
  group('mapBookingError', () {
    test('409 maps to slotUnavailable', () {
      expect(
        mapBookingError(const ApiException(message: 'taken', statusCode: 409)),
        BookingError.slotUnavailable,
      );
    });

    test('422 maps to invalidDuration', () {
      expect(
        mapBookingError(const ApiException(message: 'short', statusCode: 422)),
        BookingError.invalidDuration,
      );
    });

    test('no status code (network) maps to network', () {
      expect(
        mapBookingError(const ApiException(message: 'No internet connection')),
        BookingError.network,
      );
    });

    test('other status codes map to generic', () {
      expect(
        mapBookingError(const ApiException(message: 'boom', statusCode: 500)),
        BookingError.generic,
      );
    });

    test('non-ApiException maps to generic', () {
      expect(mapBookingError(Exception('oops')), BookingError.generic);
    });
  });
}
