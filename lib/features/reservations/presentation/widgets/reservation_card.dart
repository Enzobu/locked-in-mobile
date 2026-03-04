import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/models/reservation.dart';
import '../../../../core/models/reservation_status.dart';
import '../../../../core/widgets/animated_pressable.dart';
import '../../../../l10n/app_localizations.dart';

class ReservationCard extends StatelessWidget {
  const ReservationCard({required this.reservation, this.onTap, super.key});

  final Reservation reservation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat.yMMMd(locale);
    final (statusLabel, statusColor) = _statusInfo(l10n);

    return AnimatedPressable(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.lockerNumber(reservation.locker.number),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          reservation.locker.lockerBay.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      statusLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (onTap != null) ...[
                    const SizedBox(width: 4),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    LucideIcons.calendar,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${dateFormat.format(reservation.startsAt)} — ${dateFormat.format(reservation.endsAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    l10n.pricePerDay(
                      reservation.locker.priceEuros.toStringAsFixed(2),
                    ),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
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

  (String, Color) _statusInfo(AppLocalizations l10n) {
    return switch (reservation.status) {
      ReservationStatus.pending => (
        l10n.reservationStatusPending,
        const Color(0xFFD97706),
      ),
      ReservationStatus.confirmed => (
        l10n.reservationStatusConfirmed,
        const Color(0xFF2563EB),
      ),
      ReservationStatus.active => (
        l10n.reservationStatusActive,
        const Color(0xFF16A34A),
      ),
      ReservationStatus.completed => (
        l10n.reservationStatusCompleted,
        const Color(0xFF6B7280),
      ),
      ReservationStatus.cancelled => (
        l10n.reservationStatusCancelled,
        const Color(0xFFDC2626),
      ),
      ReservationStatus.expired => (
        l10n.reservationStatusExpired,
        const Color(0xFF6B7280),
      ),
    };
  }
}
