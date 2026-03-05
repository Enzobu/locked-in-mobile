import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../map/presentation/providers/geolocation_provider.dart';
import '../../domain/models/locker_filter.dart';
import '../providers/home_provider.dart';
import '../widgets/all_bays_by_city.dart';
import '../widgets/filtered_results_view.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_search_empty_state.dart';
import '../widgets/locker_bay_skeleton.dart';
import '../widgets/nearby_carousel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const _gradients = [
    [Color(0xFFE60024), Color(0xFFFF6B6B)],
    [Color(0xFF1E3A5F), Color(0xFF4A90D9)],
    [Color(0xFF0F766E), Color(0xFF2DD4BF)],
    [Color(0xFF7C3AED), Color(0xFFA78BFA)],
    [Color(0xFFEA580C), Color(0xFFFB923C)],
  ];

  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isFocused = false;
  String? _selectedCity;
  bool _showAllBaysForCity = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(geolocationProvider.notifier).requestLocation();
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

    return Scaffold(
      body: SafeArea(
        child: filteredAsync.when(
          loading: () => const LockerBaySkeleton(),
          error: (error, _) => ErrorView(
            message: l10n.errorNetwork,
            onRetry: () =>
                ref.read(lockerBaySummariesProvider.notifier).refresh(),
          ),
          data: (summaries) {
            if (summaries.isEmpty &&
                (searchQuery.isNotEmpty || filter.isActive)) {
              return Stack(
                children: [
                  HomeSearchEmptyState(
                    query: searchQuery,
                    hasActiveFilters: filter.isActive,
                  ),
                  if (filter.isActive)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: FilledButton.icon(
                        onPressed: () =>
                            ref.read(lockerFilterProvider.notifier).state =
                                LockerFilter.empty,
                        icon: const Icon(LucideIcons.trash2, size: 16),
                        label: Text(l10n.clearFilters),
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          foregroundColor: theme.colorScheme.onError,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }

            if (summaries.isEmpty) {
              return EmptyStateView(
                icon: LucideIcons.packageOpen,
                title: l10n.noLockersTitle,
                subtitle: l10n.noLockersSubtitle,
              );
            }

            final distances = ref.watch(bayDistancesProvider);
            final nearby = List.of(summaries)
              ..sort((a, b) {
                final da = distances[a.lockerBay.id];
                final db = distances[b.lockerBay.id];
                if (da == null && db == null) return 0;
                if (da == null) return 1;
                if (db == null) return -1;
                return da.compareTo(db);
              });
            final nearbyTop = nearby.take(5).toList();

            return Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                      child: Text(
                        l10n.homeGreeting,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: Text(
                        l10n.homeTitle,
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    HomeSearchBar(
                      controller: _searchController,
                      focusNode: _focusNode,
                      isFocused: _isFocused,
                      searchQuery: searchQuery,
                      activeFilterCount: filter.activeFilterCount,
                      onChanged: _onSearchChanged,
                      onClear: _clearSearch,
                    ),
                    if (filter.isActive)
                      FilteredResultsView(
                        summaries: summaries,
                        gradients: _gradients,
                      )
                    else ...[
                      NearbyCarousel(
                        summaries: nearbyTop,
                        gradients: _gradients,
                      ),
                      const SizedBox(height: 28),
                      AllBaysByCity(
                        gradients: _gradients,
                        selectedCity: _selectedCity,
                        showAll: _showAllBaysForCity,
                        onCitySelected: (city) => setState(() {
                          _selectedCity = city;
                          _showAllBaysForCity = false;
                        }),
                        onShowAll: () =>
                            setState(() => _showAllBaysForCity = true),
                      ),
                    ],
                  ],
                ),
                if (filter.isActive)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: FilledButton.icon(
                      onPressed: () =>
                          ref.read(lockerFilterProvider.notifier).state =
                              LockerFilter.empty,
                      icon: const Icon(LucideIcons.trash2, size: 16),
                      label: Text(l10n.clearFilters),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
