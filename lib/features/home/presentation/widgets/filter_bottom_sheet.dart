import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../map/presentation/providers/geolocation_provider.dart';
import '../../domain/models/locker_filter.dart';
import '../providers/home_provider.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const FilterBottomSheet(),
    );
  }
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late LockerFilter _localFilter;

  @override
  void initState() {
    super.initState();
    _localFilter = ref.read(lockerFilterProvider);
  }

  void _resetFilters() {
    setState(() => _localFilter = LockerFilter.empty);
  }

  void _applyFilters() {
    ref.read(lockerFilterProvider.notifier).state = _localFilter;
    Navigator.of(context).pop();
  }

  int _getResultCount() {
    final query = ref.read(searchQueryProvider).toLowerCase();
    final summaries = ref.read(lockerBaySummariesProvider).valueOrNull ?? [];
    final distances = ref.read(bayDistancesProvider);

    return summaries.where((summary) {
      if (query.isNotEmpty) {
        final bay = summary.lockerBay;
        final name = bay.name.toLowerCase();
        final city = summary.city.toLowerCase();
        final companyName = bay.company?.name.toLowerCase() ?? '';
        final street = bay.company?.address.street.toLowerCase() ?? '';
        if (!name.contains(query) &&
            !city.contains(query) &&
            !companyName.contains(query) &&
            !street.contains(query)) {
          return false;
        }
      }
      if (_localFilter.maxDistanceKm != null) {
        final dist = distances[summary.lockerBay.id];
        if (dist == null || dist > _localFilter.maxDistanceKm!) return false;
      }
      if (!_localFilter.isActive) return true;
      return summary.lockers.any((locker) {
        if (_localFilter.minPriceCents != null &&
            locker.priceCents < _localFilter.minPriceCents!) {
          return false;
        }
        if (_localFilter.maxPriceCents != null &&
            locker.priceCents > _localFilter.maxPriceCents!) {
          return false;
        }
        if (_localFilter.sizes.isNotEmpty) {
          final size = LockerSize.fromHeight(locker.specification.height);
          if (!_localFilter.sizes.contains(size)) {
            return false;
          }
        }
        if (_localFilter.rechargeableOnly &&
            !locker.specification.isRechargeable) {
          return false;
        }
        return true;
      });
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final priceRange = ref.watch(priceRangeProvider);
    final hasPosition = ref.watch(geolocationProvider).hasPosition;
    final resultCount = _getResultCount();

    final hasValidPriceRange = priceRange.$1 < priceRange.$2;

    final currentMin = _localFilter.minPriceCents ?? priceRange.$1;
    final currentMax = _localFilter.maxPriceCents ?? priceRange.$2;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle bar
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
              child: Row(
                children: [
                  Text(
                    l10n.filters,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _localFilter.isActive ? _resetFilters : null,
                    child: Text(l10n.resetFilters),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Scrollable sections
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Price section
                  if (hasValidPriceRange) ...[
                    const SizedBox(height: 24),
                    _SectionHeader(
                      icon: LucideIcons.euro,
                      title: l10n.filterPrice,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _PriceBadge(
                          value: (currentMin / 100).toStringAsFixed(2),
                          colorScheme: colorScheme,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Divider(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                        _PriceBadge(
                          value: (currentMax / 100).toStringAsFixed(2),
                          colorScheme: colorScheme,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    RangeSlider(
                      values: RangeValues(
                        currentMin.toDouble(),
                        currentMax.toDouble(),
                      ),
                      min: priceRange.$1.toDouble(),
                      max: priceRange.$2.toDouble(),
                      divisions: ((priceRange.$2 - priceRange.$1) / 50)
                          .ceil()
                          .clamp(1, 100),
                      onChanged: (values) {
                        setState(() {
                          final newMin = values.start.round();
                          final newMax = values.end.round();
                          _localFilter = _localFilter.copyWith(
                            minPriceCents: () =>
                                newMin == priceRange.$1 ? null : newMin,
                            maxPriceCents: () =>
                                newMax == priceRange.$2 ? null : newMax,
                          );
                        });
                      },
                    ),
                  ],
                  // Distance section
                  if (hasPosition) ...[
                    const SizedBox(height: 24),
                    _SectionHeader(
                      icon: LucideIcons.mapPin,
                      title: l10n.filterDistance,
                    ),
                    const SizedBox(height: 12),
                    _DistanceSlider(
                      maxDistanceKm: _localFilter.maxDistanceKm,
                      colorScheme: colorScheme,
                      theme: theme,
                      l10n: l10n,
                      onChanged: (value) {
                        setState(() {
                          _localFilter = _localFilter.copyWith(
                            maxDistanceKm: () => value,
                          );
                        });
                      },
                    ),
                  ],
                  // Size section
                  const SizedBox(height: 24),
                  _SectionHeader(
                    icon: LucideIcons.ruler,
                    title: l10n.filterSize,
                  ),
                  const SizedBox(height: 12),
                  _buildSizeSelector(l10n, colorScheme, theme),
                  // Rechargeable section
                  const SizedBox(height: 24),
                  _SectionHeader(
                    icon: LucideIcons.zap,
                    title: l10n.filterRechargeable,
                  ),
                  const SizedBox(height: 12),
                  _RechargeableRow(
                    value: _localFilter.rechargeableOnly,
                    colorScheme: colorScheme,
                    theme: theme,
                    onChanged: (value) {
                      setState(() {
                        _localFilter = _localFilter.copyWith(
                          rechargeableOnly: value,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            // Footer
            const Divider(height: 1),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _applyFilters,
                    child: Text(l10n.showResults(resultCount)),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSizeSelector(
    AppLocalizations l10n,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final sizeEntries = [
      (LockerSize.small, l10n.filterSizeSmall, LucideIcons.minimize2),
      (LockerSize.medium, l10n.filterSizeMedium, LucideIcons.box),
      (LockerSize.large, l10n.filterSizeLarge, LucideIcons.maximize2),
    ];

    return Row(
      children: sizeEntries.map((entry) {
        final (size, label, icon) = entry;
        final selected = _localFilter.sizes.contains(size);
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: entry != sizeEntries.last ? 8 : 0,
            ),
            child: _SizeTile(
              label: label,
              icon: icon,
              selected: selected,
              colorScheme: colorScheme,
              theme: theme,
              onTap: () {
                setState(() {
                  final sizes = Set<LockerSize>.from(_localFilter.sizes);
                  if (selected) {
                    sizes.remove(size);
                  } else {
                    sizes.add(size);
                  }
                  _localFilter = _localFilter.copyWith(sizes: sizes);
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

class _PriceBadge extends StatelessWidget {
  const _PriceBadge({required this.value, required this.colorScheme});

  final String value;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$value\u00a0\u20ac',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _SizeTile extends StatelessWidget {
  const _SizeTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.colorScheme,
    required this.theme,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: selected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DistanceSlider extends StatelessWidget {
  const _DistanceSlider({
    required this.maxDistanceKm,
    required this.colorScheme,
    required this.theme,
    required this.l10n,
    required this.onChanged,
  });

  // Preset distance steps in km
  static const _steps = [1.0, 2.0, 5.0, 10.0, 20.0, 50.0, 100.0];

  final double? maxDistanceKm;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final AppLocalizations l10n;
  final ValueChanged<double?> onChanged;

  int get _currentIndex {
    if (maxDistanceKm == null) return _steps.length; // "unlimited"
    for (var i = 0; i < _steps.length; i++) {
      if (_steps[i] >= maxDistanceKm!) return i;
    }
    return _steps.length;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex;
    final isUnlimited = index == _steps.length;
    final displayText = isUnlimited
        ? l10n.filterDistanceNoLimit
        : l10n.filterDistanceMax(maxDistanceKm!.toStringAsFixed(0));

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isUnlimited
                ? colorScheme.surfaceContainerHighest
                : colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
            border: isUnlimited
                ? null
                : Border.all(color: colorScheme.primary, width: 1),
          ),
          child: Text(
            displayText,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isUnlimited
                  ? colorScheme.onSurfaceVariant
                  : colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Slider(
          value: index.toDouble(),
          min: 0,
          max: _steps.length.toDouble(),
          divisions: _steps.length,
          onChanged: (value) {
            final i = value.round();
            if (i >= _steps.length) {
              onChanged(null);
            } else {
              onChanged(_steps[i]);
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 km',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                l10n.filterDistanceNoLimit,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RechargeableRow extends StatelessWidget {
  const _RechargeableRow({
    required this.value,
    required this.colorScheme,
    required this.theme,
    required this.onChanged,
  });

  final bool value;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: value
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value
                ? colorScheme.primary
                : colorScheme.outlineVariant,
            width: value ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              LucideIcons.batteryCharging,
              size: 20,
              color: value
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.filterRechargeable,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: value ? FontWeight.w600 : FontWeight.w400,
                  color: value
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
