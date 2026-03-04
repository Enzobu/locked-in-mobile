abstract class ProfileDatasource {
  Future<Map<String, dynamic>> getProfile();

  Future<Map<String, dynamic>> updateProfile({
    required String firstname,
    required String lastname,
    required String email,
    String? phone,
  });
}
