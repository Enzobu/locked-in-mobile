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
        child: Row(
          children: [
            // Number badge
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '${locker.number}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Price + status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.pricePerDay(
                      locker.priceEuros.toStringAsFixed(2),
                    ),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _StatusBadge(status: locker.status),
                      if (spec.isRechargeable) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          LucideIcons.zap,
                          size: 13,
                          color: Color(0xFFD97706),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          l10n.rechargeable,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: const Color(0xFFD97706),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Info button
            IconButton(
              onPressed: () => _showLockerDetail(context),
              icon: Icon(
                LucideIcons.info,
                size: 18,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              style: IconButton.styleFrom(
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
              ),
            ),
            // Reserve button
            if (isAvailable)
              FilledButton.icon(
                onPressed: () =>
                    context.push('/reservation', extra: locker),
                icon: const Icon(LucideIcons.calendarPlus, size: 16),
                label: Text(l10n.reserveLocker),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 0,
                  ),
                  minimumSize: const Size(0, 36),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showLockerDetail(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LockerDetailSheet(locker: locker),
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

class _LockerDetailSheet extends StatelessWidget {
  const _LockerDetailSheet({required this.locker});

  final Locker locker;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final spec = locker.specification;
    final isAvailable = locker.status == LockerStatus.available;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${locker.number}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.lockerNumber(locker.number),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _StatusBadge(status: locker.status),
                    ],
                  ),
                ),
                Text(
                  l10n.pricePerDay(locker.priceEuros.toStringAsFixed(2)),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Divider(
            height: 1,
            indent: 24,
            endIndent: 24,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 20),

          // Specs list
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _SpecRow(
                  icon: LucideIcons.ruler,
                  label: l10n.dimensions,
                  value: l10n.lockerSize(spec.width, spec.height, spec.depth),
                ),
                _SpecRow(
                  icon: LucideIcons.layers,
                  label: l10n.filterMaterial,
                  value: spec.material,
                ),
                _SpecRow(
                  icon: LucideIcons.tag,
                  label: l10n.lockerType,
                  value: spec.name,
                ),
                _SpecRow(
                  icon: LucideIcons.zap,
                  label: l10n.rechargeable,
                  value: spec.isRechargeable ? l10n.lockerAvailable : '—',
                  valueColor: spec.isRechargeable
                      ? const Color(0xFF16A34A)
                      : null,
                  showDivider: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          if (isAvailable)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/reservation', extra: locker);
                  },
                  icon: const Icon(LucideIcons.calendarPlus, size: 18),
                  label: Text(l10n.reserveLocker),
                ),
              ),
            ),

          SizedBox(height: isAvailable ? 24 : 8),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 10),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
      ],
    );
  }
}
