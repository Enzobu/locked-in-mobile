import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/models/locker.dart';
import '../../../../core/models/locker_status.dart';
import '../../../../l10n/app_localizations.dart';

class LockerCard extends StatelessWidget {
  const LockerCard({required this.locker, super.key});

  final Locker locker;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final spec = locker.specification;
    final isAvailable = locker.status == LockerStatus.available;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.lockerNumber(locker.number),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _StatusBadge(status: locker.status),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _SpecChip(
                  icon: LucideIcons.ruler,
                  label: l10n.lockerSize(spec.width, spec.height, spec.depth),
                ),
                _SpecChip(icon: LucideIcons.layers, label: spec.material),
                if (spec.isRechargeable)
                  _SpecChip(
                    icon: LucideIcons.zap,
                    label: l10n.rechargeable,
                    color: const Color(0xFFD97706),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  l10n.pricePerDay(locker.priceEuros.toStringAsFixed(2)),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                  ),
                ),
                const Spacer(),
                if (isAvailable)
                  FilledButton.icon(
                    onPressed: () {
                      context.push('/reservation', extra: locker);
                    },
                    icon: const Icon(LucideIcons.calendarPlus, size: 16),
                    label: Text(l10n.reserveLocker),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      minimumSize: const Size(0, 36),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final LockerStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (label, color) = _statusInfo(l10n);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (String, Color) _statusInfo(AppLocalizations l10n) {
    return switch (status) {
      LockerStatus.available => (l10n.lockerAvailable, const Color(0xFF16A34A)),
      LockerStatus.reserved => (l10n.lockerReserved, const Color(0xFFD97706)),
      LockerStatus.occupied => (l10n.lockerOccupied, const Color(0xFFDC2626)),
      LockerStatus.outOfOrder => (
        l10n.lockerOutOfOrder,
        const Color(0xFF6B7280),
      ),
      LockerStatus.offline => (l10n.lockerOffline, const Color(0xFF6B7280)),
    };
  }
}

class _SpecChip extends StatelessWidget {
  const _SpecChip({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = color ?? theme.colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: chipColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: chipColor),
        ),
      ],
    );
  }
}
