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
          final notifier =
              ref.read(reservationFlowProvider(locker).notifier);
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
                title: Text(l10n.reservationFlowTitle),
                centerTitle: true,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(4),
                  child: _StepIndicator(step: state.step),
                ),
              )
            : null,
        body: SafeArea(
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
    final colorScheme = Theme.of(context).colorScheme;
    final progress = switch (step) {
      ReservationFlowStep.dateSelection => 1 / 3,
      ReservationFlowStep.summary => 2 / 3,
      ReservationFlowStep.payment => 1.0,
      ReservationFlowStep.confirmed => 1.0,
    };

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, value, _) {
        return LinearProgressIndicator(
          value: value,
          minHeight: 4,
          backgroundColor: colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
        );
      },
    );
  }
}
