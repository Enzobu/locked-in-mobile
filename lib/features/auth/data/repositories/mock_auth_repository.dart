import '../../../../core/dtos/customer_dto.dart';
import '../../../../core/models/customer.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class MockAuthRepository implements AuthRepository {
  const MockAuthRepository({required this.datasource});

  final AuthDatasource datasource;

  @override
  Future<Customer> login(String email, String password) async {
    final data = await datasource.login(email, password);
    return CustomerDto.fromJson(data).toDomain();
  }

  @override
  Future<Customer> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required DateTime birthDate,
  }) async {
    final data = await datasource.register(
      email: email,
      password: password,
      firstname: firstname,
      lastname: lastname,
      birthDate: birthDate.toIso8601String(),
    );
    return CustomerDto.fromJson(data).toDomain();
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
