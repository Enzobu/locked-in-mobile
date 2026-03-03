import '../../../../core/network/dio_client.dart';
import 'locker_bay_datasource.dart';

class ApiLockerBayDatasource implements LockerBayDatasource {
  const ApiLockerBayDatasource({required this.dioClient});

  final DioClient dioClient;

  @override
  Future<List<Map<String, dynamic>>> getLockerBays() async {
    final response = await dioClient.get<dynamic>('/api/locker_bays');
    return _extractList(response.data);
  }

  @override
  Future<Map<String, dynamic>> getLockerBayById(int id) async {
    final response = await dioClient.get<Map<String, dynamic>>(
      '/api/locker_bays/$id',
    );
    return response.data!;
  }

  @override
  Future<List<Map<String, dynamic>>> getLockersByBayId(int lockerBayId) async {
    final response = await dioClient.get<dynamic>(
      '/api/lockers',
      queryParameters: {'lockerBay': '/api/locker_bays/$lockerBayId'},
    );
    return _extractList(response.data);
  }

  @override
  Future<List<Map<String, dynamic>>> searchLockerBays(String query) async {
    final response = await dioClient.get<dynamic>(
      '/api/locker_bays',
      queryParameters: {'name': query},
    );
    return _extractList(response.data);
  }

  List<Map<String, dynamic>> _extractList(dynamic data) {
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    if (data is Map<String, dynamic>) {
      final members = data['hydra:member'] ?? data['member'];
      if (members is List) {
        return members.cast<Map<String, dynamic>>();
      }
    }
    return [];
  }
}
