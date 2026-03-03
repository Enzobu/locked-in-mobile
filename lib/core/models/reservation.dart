import 'customer.dart';
import 'locker.dart';
import 'reservation_status.dart';

class Reservation {
  const Reservation({
    required this.id,
    required this.startsAt,
    required this.endsAt,
    required this.customer,
    required this.locker,
    required this.createdAt,
    required this.updatedAt,
    this.status = ReservationStatus.pending,
  });

  final int id;
  final DateTime startsAt;
  final DateTime endsAt;
  final Customer customer;
  final Locker locker;
  final ReservationStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Duration in minutes
  int get durationMinutes => endsAt.difference(startsAt).inMinutes;

  Reservation copyWith({
    int? id,
    DateTime? startsAt,
    DateTime? endsAt,
    Customer? customer,
    Locker? locker,
    ReservationStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Reservation(
      id: id ?? this.id,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      customer: customer ?? this.customer,
      locker: locker ?? this.locker,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Reservation &&
        other.id == id &&
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
    return 'Reservation(id: $id, status: ${status.value}, startsAt: $startsAt, endsAt: $endsAt, customer: ${customer.fullName}, locker: ${locker.number})';
  }
}
