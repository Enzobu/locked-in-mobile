import '../../../../core/models/customer.dart';

abstract class ProfileRepository {
  Future<Customer> getProfile();

  // TODO: Retirer customerId quand le backend supportera PATCH /api/customers/me
  Future<Customer> updateProfile({
    required int customerId,
    required String firstname,
    required String lastname,
    required String email,
    String? phone,
  });
}
