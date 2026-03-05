import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/widgets/animated_pressable.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/locker_bay_summary.dart';

class FilteredResultsView extends StatelessWidget {
  const FilteredResultsView({
    super.key,
    required this.summaries,
    required this.gradients,
  });

  final List<LockerBaySummary> summaries;
  final List<List<Color>> gradients;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Row(
            children: [
              Icon(LucideIcons.search, size: 16, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                l10n.filteredResults(summaries.length),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        ...summaries.asMap().entries.map((entry) {
          final cityIdx = entry.key;
          final s = entry.value;
          final initial = s.lockerBay.name.isNotEmpty
              ? s.lockerBay.name[0].toUpperCase()
              : '?';
          final accentColor = gradients[cityIdx % gradients.length].first;

          return AnimatedPressable(
            onTap: () => context.push('/bay/${s.lockerBay.id}'),
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
                    backgroundColor: accentColor.withValues(alpha: 0.15),
                    child: Text(
                      initial,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: accentColor,
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
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            final accent = s.availableCount == 0
                                ? Colors.red
                                : s.availableCount == 1
                                ? Colors.orange
                                : Colors.green;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
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
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: accent,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (s.priceRange.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                  Icon(
                    LucideIcons.chevronRight,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 80),
      ],
    );
  }
}
