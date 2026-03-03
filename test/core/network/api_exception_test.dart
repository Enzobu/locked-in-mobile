import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/network/api_exception.dart';

void main() {
  group('ApiException', () {
    test('isUnauthorized returns true for 401', () {
      const exception = ApiException(message: 'Unauthorized', statusCode: 401);
      expect(exception.isUnauthorized, isTrue);
      expect(exception.isForbidden, isFalse);
    });

    test('isForbidden returns true for 403', () {
      const exception = ApiException(message: 'Forbidden', statusCode: 403);
      expect(exception.isForbidden, isTrue);
    });

    test('isNotFound returns true for 404', () {
      const exception = ApiException(message: 'Not found', statusCode: 404);
      expect(exception.isNotFound, isTrue);
    });

    test('isServerError returns true for 500+', () {
      const exception = ApiException(message: 'Server error', statusCode: 500);
      expect(exception.isServerError, isTrue);
    });

    test('toString includes status code and message', () {
      const exception = ApiException(message: 'Not found', statusCode: 404);
      expect(exception.toString(), 'ApiException(404): Not found');
    });
  });

  group('ApiException.fromDioException', () {
    test('handles connection timeout', () {
      final dioError = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: '/test'),
      );
      final exception = ApiException.fromDioException(dioError);
      expect(exception.message, 'Connection timeout');
    });

    test('handles connection error', () {
      final dioError = DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: '/test'),
      );
      final exception = ApiException.fromDioException(dioError);
      expect(exception.message, 'No internet connection');
    });

    test('handles bad response with message in body', () {
      final dioError = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 422,
          data: {'message': 'Validation failed'},
          requestOptions: RequestOptions(path: '/test'),
        ),
        requestOptions: RequestOptions(path: '/test'),
      );
      final exception = ApiException.fromDioException(dioError);
      expect(exception.message, 'Validation failed');
      expect(exception.statusCode, 422);
    });

    test('handles bad response with error key', () {
      final dioError = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 400,
          data: {'error': 'Bad request'},
          requestOptions: RequestOptions(path: '/test'),
        ),
        requestOptions: RequestOptions(path: '/test'),
      );
      final exception = ApiException.fromDioException(dioError);
      expect(exception.message, 'Bad request');
    });

    test('handles cancelled request', () {
      final dioError = DioException(
        type: DioExceptionType.cancel,
        requestOptions: RequestOptions(path: '/test'),
      );
      final exception = ApiException.fromDioException(dioError);
      expect(exception.message, 'Request cancelled');
    });
  });
}
