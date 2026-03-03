import '../../../../core/models/locker.dart';
import '../../../../core/models/locker_bay.dart';
import '../../../../core/models/locker_status.dart';

class LockerBaySummary {
  const LockerBaySummary({required this.lockerBay, required this.lockers});

  final LockerBay lockerBay;
  final List<Locker> lockers;

  int get totalCount => lockers.length;

  int get availableCount =>
      lockers.where((l) => l.status == LockerStatus.available).length;

  int? get minPriceCents {
    if (lockers.isEmpty) return null;
    return lockers.map((l) => l.priceCents).reduce((a, b) => a < b ? a : b);
  }

  int? get maxPriceCents {
    if (lockers.isEmpty) return null;
    return lockers.map((l) => l.priceCents).reduce((a, b) => a > b ? a : b);
  }

  bool get hasRechargeableLockers =>
      lockers.any((l) => l.specification.isRechargeable);

  String get city => lockerBay.company?.address.city ?? '';

  String get priceRange {
    if (minPriceCents == null) return '';
    final min = (minPriceCents! / 100).toStringAsFixed(2);
    if (minPriceCents == maxPriceCents) return '$min\u00a0\u20ac';
    final max = (maxPriceCents! / 100).toStringAsFixed(2);
    return '$min\u00a0-\u00a0$max\u00a0\u20ac';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LockerBaySummary &&
        other.lockerBay == lockerBay &&
        other.lockers.length == lockers.length;
  }

  @override
  int get hashCode => Object.hash(lockerBay, lockers.length);
}
