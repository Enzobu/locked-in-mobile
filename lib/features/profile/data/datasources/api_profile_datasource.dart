import '../../../../core/network/dio_client.dart';
import 'profile_datasource.dart';

class ApiProfileDatasource implements ProfileDatasource {
  const ApiProfileDatasource({required this.dioClient});

  final DioClient dioClient;

  @override
  Future<Map<String, dynamic>> getProfile() async {
    final response = await dioClient.get<Map<String, dynamic>>(
      '/api/customers/me',
    );
    return response.data!;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await dioClient.post<void>(
      '/api/customers/me/password',
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }

  @override
  // TODO: Remplacer par PATCH /api/customers/me quand le backend le supportera
  Future<Map<String, dynamic>> updateProfile({
    required int customerId,
    required String firstname,
    required String lastname,
    required String email,
    String? phone,
  }) async {
    final data = <String, dynamic>{
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
    };
    // TODO: Envoyer phone quand le backend ajoutera le champ
    // if (phone != null) {
    //   data['phone'] = phone;
    // }

    await dioClient.patch<Map<String, dynamic>>(
      '/api/customers/$customerId',
      data: data,
    );

    // Re-fetch via /me pour avoir un format cohérent (le PATCH standard
    // API Platform renvoie un format différent du contrôleur custom /me)
    return getProfile();
  }
}
