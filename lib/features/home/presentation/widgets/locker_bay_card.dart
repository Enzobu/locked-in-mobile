import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/widgets/animated_pressable.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/locker_bay_summary.dart';

class LockerBayCard extends StatelessWidget {
  const LockerBayCard({
    required this.summary,
    required this.onTap,
    this.enableHero = true,
    super.key,
  });

  final LockerBaySummary summary;
  final VoidCallback onTap;
  final bool enableHero;

  Widget _maybeHero({required String tag, required Widget child}) {
    if (!enableHero) return child;
    return Hero(
      tag: tag,
      flightShuttleBuilder: (_, animation, direction, fromContext, toContext) {
        return FadeTransition(
          opacity: animation,
          child: toContext.widget,
        );
      },
      child: Material(type: MaterialType.transparency, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return AnimatedPressable(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _maybeHero(
                    tag: 'locker_bay_icon_${summary.lockerBay.id}',
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        LucideIcons.box,
                        size: 20,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _maybeHero(
                          tag: 'locker_bay_name_${summary.lockerBay.id}',
                          child: Text(
                            summary.lockerBay.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              LucideIcons.mapPin,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              summary.city,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    LucideIcons.chevronRight,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Divider(height: 1, color: colorScheme.outlineVariant),
              const SizedBox(height: 14),
              Row(
                children: [
                  _InfoChip(
                    icon: LucideIcons.checkCircle,
                    label: l10n.availableLockers(
                      summary.availableCount,
                      summary.totalCount,
                    ),
                    color: summary.availableCount > 0
                        ? const Color(0xFF16A34A)
                        : colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  if (summary.priceRange.isNotEmpty)
                    _InfoChip(
                      icon: LucideIcons.tag,
                      label: summary.priceRange,
                      color: colorScheme.primary,
                    ),
                  const Spacer(),
                  if (summary.hasRechargeableLockers)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3CD),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            LucideIcons.zap,
                            size: 12,
                            color: Color(0xFFD97706),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.rechargeable,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: const Color(0xFFD97706),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
