import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/widgets/animated_pressable.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/home_provider.dart';

class AllBaysByCity extends ConsumerWidget {
  const AllBaysByCity({
    super.key,
    required this.gradients,
    required this.selectedCity,
    required this.showAll,
    required this.onCitySelected,
    required this.onShowAll,
  });

  final List<List<Color>> gradients;
  final String? selectedCity;
  final bool showAll;
  final ValueChanged<String> onCitySelected;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cityMap = ref.watch(citySummariesProvider);
    if (cityMap.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final cities = cityMap.keys.toList();
    final activeCity = selectedCity ?? cities.first;
    final activeCityIdx = cities.indexOf(activeCity);
    final cityColor = gradients[activeCityIdx % gradients.length].first;
    final bays = cityMap[activeCity] ?? [];
    const maxVisible = 5;
    final visibleBays = showAll ? bays : bays.take(maxVisible).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Row(
            children: [
              Icon(LucideIcons.mapPin,
                  size: 16, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                l10n.allBays,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        // City circles
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cities.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final city = cities[index];
              return _CityCircle(
                city: city,
                color: gradients[index % gradients.length].first,
                isSelected: city == activeCity,
                onTap: () => onCitySelected(city),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Bays for selected city
        ...visibleBays.map((s) {
          final initial = s.lockerBay.name.isNotEmpty
              ? s.lockerBay.name[0].toUpperCase()
              : '?';
          return AnimatedPressable(
            onTap: () => context.go('/home/${s.lockerBay.id}'),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: cityColor.withValues(alpha: 0.15),
                    child: Text(
                      initial,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cityColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.lockerBay.name,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600,),
                        ),
                        Builder(builder: (context) {
                          final accent = s.availableCount == 0
                              ? Colors.red
                              : s.availableCount == 1
                                  ? Colors.orange
                                  : Colors.green;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: accent.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              '${s.availableCount} ${l10n.lockerAvailable.toLowerCase()}${s.availableCount > 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: accent,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  if (s.priceRange.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        s.priceRange,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(width: 4),
                  Icon(LucideIcons.chevronRight,
                      size: 16, color: colorScheme.onSurfaceVariant),
                ],
              ),
            ),
          );
        }),
        if (!showAll && bays.length > maxVisible)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: TextButton(
              onPressed: onShowAll,
              child: Text(l10n.seeAll),
            ),
          ),
      ],
    );
  }
}

class _CityCircle extends StatelessWidget {
  const _CityCircle({
    required this.city,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String city;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? color : color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? color : color.withValues(alpha: 0.4),
                width: isSelected ? 2.5 : 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              city.isNotEmpty ? city[0].toUpperCase() : '?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 56,
            child: Text(
              city,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
