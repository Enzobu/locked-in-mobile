import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/widgets/animated_pressable.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/locker_bay_summary.dart';

class NearbyCarouselCard extends StatelessWidget {
  const NearbyCarouselCard({
    super.key,
    required this.summary,
    required this.gradient,
    required this.onTap,
    this.distance,
  });

  final LockerBaySummary summary;
  final List<Color> gradient;
  final VoidCallback onTap;
  final String? distance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return AnimatedPressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    LucideIcons.box,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summary.lockerBay.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            summary.city,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          if (summary.availableSizes.isNotEmpty ||
                              summary.hasRechargeableLockers) ...[
                            const SizedBox(width: 6),
                            Text(
                              '\u00b7 ${[...summary.availableSizes, if (summary.hasRechargeableLockers) l10n.rechargeable].join(' \u00b7 ')}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (distance != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  distance!,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            Row(
              children: [
                _badge(
                  l10n.availableLockers(
                    summary.availableCount,
                    summary.totalCount,
                  ),
                ),
                const SizedBox(width: 8),
                if (summary.priceRange.isNotEmpty) _badge(summary.priceRange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
