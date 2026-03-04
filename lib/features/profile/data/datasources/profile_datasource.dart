abstract class ProfileDatasource {
  Future<Map<String, dynamic>> getProfile();

  // TODO: Remplacer customerId par /api/customers/me quand le backend supportera PATCH /me
  Future<Map<String, dynamic>> updateProfile({
    required int customerId,
    required String firstname,
    required String lastname,
    required String email,
    String? phone,
  });
}
