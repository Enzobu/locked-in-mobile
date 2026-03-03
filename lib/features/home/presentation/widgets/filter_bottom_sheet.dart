import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
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
        if (_localFilter.materials.isNotEmpty &&
            !_localFilter.materials.contains(locker.specification.material)) {
          return false;
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
    final availableMaterials = ref.watch(availableMaterialsProvider);
    final priceRange = ref.watch(priceRangeProvider);
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
                    const SizedBox(height: 20),
                    _SectionTitle(title: l10n.filterPrice),
                    const SizedBox(height: 8),
                    Text(
                      '${(currentMin / 100).toStringAsFixed(2)}\u00a0\u20ac — ${(currentMax / 100).toStringAsFixed(2)}\u00a0\u20ac',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
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
                  // Size section
                  const SizedBox(height: 20),
                  _SectionTitle(title: l10n.filterSize),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildSizeChip(
                        l10n.filterSizeSmall,
                        LockerSize.small,
                        colorScheme,
                      ),
                      _buildSizeChip(
                        l10n.filterSizeMedium,
                        LockerSize.medium,
                        colorScheme,
                      ),
                      _buildSizeChip(
                        l10n.filterSizeLarge,
                        LockerSize.large,
                        colorScheme,
                      ),
                    ],
                  ),
                  // Material section
                  if (availableMaterials.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _SectionTitle(title: l10n.filterMaterial),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: availableMaterials.map((material) {
                        final selected = _localFilter.materials.contains(
                          material,
                        );
                        return FilterChip(
                          label: Text(material),
                          selected: selected,
                          onSelected: (value) {
                            setState(() {
                              final materials = Set<String>.from(
                                _localFilter.materials,
                              );
                              if (value) {
                                materials.add(material);
                              } else {
                                materials.remove(material);
                              }
                              _localFilter = _localFilter.copyWith(
                                materials: materials,
                              );
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                  // Rechargeable section
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: Text(l10n.filterRechargeable),
                    contentPadding: EdgeInsets.zero,
                    value: _localFilter.rechargeableOnly,
                    onChanged: (value) {
                      setState(() {
                        _localFilter = _localFilter.copyWith(
                          rechargeableOnly: value,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 16),
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

  Widget _buildSizeChip(
    String label,
    LockerSize size,
    ColorScheme colorScheme,
  ) {
    final selected = _localFilter.sizes.contains(size);
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (value) {
        setState(() {
          final sizes = Set<LockerSize>.from(_localFilter.sizes);
          if (value) {
            sizes.add(size);
          } else {
            sizes.remove(size);
          }
          _localFilter = _localFilter.copyWith(sizes: sizes);
        });
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
