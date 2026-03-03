import '../models/reservation.dart';
import '../models/reservation_status.dart';
import 'customer_dto.dart';
import 'locker_dto.dart';

class ReservationDto {
  const ReservationDto({
    required this.id,
    required this.startsAt,
    required this.endsAt,
    required this.customer,
    required this.locker,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final DateTime startsAt;
  final DateTime endsAt;
  final CustomerDto customer;
  final LockerDto locker;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory ReservationDto.fromJson(Map<String, dynamic> json) {
    return ReservationDto(
      id: json['id'] as int,
      startsAt: DateTime.parse(json['starts_at'] as String),
      endsAt: DateTime.parse(json['ends_at'] as String),
      customer:
          CustomerDto.fromJson(json['customer'] as Map<String, dynamic>),
      locker: LockerDto.fromJson(json['locker'] as Map<String, dynamic>),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'starts_at': startsAt.toIso8601String(),
      'ends_at': endsAt.toIso8601String(),
      'customer': customer.toJson(),
      'locker': locker.toJson(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Reservation toDomain() {
    return Reservation(
      id: id,
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
