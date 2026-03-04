import '../../../../core/dtos/customer_dto.dart';
import '../../../../core/models/customer.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_datasource.dart';

class ApiProfileRepository implements ProfileRepository {
  const ApiProfileRepository({required this.datasource});

  final ProfileDatasource datasource;

  @override
  Future<Customer> getProfile() async {
    final data = await datasource.getProfile();
    return CustomerDto.fromJson(data).toDomain();
  }

  @override
  Future<Customer> updateProfile({
    required int customerId,
    required String firstname,
    required String lastname,
    required String email,
    String? phone,
  }) async {
    final data = await datasource.updateProfile(
      customerId: customerId,
      firstname: firstname,
      lastname: lastname,
      email: email,
      phone: phone,
    );
    return CustomerDto.fromJson(data).toDomain();
  }
}
