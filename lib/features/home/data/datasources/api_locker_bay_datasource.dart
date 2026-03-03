import '../../../../core/network/dio_client.dart';
import 'locker_bay_datasource.dart';

class ApiLockerBayDatasource implements LockerBayDatasource {
  const ApiLockerBayDatasource({required this.dioClient});

  final DioClient dioClient;

  @override
  Future<List<Map<String, dynamic>>> getLockerBays() async {
    final response = await dioClient.get<List<dynamic>>('/api/locker_bays');
    return response.data!.cast<Map<String, dynamic>>();
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
    final response = await dioClient.get<List<dynamic>>(
      '/api/lockers',
      queryParameters: {'lockerBay': lockerBayId},
    );
    return response.data!.cast<Map<String, dynamic>>();
  }

  @override
  Future<List<Map<String, dynamic>>> searchLockerBays(String query) async {
    final response = await dioClient.get<List<dynamic>>(
      '/api/locker_bays',
      queryParameters: {'name': query},
    );
    return response.data!.cast<Map<String, dynamic>>();
  }
}
