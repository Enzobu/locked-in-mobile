import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/network/api_exception.dart';
import 'package:locked_in_mobile/core/network/dio_client.dart';
import 'package:locked_in_mobile/core/network/token_storage.dart';
import 'package:locked_in_mobile/features/reservations/data/datasources/api_reservation_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ignore: depend_on_referenced_packages

import 'reservation_api_fixtures.dart';

void main() {
  late DioClient dioClient;
  late DioAdapter dioAdapter;
  late ApiReservationDatasource datasource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final tokenStorage = TokenStorage();
    dioClient = DioClient(tokenStorage: tokenStorage);
    dioAdapter = DioAdapter();
    dioClient.dio.httpClientAdapter = dioAdapter;
    datasource = ApiReservationDatasource(dioClient: dioClient);
  });

  group('getReservations', () {
    test('returns list of reservations with resolved relations', () async {
      dioAdapter.registerResponses({
        '/api/reservations': Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: {
            'hydra:member': [ReservationApiFixtures.reservationWithIris],
          },
        ),
        '/api/customers/1': Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: ReservationApiFixtures.customerJson,
        ),
        '/api/lockers/5': Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: ReservationApiFixtures.lockerJson,
        ),
      });

      final result = await datasource.getReservations();

      expect(result, hasLength(1));
      expect(result[0]['id'], 42);
      expect(result[0]['customer'], isA<Map<String, dynamic>>());
      expect(result[0]['locker'], isA<Map<String, dynamic>>());
      expect(result[0]['customer']['id'], 1);
      expect(result[0]['locker']['id'], 5);
    });

    test('handles embedded objects (no IRI resolution needed)', () async {
      dioAdapter.registerResponses({
        '/api/reservations': Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: {
            'hydra:member': [ReservationApiFixtures.reservationWithEmbedded],
          },
        ),
      });

      final result = await datasource.getReservations();

      expect(result, hasLength(1));
      expect(result[0]['customer']['id'], 1);
      expect(result[0]['locker']['id'], 5);
    });

    test('returns empty list when no reservations', () async {
      dioAdapter.registerResponses({
        '/api/reservations': Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: {'hydra:member': <dynamic>[]},
        ),
      });

      final result = await datasource.getReservations();

      expect(result, isEmpty);
    });

    test('throws ApiException on server error', () async {
      dioAdapter.registerError(
        '/api/reservations',
        DioException(
          requestOptions: RequestOptions(path: '/api/reservations'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/reservations'),
            statusCode: 500,
            data: {'message': 'Internal Server Error'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(() => datasource.getReservations(), throwsA(isA<ApiException>()));
    });
  });

  group('getReservationById', () {
    test('returns resolved reservation', () async {
      dioAdapter.registerResponses({
        '/api/reservations/42': Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: ReservationApiFixtures.reservationWithIris,
        ),
        '/api/customers/1': Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: ReservationApiFixtures.customerJson,
        ),
        '/api/lockers/5': Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: ReservationApiFixtures.lockerJson,
        ),
      });

      final result = await datasource.getReservationById(42);

      expect(result['id'], 42);
      expect(result['status'], 'pending');
      expect(result['customer'], isA<Map<String, dynamic>>());
    });

    test('throws ApiException on 404', () async {
      dioAdapter.registerError(
        '/api/reservations/999',
        DioException(
          requestOptions: RequestOptions(path: '/api/reservations/999'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/reservations/999'),
            statusCode: 404,
            data: {'detail': 'Not Found'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => datasource.getReservationById(999),
        throwsA(
          isA<ApiException>().having((e) => e.isNotFound, 'isNotFound', true),
        ),
      );
    });
  });

  group('createReservation', () {
    test('sends correct payload and returns resolved reservation', () async {
      dioAdapter.registerResponses({
        '/api/reservations': Response(
          requestOptions: RequestOptions(),
          statusCode: 201,
          data: ReservationApiFixtures.reservationWithIris,
        ),
        '/api/customers/1': Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: ReservationApiFixtures.customerJson,
        ),
        '/api/lockers/5': Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: ReservationApiFixtures.lockerJson,
        ),
      });

      final result = await datasource.createReservation(
        lockerId: 5,
        startsAt: '2026-03-15T10:00:00.000',
        endsAt: '2026-03-15T14:00:00.000',
      );

      expect(result['id'], 42);
      expect(result['customer'], isA<Map<String, dynamic>>());
      expect(result['locker'], isA<Map<String, dynamic>>());
    });

    test('throws ApiException on validation error', () async {
      dioAdapter.registerError(
        '/api/reservations',
        DioException(
          requestOptions: RequestOptions(path: '/api/reservations'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/reservations'),
            statusCode: 422,
            data: {'detail': 'Validation failed'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => datasource.createReservation(
          lockerId: 5,
          startsAt: '2026-03-15T10:00:00.000',
          endsAt: '2026-03-15T14:00:00.000',
        ),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('cancelReservation', () {
    test('sends PATCH with cancelled status', () async {
      dioAdapter.registerResponses({
        '/api/reservations/42': Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: {
            ...ReservationApiFixtures.reservationWithIris,
            'status': 'cancelled',
          },
        ),
      });

      await datasource.cancelReservation(42);
      // No exception means success
    });

    test('throws ApiException on 404', () async {
      dioAdapter.registerError(
        '/api/reservations/999',
        DioException(
          requestOptions: RequestOptions(path: '/api/reservations/999'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/reservations/999'),
            statusCode: 404,
            data: {'detail': 'Not Found'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => datasource.cancelReservation(999),
        throwsA(
          isA<ApiException>().having((e) => e.isNotFound, 'isNotFound', true),
        ),
      );
    });

    test('throws ApiException on 401 unauthorized', () async {
      dioAdapter.registerError(
        '/api/reservations/42',
        DioException(
          requestOptions: RequestOptions(path: '/api/reservations/42'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/reservations/42'),
            statusCode: 401,
            data: {'message': 'JWT Token not found'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => datasource.cancelReservation(42),
        throwsA(
          isA<ApiException>().having(
            (e) => e.isUnauthorized,
            'isUnauthorized',
            true,
          ),
        ),
      );
    });
  });
}

/// Simple DioAdapter for testing that intercepts HTTP requests.
class DioAdapter implements HttpClientAdapter {
  final Map<String, Response<dynamic>> _responses = {};
  final Map<String, DioException> _errors = {};

  void registerResponses(Map<String, Response<dynamic>> responses) {
    _responses.addAll(responses);
  }

  void registerError(String path, DioException error) {
    _errors[path] = error;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final path = options.path.startsWith('http')
        ? Uri.parse(options.path).path
        : options.path;

    if (_errors.containsKey(path)) {
      throw _errors[path]!;
    }

    final response = _responses[path];
    if (response == null) {
      throw DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: 404,
          data: {'detail': 'Not Found: $path'},
        ),
        type: DioExceptionType.badResponse,
      );
    }

    return ResponseBody.fromString(
      _encodeData(response.data),
      response.statusCode ?? 200,
      headers: {
        'content-type': ['application/json'],
      },
    );
  }

  String _encodeData(dynamic data) {
    if (data == null) return '';
    if (data is String) return data;
    return _jsonEncode(data);
  }

  String _jsonEncode(dynamic data) {
    final buffer = StringBuffer();
    _writeJson(buffer, data);
    return buffer.toString();
  }

  void _writeJson(StringBuffer buffer, dynamic data) {
    if (data == null) {
      buffer.write('null');
    } else if (data is bool) {
      buffer.write(data ? 'true' : 'false');
    } else if (data is num) {
      buffer.write(data);
    } else if (data is String) {
      buffer.write('"${data.replaceAll('"', '\\"')}"');
    } else if (data is List) {
      buffer.write('[');
      for (var i = 0; i < data.length; i++) {
        if (i > 0) buffer.write(',');
        _writeJson(buffer, data[i]);
      }
      buffer.write(']');
    } else if (data is Map) {
      buffer.write('{');
      var first = true;
      for (final entry in data.entries) {
        if (!first) buffer.write(',');
        first = false;
        _writeJson(buffer, entry.key);
        buffer.write(':');
        _writeJson(buffer, entry.value);
      }
      buffer.write('}');
    }
  }

  @override
  void close({bool force = false}) {}
}
