import '../../../../core/mock/mock_data.dart';
import 'auth_datasource.dart';

class MockAuthDatasource implements AuthDatasource {
  bool _isLoggedIn = false;

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }
    if (password.length < 6) {
      throw Exception('Invalid credentials');
    }

    _isLoggedIn = true;
    return MockData.currentCustomer;
  }

  @override
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required String birthDate,
    required String phone,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('All fields are required');
    }

    return {
      'id': 2,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'birth_date': birthDate,
      'address': MockData.addresses[15],
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> getCurrentCustomer() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    if (!_isLoggedIn) {
      throw Exception('Not authenticated');
    }

    return MockData.currentCustomer;
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _isLoggedIn = false;
  }
}
