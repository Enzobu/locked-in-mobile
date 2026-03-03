import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/home_provider.dart';
import '../widgets/home_empty_state.dart';
import '../widgets/home_error_state.dart';
import '../widgets/locker_bay_card.dart';
import '../widgets/locker_bay_skeleton.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summariesAsync = ref.watch(lockerBaySummariesProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Text(
                l10n.homeGreeting,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                l10n.homeTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Expanded(
              child: summariesAsync.when(
                loading: () => const LockerBaySkeleton(),
                error: (error, _) => HomeErrorState(
                  message: error.toString(),
                  onRetry: () =>
                      ref.read(lockerBaySummariesProvider.notifier).refresh(),
                ),
                data: (summaries) {
                  if (summaries.isEmpty) {
                    return const HomeEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () =>
                        ref.read(lockerBaySummariesProvider.notifier).refresh(),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: summaries.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final summary = summaries[index];
                        return LockerBayCard(
                          summary: summary,
                          onTap: () {
                            // TODO: TK-014 navigate to detail
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
