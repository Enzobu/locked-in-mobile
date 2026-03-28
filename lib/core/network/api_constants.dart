class ApiConstants {
  ApiConstants._();

  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://openinnov-backend.enzo-palermo.com',
  );

  static const stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue:
        'pk_test_51T7FfaRqlzFKHYHmkwJzz5BQ3Ji72OugXdqYzYAETKczgvmzCHA6S3TPAejacdO9NBUIqcfB7aHsH6LjL0762brd002p1Rayje',
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

  // Locker endpoints
  static String openLocker(int id) => '/api/locker/$id/open';

  // Payment endpoints
  static const paymentIntents = '/api/payments/intents';
  static String closeReservation(int id) => '/api/reservations/$id/close';
}
