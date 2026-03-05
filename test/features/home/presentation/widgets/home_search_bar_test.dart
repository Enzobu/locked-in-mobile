import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/features/home/presentation/widgets/home_search_bar.dart';
import 'package:locked_in_mobile/l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  Widget buildWidget({
    int activeFilterCount = 0,
    String searchQuery = '',
    bool isFocused = false,
  }) {
    final controller = TextEditingController(text: searchQuery);
    final focusNode = FocusNode();

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fr'),
      home: Scaffold(
        body: HomeSearchBar(
          controller: controller,
          focusNode: focusNode,
          isFocused: isFocused,
          searchQuery: searchQuery,
          activeFilterCount: activeFilterCount,
          onChanged: (_) {},
          onClear: () {},
        ),
      ),
    );
  }

  group('HomeSearchBar', () {
    testWidgets('filter icon is always primary colored', (tester) async {
      await tester.pumpWidget(buildWidget(activeFilterCount: 0));
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.slidersHorizontal), findsOneWidget);
    });

    testWidgets('no badge shown when activeFilterCount is 0', (tester) async {
      await tester.pumpWidget(buildWidget(activeFilterCount: 0));
      await tester.pumpAndSettle();

      // No count badge text should appear
      expect(find.text('0'), findsNothing);
    });

    testWidgets('badge shows count when activeFilterCount > 0', (tester) async {
      await tester.pumpWidget(buildWidget(activeFilterCount: 3));
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('badge shows count of 1', (tester) async {
      await tester.pumpWidget(buildWidget(activeFilterCount: 1));
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('clear button shown when searchQuery is not empty', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(searchQuery: 'test'));
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.x), findsOneWidget);
    });

    testWidgets('clear button hidden when searchQuery is empty', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(searchQuery: ''));
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.x), findsNothing);
    });

    testWidgets('filter button always has primary background', (tester) async {
      await tester.pumpWidget(buildWidget(activeFilterCount: 0));
      await tester.pumpAndSettle();

      // Find the filter button container (has slidersHorizontal icon)
      final iconFinder = find.byIcon(LucideIcons.slidersHorizontal);
      expect(iconFinder, findsOneWidget);

      // The icon should use onPrimary color (white on primary bg)
      final icon = tester.widget<Icon>(iconFinder);
      final context = tester.element(iconFinder);
      final colorScheme = Theme.of(context).colorScheme;
      expect(icon.color, colorScheme.onPrimary);
    });
  });
}
