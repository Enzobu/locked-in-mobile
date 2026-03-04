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
        Text(
          l10n.reservationSummaryTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 20),

        // Locker section
        _SummarySection(
          icon: LucideIcons.box,
          title: l10n.reservationLocker,
          children: [
            _SummaryRow(
              label: l10n.lockerNumber(locker.number),
              value: locker.specification.name,
            ),
            _SummaryRow(
              label: l10n.lockerSize(
                locker.specification.width,
                locker.specification.height,
                locker.specification.depth,
              ),
              value: locker.specification.material,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Location section
        _SummarySection(
          icon: LucideIcons.mapPin,
          title: l10n.reservationLocation,
          children: [
            _SummaryRow(
              label: locker.lockerBay.name,
              value: locker.lockerBay.company?.name ?? '',
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Period section
        _SummarySection(
          icon: LucideIcons.calendar,
          title: l10n.reservationPeriod,
          children: [
            _SummaryRow(label: dateFormat.format(state.startsAt!), value: ''),
            _SummaryRow(
              label:
                  '${l10n.reservationDateFrom} ${timeFormat.format(state.startsAt!)}',
              value:
                  '${l10n.reservationDateTo} ${timeFormat.format(state.endsAt!)}',
            ),
            _SummaryRow(label: durationLabel, value: ''),
          ],
        ),
        const SizedBox(height: 20),

        // Total price
        Card(
          margin: EdgeInsets.zero,
          color: colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.reservationTotalPrice,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  l10n.reservationPrice(locker.priceEuros.toStringAsFixed(2)),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),

        const Spacer(),

        // Proceed to payment button
        FilledButton(
          onPressed: () => ref
              .read(reservationFlowProvider(locker).notifier)
              .goToPayment(),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            l10n.paymentProceed,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
