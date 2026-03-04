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
  Future<Map<String, dynamic>> updateProfile({
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
    if (phone != null) {
      data['phone'] = phone;
    }

    final response = await dioClient.patch<Map<String, dynamic>>(
      '/api/customers/me',
      data: data,
    );
    return response.data!;
  }
}
