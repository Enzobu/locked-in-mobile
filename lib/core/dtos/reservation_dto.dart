import '../models/reservation.dart';
import '../models/reservation_status.dart';
import '../utils/json_helpers.dart';
import 'customer_dto.dart';
import 'locker_dto.dart';

class ReservationDto {
  const ReservationDto({
    required this.id,
    required this.publicForm,
    required this.startsAt,
    required this.endsAt,
    required this.customer,
    required this.locker,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String publicForm;
  final DateTime startsAt;
  final DateTime endsAt;
  final CustomerDto customer;
  final LockerDto locker;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory ReservationDto.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    return ReservationDto(
      id: id,
      publicForm:
          (json['publicForm'] ?? json['public_form'] ?? 'RES-$id') as String,
      startsAt: JsonHelpers.parseDateTime(json, 'startsAt', 'starts_at'),
      endsAt: JsonHelpers.parseDateTime(json, 'endsAt', 'ends_at'),
      customer: CustomerDto.fromJson(json['customer'] as Map<String, dynamic>),
      locker: LockerDto.fromJson(json['locker'] as Map<String, dynamic>),
      status: json['status'] as String,
      createdAt: JsonHelpers.parseDateTime(json, 'createdAt', 'created_at'),
      updatedAt: JsonHelpers.parseDateTime(json, 'updatedAt', 'updated_at'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'publicForm': publicForm,
      'startsAt': startsAt.toIso8601String(),
      'endsAt': endsAt.toIso8601String(),
      'customer': customer.toJson(),
      'locker': locker.toJson(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Reservation toDomain() {
    return Reservation(
      id: id,
      publicForm: publicForm,
      startsAt: startsAt,
      endsAt: endsAt,
      customer: customer.toDomain(),
      locker: locker.toDomain(),
      status: ReservationStatus.fromString(status),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ReservationDto.fromDomain(Reservation reservation) {
    return ReservationDto(
      id: reservation.id,
      publicForm: reservation.publicForm,
      startsAt: reservation.startsAt,
      endsAt: reservation.endsAt,
      customer: CustomerDto.fromDomain(reservation.customer),
      locker: LockerDto.fromDomain(reservation.locker),
      status: reservation.status.value,
      createdAt: reservation.createdAt,
      updatedAt: reservation.updatedAt,
    );
  }
}
