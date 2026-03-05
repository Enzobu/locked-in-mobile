abstract class LockerBayDatasource {
  Future<List<Map<String, dynamic>>> getLockerBays();

  Future<Map<String, dynamic>> getLockerBayById(int id);

  Future<List<Map<String, dynamic>>> getLockersByBayId(int lockerBayId);

  Future<List<Map<String, dynamic>>> getAllLockers();

  Future<List<Map<String, dynamic>>> searchLockerBays(String query);
}
