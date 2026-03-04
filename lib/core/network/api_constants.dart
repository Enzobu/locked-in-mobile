class ApiConstants {
  ApiConstants._();

  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://openinnov-backend.enzo-palermo.com',
  );

  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 15);

  // Endpoints
  static const reservations = '/api/reservations';
  static String reservationById(int id) => '/api/reservations/$id';
  static String customerIri(int id) => '/api/customers/$id';
  static String lockerIri(int id) => '/api/lockers/$id';
  static String lockerById(int id) => '/api/lockers/$id';
  static String customerMe = '/api/customers/me';
}
