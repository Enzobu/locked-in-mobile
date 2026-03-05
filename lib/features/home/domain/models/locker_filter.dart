enum LockerSize {
  small,
  medium,
  large;

  static LockerSize fromHeight(int height) {
    if (height <= 40) return LockerSize.small;
    if (height <= 60) return LockerSize.medium;
    return LockerSize.large;
  }
}

class LockerFilter {
  const LockerFilter({
    this.minPriceCents,
    this.maxPriceCents,
    this.sizes = const {},
    this.rechargeableOnly = false,
    this.maxDistanceKm,
  });

  static const empty = LockerFilter();

  final int? minPriceCents;
  final int? maxPriceCents;
  final Set<LockerSize> sizes;
  final bool rechargeableOnly;
  final double? maxDistanceKm;

  bool get isActive =>
      minPriceCents != null ||
      maxPriceCents != null ||
      sizes.isNotEmpty ||
      rechargeableOnly ||
      maxDistanceKm != null;

  int get activeFilterCount {
    var count = 0;
    if (minPriceCents != null || maxPriceCents != null) count++;
    if (sizes.isNotEmpty) count++;
    if (rechargeableOnly) count++;
    if (maxDistanceKm != null) count++;
    return count;
  }

  LockerFilter copyWith({
    int? Function()? minPriceCents,
    int? Function()? maxPriceCents,
    Set<LockerSize>? sizes,
    bool? rechargeableOnly,
    double? Function()? maxDistanceKm,
  }) {
    return LockerFilter(
      minPriceCents: minPriceCents != null
          ? minPriceCents()
          : this.minPriceCents,
      maxPriceCents: maxPriceCents != null
          ? maxPriceCents()
          : this.maxPriceCents,
      sizes: sizes ?? this.sizes,
      rechargeableOnly: rechargeableOnly ?? this.rechargeableOnly,
      maxDistanceKm: maxDistanceKm != null
          ? maxDistanceKm()
          : this.maxDistanceKm,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LockerFilter) return false;
    return other.minPriceCents == minPriceCents &&
        other.maxPriceCents == maxPriceCents &&
        _setEquals(other.sizes, sizes) &&
        other.rechargeableOnly == rechargeableOnly &&
        other.maxDistanceKm == maxDistanceKm;
  }

  @override
  int get hashCode => Object.hash(
    minPriceCents,
    maxPriceCents,
    Object.hashAll(sizes.toList()..sort((a, b) => a.index.compareTo(b.index))),
    rechargeableOnly,
    maxDistanceKm,
  );

  static bool _setEquals<T>(Set<T> a, Set<T> b) {
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }
}
