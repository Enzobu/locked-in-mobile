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
    this.materials = const {},
    this.rechargeableOnly = false,
  });

  static const empty = LockerFilter();

  final int? minPriceCents;
  final int? maxPriceCents;
  final Set<LockerSize> sizes;
  final Set<String> materials;
  final bool rechargeableOnly;

  bool get isActive =>
      minPriceCents != null ||
      maxPriceCents != null ||
      sizes.isNotEmpty ||
      materials.isNotEmpty ||
      rechargeableOnly;

  int get activeFilterCount {
    var count = 0;
    if (minPriceCents != null || maxPriceCents != null) count++;
    if (sizes.isNotEmpty) count++;
    if (materials.isNotEmpty) count++;
    if (rechargeableOnly) count++;
    return count;
  }

  LockerFilter copyWith({
    int? Function()? minPriceCents,
    int? Function()? maxPriceCents,
    Set<LockerSize>? sizes,
    Set<String>? materials,
    bool? rechargeableOnly,
  }) {
    return LockerFilter(
      minPriceCents:
          minPriceCents != null ? minPriceCents() : this.minPriceCents,
      maxPriceCents:
          maxPriceCents != null ? maxPriceCents() : this.maxPriceCents,
      sizes: sizes ?? this.sizes,
      materials: materials ?? this.materials,
      rechargeableOnly: rechargeableOnly ?? this.rechargeableOnly,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LockerFilter) return false;
    return other.minPriceCents == minPriceCents &&
        other.maxPriceCents == maxPriceCents &&
        _setEquals(other.sizes, sizes) &&
        _setEquals(other.materials, materials) &&
        other.rechargeableOnly == rechargeableOnly;
  }

  @override
  int get hashCode => Object.hash(
    minPriceCents,
    maxPriceCents,
    Object.hashAll(sizes.toList()..sort((a, b) => a.index.compareTo(b.index))),
    Object.hashAll(materials.toList()..sort()),
    rechargeableOnly,
  );

  static bool _setEquals<T>(Set<T> a, Set<T> b) {
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }
}
