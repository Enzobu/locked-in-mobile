import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import 'reservation_datasource.dart';

class ApiReservationDatasource implements ReservationDatasource {
  const ApiReservationDatasource({required this.dioClient});

  final DioClient dioClient;

  @override
  Future<List<Map<String, dynamic>>> getReservations() async {
    final response = await dioClient.get<dynamic>(ApiConstants.reservations);
    final list = _extractList(response.data);
    return _resolveRelations(list);
  }

  @override
  Future<Map<String, dynamic>> getReservationById(int id) async {
    final response = await dioClient.get<Map<String, dynamic>>(
      ApiConstants.reservationById(id),
    );
    return _resolveRelation(response.data!);
  }

  @override
  Future<Map<String, dynamic>> createReservation({
    required int lockerId,
    required String startsAt,
    required String endsAt,
  }) async {
    final response = await dioClient.post<Map<String, dynamic>>(
      ApiConstants.reservations,
      data: {
        'startsAt': startsAt,
        'endsAt': endsAt,
        'locker': ApiConstants.lockerIri(lockerId),
      },
    );
    return _resolveRelation(response.data!);
  }

  @override
  Future<void> cancelReservation(int id) async {
    await dioClient.patch<Map<String, dynamic>>(
      ApiConstants.reservationById(id),
      data: {'status': 'cancelled'},
    );
  }

  @override
  Future<void> openLocker(int lockerId) async {
    await dioClient.get<dynamic>(ApiConstants.openLocker(lockerId));
  }

  /// Resolves IRI relations (customer, locker) to full objects.
  /// API Platform returns relations as IRIs (e.g., "/api/customers/1")
  /// when no serialization groups embed them.
  Future<Map<String, dynamic>> _resolveRelation(
    Map<String, dynamic> json,
  ) async {
    final resolved = Map<String, dynamic>.from(json);

    if (resolved['customer'] is String) {
      final customerIri = resolved['customer'] as String;
      final customerResponse = await dioClient.get<Map<String, dynamic>>(
        customerIri,
      );
      resolved['customer'] = customerResponse.data!;
    }

    if (resolved['locker'] is String) {
      final lockerIri = resolved['locker'] as String;
      final lockerResponse = await dioClient.get<Map<String, dynamic>>(
        lockerIri,
      );
      resolved['locker'] = lockerResponse.data!;
    }

    return resolved;
  }

  Future<List<Map<String, dynamic>>> _resolveRelations(
    List<Map<String, dynamic>> list,
  ) async {
    return Future.wait(list.map(_resolveRelation));
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
