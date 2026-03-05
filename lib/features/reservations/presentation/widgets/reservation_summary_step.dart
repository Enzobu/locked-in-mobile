import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/models/locker.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/reservation_flow_provider.dart';

class ReservationSummaryStep extends ConsumerWidget {
  const ReservationSummaryStep({required this.locker, super.key});

  final Locker locker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reservationFlowProvider(locker));
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat.yMMMEd(locale);
    final timeFormat = DateFormat.Hm(locale);

    final durationLabel = state.formatDuration(
      l10n.reservationDurationMinutes,
      l10n.reservationDurationHoursMinutes,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Total price — always visible at top
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: colorScheme.primary.withValues(alpha: 0.08),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.reservationTotalPrice,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                l10n.reservationPrice(
                  locker.priceEuros.toStringAsFixed(2),
                ),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

        // Locker section
        _SummarySection(
          icon: LucideIcons.box,
          title: l10n.reservationLocker,
          children: [
            _DetailRow(
              icon: LucideIcons.hash,
              label: l10n.lockerNumber(locker.number),
              value: locker.specification.name,
            ),
            _DetailRow(
              icon: LucideIcons.ruler,
              label: l10n.lockerSize(
                locker.specification.width,
                locker.specification.height,
                locker.specification.depth,
              ),
              value: locker.specification.material,
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Location section
        _SummarySection(
          icon: LucideIcons.mapPin,
          title: l10n.reservationLocation,
          children: [
            _DetailRow(
              icon: LucideIcons.building2,
              label: locker.lockerBay.name,
              value: locker.lockerBay.company?.name ?? '',
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Period section
        _SummarySection(
          icon: LucideIcons.calendar,
          title: l10n.reservationPeriod,
          children: [
            _DetailRow(
              icon: LucideIcons.calendarDays,
              label: dateFormat.format(state.startsAt!),
            ),
            _DetailRow(
              icon: LucideIcons.clock,
              label: '${l10n.reservationDateFrom} ${timeFormat.format(state.startsAt!)}',
              value: '${l10n.reservationDateTo} ${timeFormat.format(state.endsAt!)}',
            ),
            _DetailRow(
              icon: LucideIcons.timer,
              label: durationLabel,
              showDivider: false,
            ),
          ],
        ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Proceed to payment button
        FilledButton(
          onPressed: () =>
              ref.read(reservationFlowProvider(locker).notifier).goToPayment(),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            l10n.paymentProceed,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    this.value,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String? value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 15, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (value != null && value!.isNotEmpty)
                Text(
                  value!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
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
