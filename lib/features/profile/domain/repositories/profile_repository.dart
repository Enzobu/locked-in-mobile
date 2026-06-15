import '../../../../core/models/customer.dart';

abstract class ProfileRepository {
  Future<Customer> getProfile();

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  // TODO: Retirer customerId quand le backend supportera PATCH /api/customers/me
  Future<Customer> updateProfile({
    required int customerId,
    required String firstname,
    required String lastname,
    required String email,
    String? phone,
  });
}
