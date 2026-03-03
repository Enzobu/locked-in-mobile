/// Helpers to safely parse JSON values from the API.
///
/// API Platform (Symfony) returns decimal columns as strings
/// and uses camelCase field names. These helpers handle both
/// the API format and the mock data format (snake_case, numeric).
class JsonHelpers {
  JsonHelpers._();

  /// Parses a value that could be String, num, or null to double.
  /// Doctrine decimal types are returned as strings by the API.
  static double parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.parse(value);
    throw FormatException('Cannot parse $value as double');
  }

  /// Parses a value that could be String, num, or null to int.
  static int parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.parse(value);
    throw FormatException('Cannot parse $value as int');
  }

  /// Gets a value from a map, trying camelCase first then snake_case.
  static T? get<T>(
    Map<String, dynamic> json,
    String camelCase, [
    String? snakeCase,
  ]) {
    return (json[camelCase] ?? json[snakeCase ?? camelCase]) as T?;
  }

  /// Gets a required value, trying camelCase first then snake_case.
  static T require<T>(
    Map<String, dynamic> json,
    String camelCase, [
    String? snakeCase,
  ]) {
    final value = json[camelCase] ?? json[snakeCase ?? camelCase];
    if (value == null) {
      throw FormatException('Missing required field: $camelCase');
    }
    return value as T;
  }

  /// Parses a DateTime from a string field, trying both key formats.
  static DateTime parseDateTime(
    Map<String, dynamic> json,
    String camelCase, [
    String? snakeCase,
  ]) {
    final value = json[camelCase] ?? json[snakeCase ?? camelCase];
    return DateTime.parse(value as String);
  }

  /// Parses a nullable DateTime from a string field.
  static DateTime? parseDateTimeOrNull(
    Map<String, dynamic> json,
    String camelCase, [
    String? snakeCase,
  ]) {
    final value = json[camelCase] ?? json[snakeCase ?? camelCase];
    if (value == null) return null;
    return DateTime.parse(value as String);
  }
}
