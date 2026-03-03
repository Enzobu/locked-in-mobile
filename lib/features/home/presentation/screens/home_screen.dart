import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/home_provider.dart';
import '../widgets/filter_bottom_sheet.dart';
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
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(searchQueryProvider.notifier).state = value;
    ref.read(searchDebounceProvider).onQueryChanged(value);
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final filteredAsync = ref.watch(filteredSummariesProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final filter = ref.watch(lockerFilterProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                  color: colorScheme.onSurfaceVariant,
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
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: colorScheme.brightness == Brightness.light
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _isFocused
                              ? colorScheme.outline.withValues(alpha: 0.3)
                              : colorScheme.outlineVariant.withValues(
                                  alpha: 0.3,
                                ),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: _onSearchChanged,
                        style: theme.textTheme.bodyMedium,
                        textInputAction: TextInputAction.search,
                        cursorColor: colorScheme.primary,
                        decoration: InputDecoration(
                          filled: false,
                          hintText: l10n.searchLockerBays,
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              LucideIcons.search,
                              size: 20,
                              color: _isFocused
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurfaceVariant.withValues(
                                      alpha: 0.5,
                                    ),
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 44,
                          ),
                          suffixIcon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 150),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                                ),
                            child: searchQuery.isNotEmpty
                                ? GestureDetector(
                                    key: const ValueKey('clear'),
                                    onTap: _clearSearch,
                                    child: Container(
                                      width: 44,
                                      alignment: Alignment.center,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: colorScheme.onSurfaceVariant
                                              .withValues(alpha: 0.15),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          LucideIcons.x,
                                          size: 14,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.square(
                                    key: ValueKey('empty'),
                                    dimension: 44,
                                  ),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _FilterButton(
                    activeCount: filter.activeFilterCount,
                    onTap: () => FilterBottomSheet.show(context),
                  ),
                ],
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
                  if (summaries.isEmpty &&
                      (searchQuery.isNotEmpty || filter.isActive)) {
                    return HomeSearchEmptyState(
                      query: searchQuery,
                      hasActiveFilters: filter.isActive,
                    );
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

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.activeCount, required this.onTap});

  final int activeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = activeCount > 0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primary
              : colorScheme.brightness == Brightness.light
              ? Colors.white
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive
                ? colorScheme.primary
                : colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              LucideIcons.slidersHorizontal,
              size: 20,
              color: isActive
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            ),
            if (isActive)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$activeCount',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
