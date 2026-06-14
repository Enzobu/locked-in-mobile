import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/models/reservation.dart';
import '../../../../core/models/reservation_status.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/reservation_provider.dart';
import '../widgets/open_locker_overlay.dart';

class ReservationDetailScreen extends ConsumerStatefulWidget {
  const ReservationDetailScreen({required this.reservation, super.key});

  final Reservation reservation;

  @override
  ConsumerState<ReservationDetailScreen> createState() =>
      _ReservationDetailScreenState();
}

class _ReservationDetailScreenState
    extends ConsumerState<ReservationDetailScreen> {
  OpenLockerState? _openLockerState;

  Reservation get reservation => widget.reservation;

  /// The locker can be opened only while the reservation is confirmed/active
  /// and the current time falls within the booked window.
  bool get _isActive {
    final now = DateTime.now();
    return (reservation.status == ReservationStatus.confirmed ||
            reservation.status == ReservationStatus.active) &&
        now.isAfter(reservation.startsAt) &&
        now.isBefore(reservation.endsAt);
  }

  bool get _isCancellable {
    return (reservation.status == ReservationStatus.active ||
            reservation.status == ReservationStatus.confirmed ||
            reservation.status == ReservationStatus.pending) &&
        reservation.endsAt.isAfter(DateTime.now());
  }

  bool get _showRefund {
    if (reservation.status != ReservationStatus.cancelled) return false;
    final status = reservation.refundStatus;
    return status != null && status.isNotEmpty && status != 'none';
  }

  Future<void> _onOpenLocker() async {
    setState(() => _openLockerState = OpenLockerState.loading);

    try {
      await ref
          .read(reservationsProvider.notifier)
          .openLocker(reservation.locker.id)
          .timeout(const Duration(seconds: 15));
      if (mounted) {
        setState(() => _openLockerState = OpenLockerState.success);
      }
    } on TimeoutException {
      if (mounted) {
        setState(() => _openLockerState = OpenLockerState.error);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _openLockerState = OpenLockerState.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft),
              onPressed: () => context.pop(),
            ),
            title: Text(
              l10n.reservationDetailTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _StatusHeader(reservation: reservation),
              if (_showRefund) ...[
                const SizedBox(height: 16),
                _RefundSection(reservation: reservation),
              ],
              const SizedBox(height: 20),
              _ReservationCodeSection(reservation: reservation),
              const SizedBox(height: 20),
              _LockerSection(reservation: reservation),
              const SizedBox(height: 20),
              _LocationSection(reservation: reservation),
              const SizedBox(height: 20),
              _PeriodSection(reservation: reservation),
              const SizedBox(height: 20),
              _SpecificationsSection(reservation: reservation),
              if (_isActive) ...[
                const SizedBox(height: 32),
                _OpenLockerButton(onPressed: _onOpenLocker),
              ],
              if (_isCancellable) ...[
                SizedBox(height: _isActive ? 12 : 32),
                _CancelButton(onPressed: () => _showCancelDialog(context)),
              ],
            ],
          ),
        ),
        if (_openLockerState != null)
          OpenLockerOverlay(
            state: _openLockerState!,
            onDone: () => setState(() => _openLockerState = null),
            onRetry: _onOpenLocker,
          ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet<bool>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                LucideIcons.alertTriangle,
                size: 28,
                color: Color(0xFFDC2626),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.reservationCancelTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.reservationCancelMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(l10n.reservationCancelConfirm),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(l10n.cancel),
              ),
            ),
          ],
        ),
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        ref
            .read(reservationsProvider.notifier)
            .cancelReservation(reservation.id);
        if (context.mounted) context.pop();
      }
    });
  }
}

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final (statusLabel, statusColor) = _statusInfo(l10n);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                LucideIcons.box,
                size: 24,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.lockerNumber(reservation.locker.number),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reservation.locker.lockerBay.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                statusLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
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

class _ReservationCodeSection extends StatelessWidget {
  const _ReservationCodeSection({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(icon: LucideIcons.qrCode, title: l10n.reservationCode),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      reservation.publicForm,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: reservation.publicForm),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(reservation.publicForm),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.copy, size: 18),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LockerSection extends StatelessWidget {
  const _LockerSection({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final locker = reservation.locker;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          icon: LucideIcons.box,
          title: l10n.reservationDetailLocker,
        ),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _InfoRow(
                  icon: LucideIcons.hash,
                  label: l10n.lockerNumber(locker.number),
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: LucideIcons.tag,
                  label: l10n.pricePerDay(locker.priceEuros.toStringAsFixed(2)),
                  valueColor: colorScheme.primary,
                ),
                if (locker.specification.isRechargeable) ...[
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: LucideIcons.zap,
                    label: l10n.rechargeable,
                    valueColor: const Color(0xFFD97706),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationSection extends StatelessWidget {
  const _LocationSection({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final lockerBay = reservation.locker.lockerBay;
    final address = lockerBay.company?.address;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          icon: LucideIcons.mapPin,
          title: l10n.reservationDetailLockerBay,
        ),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    LucideIcons.mapPin,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lockerBay.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (address != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          [
                            if (address.number != null) '${address.number} ',
                            address.street,
                            ', ${address.city}',
                          ].join(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PeriodSection extends StatelessWidget {
  const _PeriodSection({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateTimeFormat = DateFormat.yMMMd(locale).add_Hm();

    final durationMinutes = reservation.durationMinutes;
    final hours = durationMinutes ~/ 60;
    final mins = durationMinutes % 60;
    final durationText = hours > 0
        ? l10n.reservationDurationHoursMinutes(
            hours,
            mins > 0 ? mins.toString().padLeft(2, '0') : '00',
          )
        : l10n.reservationDurationMinutes(durationMinutes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          icon: LucideIcons.calendar,
          title: l10n.reservationDetailPeriod,
        ),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _InfoRow(
                  icon: LucideIcons.calendarPlus,
                  label:
                      '${l10n.reservationDateFrom} : ${dateTimeFormat.format(reservation.startsAt)}',
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: LucideIcons.calendarCheck,
                  label:
                      '${l10n.reservationDateTo} : ${dateTimeFormat.format(reservation.endsAt)}',
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: LucideIcons.clock,
                  label: '${l10n.reservationDetailDuration} : $durationText',
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: LucideIcons.tag,
                  label:
                      '${l10n.reservationDetailPrice} : ${l10n.pricePerDay(reservation.locker.priceEuros.toStringAsFixed(2))}',
                  valueColor: colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SpecificationsSection extends StatelessWidget {
  const _SpecificationsSection({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final spec = reservation.locker.specification;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          icon: LucideIcons.ruler,
          title: l10n.reservationDetailSpecifications,
        ),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _InfoRow(icon: LucideIcons.box, label: spec.name),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: LucideIcons.ruler,
                  label: l10n.reservationDetailDimensions(
                    spec.width,
                    spec.height,
                    spec.depth,
                  ),
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: LucideIcons.layers,
                  label: '${l10n.reservationDetailMaterial} : ${spec.material}',
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: spec.isRechargeable
                      ? LucideIcons.zap
                      : LucideIcons.zapOff,
                  label: spec.isRechargeable
                      ? l10n.rechargeable
                      : l10n.notRechargeable,
                  valueColor: spec.isRechargeable
                      ? const Color(0xFFD97706)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OpenLockerButton extends StatelessWidget {
  const _OpenLockerButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(LucideIcons.unlock, size: 20),
        label: Text(l10n.openLocker),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF16A34A),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(LucideIcons.trash2, size: 18),
        label: Text(l10n.reservationDetailCancelReservation),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFDC2626),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, this.valueColor});

  final IconData icon;
  final String label;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: valueColor ?? colorScheme.onSurface,
              fontWeight: valueColor != null ? FontWeight.w600 : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _RefundSection extends StatelessWidget {
  const _RefundSection({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final (label, color) = _refundInfo(l10n);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Icon(LucideIcons.receipt, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.reservationRefundLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (reservation.cancelledAt != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      l10n.reservationCancelledOn(
                        DateFormat.yMMMd(
                          locale,
                        ).format(reservation.cancelledAt!),
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  (String, Color) _refundInfo(AppLocalizations l10n) {
    return switch (reservation.refundStatus) {
      'succeeded' => (l10n.reservationRefundSucceeded, const Color(0xFF16A34A)),
      'pending' => (l10n.reservationRefundPending, const Color(0xFFD97706)),
      'failed' => (l10n.reservationRefundFailed, const Color(0xFFDC2626)),
      _ => (l10n.reservationRefundNotApplicable, const Color(0xFF6B7280)),
    };
  }
}
