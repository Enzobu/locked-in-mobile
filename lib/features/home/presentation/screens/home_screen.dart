import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/home_provider.dart';
import '../widgets/home_empty_state.dart';
import '../widgets/home_error_state.dart';
import '../widgets/home_search_empty_state.dart';
import '../widgets/locker_bay_card.dart';
import '../widgets/locker_bay_skeleton.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredAsync = ref.watch(filteredSummariesProvider);
    final searchQuery = ref.watch(searchQueryProvider);
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                l10n.homeTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SearchBar(
                controller: _searchController,
                hintText: l10n.searchLockerBays,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    LucideIcons.search,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: searchQuery.isNotEmpty
                    ? [
                        IconButton(
                          icon: Icon(
                            LucideIcons.x,
                            size: 20,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(searchQueryProvider.notifier).state = '';
                            ref.read(searchDebounceProvider).onQueryChanged('');
                          },
                        ),
                      ]
                    : null,
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor: WidgetStatePropertyAll(
                  theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 8),
                ),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                  ref.read(searchDebounceProvider).onQueryChanged(value);
                },
              ),
            ),
            Expanded(
              child: filteredAsync.when(
                loading: () => const LockerBaySkeleton(),
                error: (error, _) => HomeErrorState(
                  message: error.toString(),
                  onRetry: () =>
                      ref.read(lockerBaySummariesProvider.notifier).refresh(),
                ),
                data: (summaries) {
                  if (summaries.isEmpty && searchQuery.isNotEmpty) {
                    return HomeSearchEmptyState(query: searchQuery);
                  }

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
