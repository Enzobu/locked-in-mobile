import '../../../../core/models/locker.dart';
import '../../../../core/models/locker_bay.dart';
import '../../../../core/models/locker_status.dart';

class LockerBaySummary {
  const LockerBaySummary({
    required this.lockerBay,
    required this.lockers,
  });

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

  /// Returns distinct size categories available (e.g., ["S", "M", "L"])
  List<String> get availableSizes {
    final sizeLabels = <String>{};
    for (final locker in lockers) {
      final name = locker.specification.name.toLowerCase();
      if (name.contains('small')) {
        sizeLabels.add('S');
      } else if (name.contains('medium')) {
        sizeLabels.add('M');
      } else if (name.contains('large')) {
        sizeLabels.add('L');
      } else if (name.contains('xl') || name.contains('extra')) {
        sizeLabels.add('XL');
      }
    }
    const order = ['S', 'M', 'L', 'XL'];
    return order.where(sizeLabels.contains).toList();
  }

  /// Formatted duration range (e.g., "1h - 4h")
  String get durationRange {
    final min = lockerBay.minDuration;
    final max = lockerBay.maxDuration;
    if (min == null && max == null) return '';
    String fmt(int minutes) {
      if (minutes < 60) return '${minutes}min';
      final h = minutes ~/ 60;
      final m = minutes % 60;
      return m == 0 ? '${h}h' : '${h}h${m.toString().padLeft(2, '0')}';
    }
    if (min != null && max != null && min != max) {
      return '${fmt(min)} - ${fmt(max)}';
    }
    return fmt(max ?? min!);
  }

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
