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
      'roles': ['ROLE_CUSTOMER'],
      'addresses': [],
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> updateCustomer({
    required String firstname,
    required String lastname,
    required String email,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!_isLoggedIn) {
      throw Exception('Not authenticated');
    }

    final updated = Map<String, dynamic>.from(MockData.currentCustomer);
    updated['firstname'] = firstname;
    updated['lastname'] = lastname;
    updated['email'] = email;
    updated['updated_at'] = DateTime.now().toIso8601String();
    return updated;
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
