import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/models/locker.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/reservation_flow_provider.dart';

class DateSelectionStep extends ConsumerWidget {
  const DateSelectionStep({required this.locker, super.key});

  final Locker locker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reservationFlowProvider(locker));
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat.yMMMEd(locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LockerInfoHeader(locker: locker),
        const SizedBox(height: 24),

        Text(
          l10n.reservationSelectDate,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),

        // Date picker
        _SelectionCard(
          label: l10n.reservationStartDate,
          value: state.selectedDate != null
              ? dateFormat.format(state.selectedDate!)
              : l10n.reservationSelectDateHint,
          isSet: state.selectedDate != null,
          icon: LucideIcons.calendar,
          onTap: () => _pickDate(context, ref),
        ),
        const SizedBox(height: 12),

        // Time picker
        _SelectionCard(
          label: l10n.reservationStartTime,
          value: state.selectedTime != null
              ? state.selectedTime!.format(context)
              : l10n.reservationSelectDateHint,
          isSet: state.selectedTime != null,
          icon: LucideIcons.clock,
          onTap: () => _pickTime(context, ref),
        ),
        const SizedBox(height: 20),

        // Duration slider
        _DurationSlider(locker: locker),

        const Spacer(),

        // Continue button
        FilledButton(
          onPressed: state.canProceed
              ? () => ref
                    .read(reservationFlowProvider(locker).notifier)
                    .goToSummary()
              : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            l10n.reservationNext,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final state = ref.read(reservationFlowProvider(locker));
    final result = await showDatePicker(
      context: context,
      initialDate: state.selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (result != null) {
      ref.read(reservationFlowProvider(locker).notifier).setDate(result);
    }
  }

  Future<void> _pickTime(BuildContext context, WidgetRef ref) async {
    final state = ref.read(reservationFlowProvider(locker));
    final result = await showTimePicker(
      context: context,
      initialTime: state.selectedTime ?? TimeOfDay.now(),
    );
    if (result != null) {
      ref.read(reservationFlowProvider(locker).notifier).setTime(result);
    }
  }
}

class _DurationSlider extends ConsumerWidget {
  const _DurationSlider({required this.locker});

  final Locker locker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reservationFlowProvider(locker));
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final durationLabel = state.formatDuration(
      l10n.reservationDurationMinutes,
      l10n.reservationDurationHoursMinutes,
    );

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.timer, size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.reservationDurationLabel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    durationLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Slider(
              value: (state.durationMinutes ?? state.minDuration).toDouble(),
              min: state.minDuration.toDouble(),
              max: state.maxDuration.toDouble(),
              divisions: (state.maxDuration - state.minDuration) ~/ 15,
              onChanged: (value) {
                ref
                    .read(reservationFlowProvider(locker).notifier)
                    .setDuration(value.round());
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.reservationDurationMinutes(state.minDuration),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    l10n.reservationDurationMinutes(state.maxDuration),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LockerInfoHeader extends StatelessWidget {
  const _LockerInfoHeader({required this.locker});

  final Locker locker;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final spec = locker.specification;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                LucideIcons.box,
                size: 24,
                color: colorScheme.onPrimaryContainer,
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
                  Text(
                    '${locker.lockerBay.name} · ${spec.name}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              l10n.reservationPrice(locker.priceEuros.toStringAsFixed(2)),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  const _SelectionCard({
    required this.label,
    required this.value,
    required this.isSet,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final bool isSet;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 20, color: colorScheme.primary),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: isSet ? FontWeight.w600 : FontWeight.w400,
                      color: isSet
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
