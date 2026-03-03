abstract class AuthDatasource {
  Future<Map<String, dynamic>> login(String email, String password);

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required String birthDate,
  });

  Future<Map<String, dynamic>> getCurrentCustomer();

  Future<Map<String, dynamic>> updateCustomer({
    required String firstname,
    required String lastname,
    required String email,
  });

  Future<void> logout();
}
