import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/network/jwt_interceptor.dart';
import 'package:locked_in_mobile/core/network/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TokenStorage tokenStorage;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    tokenStorage = TokenStorage();
  });

  group('JwtInterceptor', () {
    test('adds Authorization header when token exists', () async {
      await tokenStorage.saveTokens(accessToken: 'test-token-123');

      final interceptor = JwtInterceptor(tokenStorage: tokenStorage);
      final options = RequestOptions(path: '/test');

      await interceptor.onRequest(options, RequestInterceptorHandler());

      expect(options.headers['Authorization'], 'Bearer test-token-123');
    });

    test('does not add header when no token', () async {
      final interceptor = JwtInterceptor(tokenStorage: tokenStorage);
      final options = RequestOptions(path: '/test');

      await interceptor.onRequest(options, RequestInterceptorHandler());

      expect(options.headers['Authorization'], isNull);
    });

    test('clears tokens on 401 response', () async {
      await tokenStorage.saveTokens(accessToken: 'expired-token');
      expect(await tokenStorage.hasTokens(), isTrue);

      final interceptor = JwtInterceptor(tokenStorage: tokenStorage);
      final error = DioException(
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: '/test'),
        ),
        requestOptions: RequestOptions(path: '/test'),
      );

      // ErrorInterceptorHandler.next propagates the error, wrap in zone
      runZonedGuarded(
        () => interceptor.onError(error, ErrorInterceptorHandler()),
        (_, _) {},
      );

      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(await tokenStorage.hasTokens(), isFalse);
    });

    test('does not clear tokens on non-401 error', () async {
      await tokenStorage.saveTokens(accessToken: 'valid-token');

      final interceptor = JwtInterceptor(tokenStorage: tokenStorage);
      final error = DioException(
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: '/test'),
        ),
        requestOptions: RequestOptions(path: '/test'),
      );

      runZonedGuarded(
        () => interceptor.onError(error, ErrorInterceptorHandler()),
        (_, _) {},
      );

      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(await tokenStorage.hasTokens(), isTrue);
    });
  });
}
