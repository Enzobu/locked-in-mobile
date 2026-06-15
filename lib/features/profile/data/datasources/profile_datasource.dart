abstract class ProfileDatasource {
  Future<Map<String, dynamic>> getProfile();

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  // TODO: Remplacer customerId par /api/customers/me quand le backend supportera PATCH /me
  Future<Map<String, dynamic>> updateProfile({
    required int customerId,
    required String firstname,
    required String lastname,
    required String email,
    String? phone,
  });
}
