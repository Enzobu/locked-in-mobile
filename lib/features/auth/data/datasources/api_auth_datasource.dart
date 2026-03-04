import '../../../../core/network/dio_client.dart';
import 'auth_datasource.dart';

class ApiAuthDatasource implements AuthDatasource {
  const ApiAuthDatasource({required this.dioClient});

  final DioClient dioClient;

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dioClient.post<Map<String, dynamic>>(
      '/api/login',
      data: {'email': email, 'password': password},
    );
    return response.data!;
  }

  @override
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required String birthDate,
  }) async {
    final response = await dioClient.post<Map<String, dynamic>>(
      '/api/register',
      data: {
        'email': email,
        'password': password,
        'firstname': firstname,
        'lastname': lastname,
        'birthDate': birthDate,
      },
    );
    return response.data!;
  }

  @override
  Future<Map<String, dynamic>> updateCustomer({
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

  @override
  Future<Map<String, dynamic>> getCurrentCustomer() async {
    final response = await dioClient.get<Map<String, dynamic>>(
      '/api/customers/me',
    );
    return response.data!;
  }

  @override
  Future<void> logout() async {
    // JWT is stateless, just clear token client-side
  }
}
