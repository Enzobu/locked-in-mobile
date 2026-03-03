import '../../../../core/mock/mock_data.dart';
import 'locker_bay_datasource.dart';

class MockLockerBayDatasource implements LockerBayDatasource {
  @override
  Future<List<Map<String, dynamic>>> getLockerBays() async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return MockData.lockerBays;
  }

  @override
  Future<Map<String, dynamic>> getLockerBayById(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return MockData.lockerBays.firstWhere(
      (bay) => bay['id'] == id,
      orElse: () => throw Exception('LockerBay not found: $id'),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getLockersByBayId(
    int lockerBayId,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return MockData.lockers
        .where((locker) {
          final bay = locker['locker_bay'] as Map<String, dynamic>;
          return bay['id'] == lockerBayId;
        })
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> searchLockerBays(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final lowerQuery = query.toLowerCase();
    return MockData.lockerBays.where((bay) {
      final name = (bay['name'] as String).toLowerCase();
      final company = bay['company'] as Map<String, dynamic>;
      final companyName = (company['name'] as String).toLowerCase();
      final address = company['address'] as Map<String, dynamic>;
      final city = (address['city'] as String).toLowerCase();
      final street = (address['street'] as String).toLowerCase();
      return name.contains(lowerQuery) ||
          companyName.contains(lowerQuery) ||
          city.contains(lowerQuery) ||
          street.contains(lowerQuery);
    }).toList();
  }
}
