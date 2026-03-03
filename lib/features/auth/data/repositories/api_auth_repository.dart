import '../../../../core/dtos/customer_dto.dart';
import '../../../../core/models/customer.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class ApiAuthRepository implements AuthRepository {
  const ApiAuthRepository({required this.datasource});

  final AuthDatasource datasource;

  @override
  Future<Customer> login(String email, String password) async {
    final data = await datasource.login(email, password);

    if (data['token'] == null) {
      throw const ApiException(
        statusCode: 401,
        message: 'Invalid response from server',
      );
    }

    return Customer(
      id: 0,
      email: email,
      firstname: '',
      lastname: '',
      birthDate: DateTime(2000),
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
  }) async {
    await datasource.register(
      email: email,
      password: password,
      firstname: firstname,
      lastname: lastname,
      birthDate: birthDate.toIso8601String(),
    );
    return login(email, password);
  }

  @override
  Future<Customer> getCurrentCustomer() async {
    final data = await datasource.getCurrentCustomer();
    return CustomerDto.fromJson(data).toDomain();
  }

  @override
  Future<void> logout() async {
    await datasource.logout();
  }
}
