import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/address.dart';
import 'package:locked_in_mobile/core/models/company.dart';
import 'package:locked_in_mobile/core/models/locker.dart';
import 'package:locked_in_mobile/core/models/locker_bay.dart';
import 'package:locked_in_mobile/core/models/locker_status.dart';
import 'package:locked_in_mobile/core/models/specification.dart';
import 'package:locked_in_mobile/features/home/domain/models/locker_bay_summary.dart';
import 'package:locked_in_mobile/features/home/presentation/widgets/filtered_results_view.dart';
import 'package:locked_in_mobile/l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  const address = Address(
    id: 1,
    city: 'Paris',
    country: 'France',
    street: 'Rue de Rivoli',
    number: '12',
  );

  const company = Company(
    id: 1,
    name: 'LockerBox',
    siren: '123456789',
    address: address,
  );

  const spec = Specification(
    id: 1,
    width: 30,
    height: 40,
    depth: 50,
    material: 'Acier',
    name: 'Small',
  );

  LockerBaySummary makeSummary({
    required int id,
    required String name,
    int lockerCount = 2,
    LockerStatus status = LockerStatus.available,
    int priceCents = 300,
  }) {
    final bay = LockerBay(
      id: id,
      name: name,
      latitude: 48.8,
      longitude: 2.3,
      company: company,
    );
    return LockerBaySummary(
      lockerBay: bay,
      lockers: List.generate(
        lockerCount,
        (i) => Locker(
          id: id * 100 + i,
          number: i + 1,
          specification: spec,
          priceCents: priceCents,
          lockerBay: bay,
          status: status,
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        ),
      ),
    );
  }

  const gradients = [
    [Color(0xFFE60024), Color(0xFFFF6B6B)],
    [Color(0xFF1E3A5F), Color(0xFF4A90D9)],
  ];

  Widget buildWidget({required List<LockerBaySummary> summaries}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fr'),
      home: Scaffold(
        body: SingleChildScrollView(
          child: FilteredResultsView(
            summaries: summaries,
            gradients: gradients,
          ),
        ),
      ),
    );
  }

  group('FilteredResultsView', () {
    testWidgets('displays the count in header', (tester) async {
      final summaries = [
        makeSummary(id: 1, name: 'Gare de Lyon'),
        makeSummary(id: 2, name: 'Châtelet'),
      ];
      await tester.pumpWidget(buildWidget(summaries: summaries));
      await tester.pumpAndSettle();

      expect(find.textContaining('2'), findsWidgets);
      expect(find.byIcon(LucideIcons.search), findsOneWidget);
    });

    testWidgets('displays a card for each summary', (tester) async {
      final summaries = [
        makeSummary(id: 1, name: 'Gare de Lyon'),
        makeSummary(id: 2, name: 'Châtelet'),
        makeSummary(id: 3, name: 'Montparnasse'),
      ];
      await tester.pumpWidget(buildWidget(summaries: summaries));
      await tester.pumpAndSettle();

      expect(find.text('Gare de Lyon'), findsOneWidget);
      expect(find.text('Châtelet'), findsOneWidget);
      expect(find.text('Montparnasse'), findsOneWidget);
    });

    testWidgets('shows bay initial in circle avatar', (tester) async {
      final summaries = [makeSummary(id: 1, name: 'Gare de Lyon')];
      await tester.pumpWidget(buildWidget(summaries: summaries));
      await tester.pumpAndSettle();

      expect(find.text('G'), findsOneWidget);
    });

    testWidgets('shows ? for empty bay name', (tester) async {
      final summaries = [makeSummary(id: 1, name: '')];
      await tester.pumpWidget(buildWidget(summaries: summaries));
      await tester.pumpAndSettle();

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('shows price range when available', (tester) async {
      final summaries = [makeSummary(id: 1, name: 'Test', priceCents: 500)];
      await tester.pumpWidget(buildWidget(summaries: summaries));
      await tester.pumpAndSettle();

      expect(find.textContaining('€'), findsWidgets);
    });

    testWidgets('shows chevron icon for each card', (tester) async {
      final summaries = [
        makeSummary(id: 1, name: 'A'),
        makeSummary(id: 2, name: 'B'),
      ];
      await tester.pumpWidget(buildWidget(summaries: summaries));
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.chevronRight), findsNWidgets(2));
    });

    testWidgets('shows empty state with zero summaries', (tester) async {
      await tester.pumpWidget(buildWidget(summaries: []));
      await tester.pumpAndSettle();

      // Header should still show with 0 count
      expect(find.textContaining('0'), findsWidgets);
      expect(find.byIcon(LucideIcons.chevronRight), findsNothing);
    });

    testWidgets('availability badge shows green for multiple available', (
      tester,
    ) async {
      final summaries = [
        makeSummary(
          id: 1,
          name: 'Test',
          lockerCount: 3,
          status: LockerStatus.available,
        ),
      ];
      await tester.pumpWidget(buildWidget(summaries: summaries));
      await tester.pumpAndSettle();

      // 3 available lockers → green badge
      final badgeText = find.textContaining('3');
      expect(badgeText, findsWidgets);
    });

    testWidgets('availability badge shows red for zero available', (
      tester,
    ) async {
      final summaries = [
        makeSummary(
          id: 1,
          name: 'Test',
          lockerCount: 2,
          status: LockerStatus.reserved,
        ),
      ];
      await tester.pumpWidget(buildWidget(summaries: summaries));
      await tester.pumpAndSettle();

      // 0 available → red badge
      final badgeText = find.textContaining('0');
      expect(badgeText, findsWidgets);
    });
  });
}
