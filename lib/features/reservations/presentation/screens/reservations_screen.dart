import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/models/reservation.dart';
import '../../../../core/models/reservation_status.dart';
import '../../../../core/widgets/animated_list_item.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/reservation_provider.dart';
import '../widgets/reservation_card.dart';
import '../widgets/reservation_skeleton.dart';

class ReservationsScreen extends ConsumerWidget {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final reservationsAsync = ref.watch(reservationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reservations)),
      body: reservationsAsync.when(
        loading: () => const ReservationSkeleton(),
        error: (error, _) => _ErrorState(
          onRetry: () => ref.read(reservationsProvider.notifier).refresh(),
        ),
        data: (reservations) {
          if (reservations.isEmpty) {
            return const _EmptyState();
          }
          return _ReservationsList(reservations: reservations);
        },
      ),
    );
  }
}

class _ReservationsList extends ConsumerWidget {
  const _ReservationsList({required this.reservations});

  final List<Reservation> reservations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();

    final upcoming = reservations.where((r) {
      final isActive =
          r.status == ReservationStatus.active ||
          r.status == ReservationStatus.confirmed ||
          r.status == ReservationStatus.pending;
      return isActive && r.endsAt.isAfter(now);
    }).toList()..sort((a, b) => a.startsAt.compareTo(b.startsAt));

    final past = reservations.where((r) {
      final isDone =
          r.status == ReservationStatus.completed ||
          r.status == ReservationStatus.cancelled ||
          r.status == ReservationStatus.expired;
      return isDone || r.endsAt.isBefore(now);
    }).toList()..sort((a, b) => b.startsAt.compareTo(a.startsAt));

    return RefreshIndicator(
      onRefresh: () => ref.read(reservationsProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (upcoming.isNotEmpty) ...[
            _SectionHeader(
              icon: LucideIcons.calendarClock,
              title: l10n.reservationsUpcoming,
            ),
            const SizedBox(height: 8),
            ...upcoming.asMap().entries.map(
              (entry) => AnimatedListItem(
                index: entry.key,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ReservationCard(
                    reservation: entry.value,
                    onTap: () =>
                        context.push('/reservation/detail', extra: entry.value),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (past.isNotEmpty) ...[
            _SectionHeader(
              icon: LucideIcons.history,
              title: l10n.reservationsPast,
            ),
            const SizedBox(height: 8),
            ...past.asMap().entries.map(
              (entry) => AnimatedListItem(
                index: entry.key + upcoming.length,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ReservationCard(
                    reservation: entry.value,
                    onTap: () =>
                        context.push('/reservation/detail', extra: entry.value),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.calendarCheck,
                size: 48,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.reservationsEmpty,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.reservationsEmptySubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.alertCircle,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(l10n.error, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(LucideIcons.refreshCw, size: 16),
            label: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}
