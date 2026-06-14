import 'customer.dart';
import 'locker.dart';
import 'reservation_status.dart';

class Reservation {
  const Reservation({
    required this.id,
    required this.publicForm,
    required this.startsAt,
    required this.endsAt,
    required this.customer,
    required this.locker,
    required this.createdAt,
    required this.updatedAt,
    this.status = ReservationStatus.pending,
    this.plannedAmountCents,
    this.currency,
    this.paymentIntentId,
    this.paymentStatus,
    this.actualEndsAt,
    this.overtimeMinutes,
    this.overtimeAmountCents,
    this.overtimePaymentIntentId,
    this.overtimePaymentStatus,
    this.refundStatus,
    this.cancelledAt,
  });

  final int id;
  final String publicForm;
  final DateTime startsAt;
  final DateTime endsAt;
  final Customer customer;
  final Locker locker;
  final ReservationStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Payment fields
  final int? plannedAmountCents;
  final String? currency;
  final String? paymentIntentId;
  final String? paymentStatus;

  // Overtime fields
  final DateTime? actualEndsAt;
  final int? overtimeMinutes;
  final int? overtimeAmountCents;
  final String? overtimePaymentIntentId;
  final String? overtimePaymentStatus;

  // Cancellation / refund fields
  final String? refundStatus;
  final DateTime? cancelledAt;

  /// Duration in minutes
  int get durationMinutes => endsAt.difference(startsAt).inMinutes;

  Reservation copyWith({
    int? id,
    String? publicForm,
    DateTime? startsAt,
    DateTime? endsAt,
    Customer? customer,
    Locker? locker,
    ReservationStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? Function()? plannedAmountCents,
    String? Function()? currency,
    String? Function()? paymentIntentId,
    String? Function()? paymentStatus,
    DateTime? Function()? actualEndsAt,
    int? Function()? overtimeMinutes,
    int? Function()? overtimeAmountCents,
    String? Function()? overtimePaymentIntentId,
    String? Function()? overtimePaymentStatus,
    String? Function()? refundStatus,
    DateTime? Function()? cancelledAt,
  }) {
    return Reservation(
      id: id ?? this.id,
      publicForm: publicForm ?? this.publicForm,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      customer: customer ?? this.customer,
      locker: locker ?? this.locker,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      plannedAmountCents: plannedAmountCents != null
          ? plannedAmountCents()
          : this.plannedAmountCents,
      currency: currency != null ? currency() : this.currency,
      paymentIntentId: paymentIntentId != null
          ? paymentIntentId()
          : this.paymentIntentId,
      paymentStatus: paymentStatus != null
          ? paymentStatus()
          : this.paymentStatus,
      actualEndsAt: actualEndsAt != null ? actualEndsAt() : this.actualEndsAt,
      overtimeMinutes: overtimeMinutes != null
          ? overtimeMinutes()
          : this.overtimeMinutes,
      overtimeAmountCents: overtimeAmountCents != null
          ? overtimeAmountCents()
          : this.overtimeAmountCents,
      overtimePaymentIntentId: overtimePaymentIntentId != null
          ? overtimePaymentIntentId()
          : this.overtimePaymentIntentId,
      overtimePaymentStatus: overtimePaymentStatus != null
          ? overtimePaymentStatus()
          : this.overtimePaymentStatus,
      refundStatus: refundStatus != null ? refundStatus() : this.refundStatus,
      cancelledAt: cancelledAt != null ? cancelledAt() : this.cancelledAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Reservation &&
        other.id == id &&
        other.publicForm == publicForm &&
        other.startsAt == startsAt &&
        other.endsAt == endsAt &&
        other.customer == customer &&
        other.locker == locker &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    publicForm,
    startsAt,
    endsAt,
    customer,
    locker,
    status,
    createdAt,
    updatedAt,
  );

  @override
  String toString() {
    return 'Reservation(id: $id, publicForm: $publicForm, status: ${status.value}, startsAt: $startsAt, endsAt: $endsAt, customer: ${customer.fullName}, locker: ${locker.number})';
  }
}
