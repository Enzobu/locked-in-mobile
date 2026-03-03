import '../../../../core/dtos/locker_bay_dto.dart';
import '../../../../core/dtos/locker_dto.dart';
import '../../../../core/models/locker.dart';
import '../../../../core/models/locker_bay.dart';
import '../../domain/repositories/locker_bay_repository.dart';
import '../datasources/locker_bay_datasource.dart';

class MockLockerBayRepository implements LockerBayRepository {
  const MockLockerBayRepository({required this.datasource});

  final LockerBayDatasource datasource;

  @override
  Future<List<LockerBay>> getLockerBays() async {
    final data = await datasource.getLockerBays();
    return data.map((json) => LockerBayDto.fromJson(json).toDomain()).toList();
  }

  @override
  Future<LockerBay> getLockerBayById(int id) async {
    final data = await datasource.getLockerBayById(id);
    return LockerBayDto.fromJson(data).toDomain();
  }

  @override
  Future<List<Locker>> getLockersByBayId(int lockerBayId) async {
    final data = await datasource.getLockersByBayId(lockerBayId);
    return data.map((json) => LockerDto.fromJson(json).toDomain()).toList();
  }

  @override
  Future<List<LockerBay>> searchLockerBays(String query) async {
    final data = await datasource.searchLockerBays(query);
    return data.map((json) => LockerBayDto.fromJson(json).toDomain()).toList();
  }
}
