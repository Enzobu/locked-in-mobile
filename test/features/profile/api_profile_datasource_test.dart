import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/network/api_exception.dart';
import 'package:locked_in_mobile/core/network/dio_client.dart';
import 'package:locked_in_mobile/core/network/token_storage.dart';
import 'package:locked_in_mobile/features/profile/data/datasources/api_profile_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ignore: depend_on_referenced_packages

import '../reservations/api_reservation_datasource_test.dart';

const _customerJson = {
  'id': 1,
  'email': 'jean@example.com',
  'firstname': 'Jean',
  'lastname': 'Dupont',
  'phone': '+33612345678',
  'birthDate': '1995-06-15T00:00:00+00:00',
  'roles': <String>['ROLE_USER'],
  'addresses': <dynamic>[],
  'createdAt': '2026-01-01T00:00:00+00:00',
  'updatedAt': '2026-03-01T00:00:00+00:00',
};

void main() {
  late DioClient dioClient;
  late DioAdapter dioAdapter;
  late ApiProfileDatasource datasource;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    final tokenStorage = TokenStorage();
    dioClient = DioClient(tokenStorage: tokenStorage);
    dioAdapter = DioAdapter();
    dioClient.dio.httpClientAdapter = dioAdapter;
    datasource = ApiProfileDatasource(dioClient: dioClient);
  });

  group('getProfile', () {
    test('returns customer data from GET /api/customers/me', () async {
      dioAdapter.registerResponses({
        '/api/customers/me': Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: _customerJson,
        ),
      });

      final result = await datasource.getProfile();

      expect(result['id'], 1);
      expect(result['email'], 'jean@example.com');
      expect(result['firstname'], 'Jean');
      expect(result['phone'], '+33612345678');
    });

    test('throws ApiException on 401', () async {
      dioAdapter.registerError(
        '/api/customers/me',
        DioException(
          requestOptions: RequestOptions(path: '/api/customers/me'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/customers/me'),
            statusCode: 401,
            data: {'message': 'JWT Token not found'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => datasource.getProfile(),
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

  group('updateProfile', () {
    test('sends PATCH to /api/customers/me and returns updated data', () async {
      final updatedJson = {
        ..._customerJson,
        'firstname': 'Pierre',
        'lastname': 'Martin',
        'email': 'pierre@example.com',
        'phone': '+33698765432',
      };

      dioAdapter.registerResponses({
        '/api/customers/me': Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: updatedJson,
        ),
      });

      final result = await datasource.updateProfile(
        firstname: 'Pierre',
        lastname: 'Martin',
        email: 'pierre@example.com',
        phone: '+33698765432',
      );

      expect(result['firstname'], 'Pierre');
      expect(result['lastname'], 'Martin');
      expect(result['email'], 'pierre@example.com');
      expect(result['phone'], '+33698765432');
    });

    test('sends PATCH without phone when phone is null', () async {
      dioAdapter.registerResponses({
        '/api/customers/me': Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: _customerJson,
        ),
      });

      final result = await datasource.updateProfile(
        firstname: 'Jean',
        lastname: 'Dupont',
        email: 'jean@example.com',
      );

      expect(result['id'], 1);
    });

    test('throws ApiException on 422 validation error', () async {
      dioAdapter.registerError(
        '/api/customers/me',
        DioException(
          requestOptions: RequestOptions(path: '/api/customers/me'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/customers/me'),
            statusCode: 422,
            data: {
              'detail': 'Validation failed',
              'violations': [
                {
                  'propertyPath': 'email',
                  'message': 'This value is already used.',
                },
              ],
            },
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => datasource.updateProfile(
          firstname: 'Jean',
          lastname: 'Dupont',
          email: 'taken@example.com',
        ),
        throwsA(isA<ApiException>()),
      );
    });

    test('throws ApiException on 401 unauthorized', () async {
      dioAdapter.registerError(
        '/api/customers/me',
        DioException(
          requestOptions: RequestOptions(path: '/api/customers/me'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/customers/me'),
            statusCode: 401,
            data: {'message': 'JWT Token not found'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => datasource.updateProfile(
          firstname: 'Jean',
          lastname: 'Dupont',
          email: 'jean@example.com',
        ),
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
