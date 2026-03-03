import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/features/home/data/datasources/mock_locker_bay_datasource.dart';
import 'package:locked_in_mobile/features/home/data/repositories/mock_locker_bay_repository.dart';
import 'package:locked_in_mobile/features/home/presentation/providers/home_provider.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        lockerBayDatasourceProvider.overrideWithValue(
          MockLockerBayDatasource(),
        ),
        lockerBayRepositoryProvider.overrideWith((ref) {
          final ds = ref.watch(lockerBayDatasourceProvider);
          return MockLockerBayRepository(datasource: ds);
        }),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('searchQueryProvider', () {
    test('initial state is empty string', () {
      final query = container.read(searchQueryProvider);
      expect(query, '');
    });

    test('updates when state is changed', () {
      container.read(searchQueryProvider.notifier).state = 'Lyon';
      expect(container.read(searchQueryProvider), 'Lyon');
    });
  });

  group('filteredSummariesProvider', () {
    test('returns all summaries when search is empty', () async {
      // Wait for summaries to load
      await container.read(lockerBaySummariesProvider.future);

      final filtered = container.read(filteredSummariesProvider);
      final allSummaries = container.read(lockerBaySummariesProvider);

      expect(filtered.value?.length, allSummaries.value?.length);
    });

    test('filters summaries by bay name', () async {
      await container.read(lockerBaySummariesProvider.future);

      // Directly trigger search via debounce provider
      container.read(searchDebounceProvider).onQueryChanged('Gare');

      // Wait for debounce (300ms + margin)
      await Future<void>.delayed(const Duration(milliseconds: 400));

      final filtered = container.read(filteredSummariesProvider);
      expect(filtered.value, isNotNull);
      expect(filtered.value!, isNotEmpty);
      for (final summary in filtered.value!) {
        final matches =
            summary.lockerBay.name.toLowerCase().contains('gare') ||
            summary.city.toLowerCase().contains('gare') ||
            (summary.lockerBay.company?.name.toLowerCase().contains('gare') ??
                false);
        expect(matches, true);
      }
    });

    test('filters summaries by city', () async {
      await container.read(lockerBaySummariesProvider.future);

      container.read(searchDebounceProvider).onQueryChanged('Paris');
      await Future<void>.delayed(const Duration(milliseconds: 400));

      final filtered = container.read(filteredSummariesProvider);
      expect(filtered.value, isNotNull);
      expect(filtered.value!, isNotEmpty);
      for (final summary in filtered.value!) {
        expect(summary.city.toLowerCase().contains('paris'), true);
      }
    });

    test('returns empty list when no match', () async {
      await container.read(lockerBaySummariesProvider.future);

      container.read(searchDebounceProvider).onQueryChanged('xyznonexistent');
      await Future<void>.delayed(const Duration(milliseconds: 400));

      final filtered = container.read(filteredSummariesProvider);
      expect(filtered.value, isNotNull);
      expect(filtered.value!, isEmpty);
    });

    test('clears filter immediately when query is emptied', () async {
      await container.read(lockerBaySummariesProvider.future);

      // Apply search
      container.read(searchDebounceProvider).onQueryChanged('Paris');
      await Future<void>.delayed(const Duration(milliseconds: 400));

      // Clear search
      container.read(searchDebounceProvider).onQueryChanged('');

      // No delay needed — clearing is immediate
      final filtered = container.read(filteredSummariesProvider);
      final all = container.read(lockerBaySummariesProvider);
      expect(filtered.value?.length, all.value?.length);
    });

    test('search is case insensitive', () async {
      await container.read(lockerBaySummariesProvider.future);

      container.read(searchDebounceProvider).onQueryChanged('PARIS');
      await Future<void>.delayed(const Duration(milliseconds: 400));

      final filtered = container.read(filteredSummariesProvider);
      expect(filtered.value, isNotNull);
      expect(filtered.value!, isNotEmpty);
    });
  });

  group('SearchDebounce', () {
    test('debounces query by 300ms', () async {
      await container.read(lockerBaySummariesProvider.future);

      container.read(searchDebounceProvider).onQueryChanged('Ly');
      container.read(searchDebounceProvider).onQueryChanged('Lyo');
      container.read(searchDebounceProvider).onQueryChanged('Lyon');

      // Before debounce fires, filter should still show all
      final beforeDebounce = container.read(filteredSummariesProvider);
      final all = container.read(lockerBaySummariesProvider);
      expect(beforeDebounce.value?.length, all.value?.length);

      // After debounce
      await Future<void>.delayed(const Duration(milliseconds: 400));

      final afterDebounce = container.read(filteredSummariesProvider);
      expect(afterDebounce.value!.length, lessThan(all.value!.length));
    });
  });
}
