import '../../../../core/models/address.dart';
import '../../../../core/models/customer.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class ApiAuthRepository implements AuthRepository {
  const ApiAuthRepository({required this.datasource});

  final AuthDatasource datasource;

  @override
  Future<Customer> login(String email, String password) async {
    // The API login returns {"token": "..."}, not customer data.
    // We store the token in the provider layer and return a minimal customer.
    final data = await datasource.login(email, password);

    if (data['token'] == null) {
      throw const ApiException(
        statusCode: 401,
        message: 'Invalid response from server',
      );
    }

    // Return a temporary customer with just the email.
    // The full profile will be fetched separately if needed.
    return Customer(
      id: 0,
      email: email,
      firstname: '',
      lastname: '',
      birthDate: DateTime(2000),
      address: _emptyAddress,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<Customer> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required DateTime birthDate,
    required String phone,
  }) async {
    await datasource.register(
      email: email,
      password: password,
      firstname: firstname,
      lastname: lastname,
      birthDate: birthDate.toIso8601String(),
      phone: phone,
    );
    // After registration, login to get the token
    return login(email, password);
  }

  @override
  Future<Customer> getCurrentCustomer() async {
    final data = await datasource.getCurrentCustomer();
    return _parseCustomer(data);
  }

  @override
  Future<void> logout() async {
    await datasource.logout();
  }

  static Customer _parseCustomer(Map<String, dynamic> data) {
    return Customer(
      id: data['id'] as int? ?? 0,
      email: data['email'] as String? ?? '',
      firstname: data['firstname'] as String? ?? '',
      lastname: data['lastname'] as String? ?? '',
      birthDate: data['birthDate'] != null
          ? DateTime.parse(data['birthDate'] as String)
          : DateTime(2000),
      address: _emptyAddress,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'] as String)
          : DateTime.now(),
    );
  }
}

// Placeholder address since API returns address as IRI reference
const _emptyAddress = Address(id: 0, street: '', city: '', country: '');
