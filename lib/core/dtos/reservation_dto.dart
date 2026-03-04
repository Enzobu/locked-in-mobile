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
    this.plannedAmountCents,
    this.currency,
    this.paymentIntentId,
    this.paymentStatus,
    this.actualEndsAt,
    this.overtimeMinutes,
    this.overtimeAmountCents,
    this.overtimePaymentIntentId,
    this.overtimePaymentStatus,
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
  final int? plannedAmountCents;
  final String? currency;
  final String? paymentIntentId;
  final String? paymentStatus;
  final DateTime? actualEndsAt;
  final int? overtimeMinutes;
  final int? overtimeAmountCents;
  final String? overtimePaymentIntentId;
  final String? overtimePaymentStatus;

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
      plannedAmountCents:
          (json['plannedAmountCents'] ?? json['planned_amount_cents']) as int?,
      currency: json['currency'] as String?,
      paymentIntentId:
          (json['paymentIntentId'] ?? json['payment_intent_id']) as String?,
      paymentStatus:
          (json['paymentStatus'] ?? json['payment_status']) as String?,
      actualEndsAt: json['actualEndsAt'] != null || json['actual_ends_at'] != null
          ? DateTime.parse(
              (json['actualEndsAt'] ?? json['actual_ends_at']) as String,
            )
          : null,
      overtimeMinutes:
          (json['overtimeMinutes'] ?? json['overtime_minutes']) as int?,
      overtimeAmountCents:
          (json['overtimeAmountCents'] ?? json['overtime_amount_cents'])
              as int?,
      overtimePaymentIntentId:
          (json['overtimePaymentIntentId'] ??
              json['overtime_payment_intent_id']) as String?,
      overtimePaymentStatus:
          (json['overtimePaymentStatus'] ?? json['overtime_payment_status'])
              as String?,
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
      if (plannedAmountCents != null) 'plannedAmountCents': plannedAmountCents,
      if (currency != null) 'currency': currency,
      if (paymentIntentId != null) 'paymentIntentId': paymentIntentId,
      if (paymentStatus != null) 'paymentStatus': paymentStatus,
      if (actualEndsAt != null) 'actualEndsAt': actualEndsAt!.toIso8601String(),
      if (overtimeMinutes != null) 'overtimeMinutes': overtimeMinutes,
      if (overtimeAmountCents != null)
        'overtimeAmountCents': overtimeAmountCents,
      if (overtimePaymentIntentId != null)
        'overtimePaymentIntentId': overtimePaymentIntentId,
      if (overtimePaymentStatus != null)
        'overtimePaymentStatus': overtimePaymentStatus,
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
      plannedAmountCents: plannedAmountCents,
      currency: currency,
      paymentIntentId: paymentIntentId,
      paymentStatus: paymentStatus,
      actualEndsAt: actualEndsAt,
      overtimeMinutes: overtimeMinutes,
      overtimeAmountCents: overtimeAmountCents,
      overtimePaymentIntentId: overtimePaymentIntentId,
      overtimePaymentStatus: overtimePaymentStatus,
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
      plannedAmountCents: reservation.plannedAmountCents,
      currency: reservation.currency,
      paymentIntentId: reservation.paymentIntentId,
      paymentStatus: reservation.paymentStatus,
      actualEndsAt: reservation.actualEndsAt,
      overtimeMinutes: reservation.overtimeMinutes,
      overtimeAmountCents: reservation.overtimeAmountCents,
      overtimePaymentIntentId: reservation.overtimePaymentIntentId,
      overtimePaymentStatus: reservation.overtimePaymentStatus,
    );
  }
}
