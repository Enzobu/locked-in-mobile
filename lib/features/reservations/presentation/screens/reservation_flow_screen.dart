import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/models/locker.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../payment/presentation/widgets/payment_step.dart';
import '../providers/reservation_flow_provider.dart';
import '../widgets/date_selection_step.dart';
import '../widgets/reservation_success_step.dart';
import '../widgets/reservation_summary_step.dart';

class ReservationFlowScreen extends ConsumerWidget {
  const ReservationFlowScreen({required this.locker, super.key});

  final Locker locker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reservationFlowProvider(locker));
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop:
          state.step == ReservationFlowStep.dateSelection ||
          state.step == ReservationFlowStep.confirmed,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          final notifier = ref.read(reservationFlowProvider(locker).notifier);
          if (state.step == ReservationFlowStep.summary) {
            notifier.goBackToDateSelection();
          } else if (state.step == ReservationFlowStep.payment) {
            notifier.goBackToSummary();
          }
        }
      },
      child: Scaffold(
        appBar: state.step != ReservationFlowStep.confirmed
            ? AppBar(
                leading: IconButton(
                  icon: const Icon(LucideIcons.arrowLeft),
                  onPressed: () {
                    if (state.step == ReservationFlowStep.summary) {
                      ref
                          .read(reservationFlowProvider(locker).notifier)
                          .goBackToDateSelection();
                    } else if (state.step == ReservationFlowStep.payment) {
                      ref
                          .read(reservationFlowProvider(locker).notifier)
                          .goBackToSummary();
                    } else {
                      context.pop();
                    }
                  },
                ),
                title: Text(
                  l10n.reservationFlowTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                centerTitle: true,
              )
            : null,
        body: SafeArea(
          child: Column(
            children: [
              if (state.step != ReservationFlowStep.confirmed)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: _StepIndicator(step: state.step),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    state.step == ReservationFlowStep.confirmed ? 0 : 16,
                    16,
                    24,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: _buildStep(state, context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(ReservationFlowState state, BuildContext context) {
    switch (state.step) {
      case ReservationFlowStep.dateSelection:
        return DateSelectionStep(key: const ValueKey('date'), locker: locker);
      case ReservationFlowStep.summary:
        return ReservationSummaryStep(
          key: const ValueKey('summary'),
          locker: locker,
        );
      case ReservationFlowStep.payment:
        return PaymentStep(key: const ValueKey('payment'), locker: locker);
      case ReservationFlowStep.confirmed:
        return ReservationSuccessStep(
          key: const ValueKey('success'),
          publicForm: state.publicForm ?? '',
          onBackToHome: () => context.go('/home'),
          onViewReservations: () => context.go('/reservations'),
        );
    }
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step});

  final ReservationFlowStep step;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final currentIndex = switch (step) {
      ReservationFlowStep.dateSelection => 0,
      ReservationFlowStep.summary => 1,
      ReservationFlowStep.payment => 2,
      ReservationFlowStep.confirmed => 2,
    };

    final steps = [
      (LucideIcons.calendarDays, l10n.reservationStartDate),
      (LucideIcons.clipboardList, l10n.reservationSummaryTitle),
      (LucideIcons.creditCard, l10n.paymentTitle),
    ];

    return Row(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: i <= currentIndex
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                ),
              ),
            ),
          _StepDot(
            icon: steps[i].$1,
            label: steps[i].$2,
            isActive: i == currentIndex,
            isCompleted: i < currentIndex,
            colorScheme: colorScheme,
            theme: theme,
          ),
        ],
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isCompleted,
    required this.colorScheme,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCompleted;
  final ColorScheme colorScheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isFilled = isActive || isCompleted;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isFilled
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? LucideIcons.check : icon,
            size: 16,
            color: isFilled
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isFilled
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
