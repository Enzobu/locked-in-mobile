import '../../../../core/models/customer.dart';

abstract class ProfileRepository {
  Future<Customer> getProfile();

  Future<Customer> updateProfile({
    required String firstname,
    required String lastname,
    required String email,
    String? phone,
  });
}
