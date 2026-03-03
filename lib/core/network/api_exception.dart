import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode, this.data});

  factory ApiException.fromDioException(DioException error) {
    final response = error.response;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(message: 'Connection timeout');
      case DioExceptionType.connectionError:
        return const ApiException(message: 'No internet connection');
      case DioExceptionType.badResponse:
        final statusCode = response?.statusCode;
        final data = response?.data;
        final message = _extractMessage(data) ?? 'Server error';
        return ApiException(
          message: message,
          statusCode: statusCode,
          data: data,
        );
      case DioExceptionType.cancel:
        return const ApiException(message: 'Request cancelled');
      default:
        return ApiException(message: error.message ?? 'Unknown error');
    }
  }

  final String message;
  final int? statusCode;
  final dynamic data;

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode != null && statusCode! >= 500;

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['detail'] as String?;
    }
    return null;
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
