import '../../../../core/models/locker.dart';
import '../../../../core/models/locker_bay.dart';

abstract class LockerBayRepository {
  Future<List<LockerBay>> getLockerBays();

  Future<LockerBay> getLockerBayById(int id);

  Future<List<Locker>> getLockersByBayId(int lockerBayId);

  Future<List<Locker>> getAllLockers();

  Future<List<LockerBay>> searchLockerBays(String query);
}
