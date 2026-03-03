import '../../../../core/models/customer.dart';

abstract class AuthRepository {
  Future<Customer> login(String email, String password);

  Future<Customer> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required DateTime birthDate,
    required String phone,
  });

  Future<Customer> getCurrentCustomer();

  Future<void> logout();
}
