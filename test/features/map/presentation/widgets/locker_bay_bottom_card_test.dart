import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:locked_in_mobile/core/models/locker.dart';
import 'package:locked_in_mobile/core/models/locker_bay.dart';
import 'package:locked_in_mobile/core/models/locker_status.dart';
import 'package:locked_in_mobile/core/models/specification.dart';
import 'package:locked_in_mobile/features/home/domain/models/locker_bay_summary.dart';
import 'package:locked_in_mobile/features/map/presentation/widgets/locker_bay_bottom_card.dart';
import 'package:locked_in_mobile/l10n/app_localizations.dart';

void main() {
  const testSpec = Specification(
    id: 1,
    name: 'Standard',
    height: 50,
    width: 40,
    depth: 40,
    material: 'metal',
    isRechargeable: false,
  );

  const testLockerBay = LockerBay(
    id: 1,
    name: 'Gare de Lyon',
    latitude: 45.7640,
    longitude: 4.8357,
  );

  final now = DateTime(2026, 1, 1);

  final testLocker = Locker(
    id: 1,
    number: 1,
    specification: testSpec,
    priceCents: 500,
    lockerBay: testLockerBay,
    createdAt: now,
    updatedAt: now,
    status: LockerStatus.available,
  );

  final testSummary = LockerBaySummary(
    lockerBay: testLockerBay,
    lockers: [testLocker],
  );

  Widget createTestWidget({LatLng? userPosition}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fr'),
      home: Scaffold(
        body: LockerBayBottomCard(
          summary: testSummary,
          onTap: () {},
          onClose: () {},
          userPosition: userPosition,
        ),
      ),
    );
  }

  testWidgets('shows bay name', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Gare de Lyon'), findsOneWidget);
  });

  testWidgets('shows distance badge when user position is provided',
      (tester) async {
    // User is in Paris, bay is in Lyon (~392 km)
    await tester.pumpWidget(
      createTestWidget(userPosition: const LatLng(48.8566, 2.3522)),
    );
    await tester.pumpAndSettle();

    // Should show a distance containing "km"
    expect(find.textContaining('km'), findsOneWidget);
  });

  testWidgets('does not show distance badge when no user position',
      (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // No km or m distance badge should appear
    expect(find.textContaining('km'), findsNothing);
  });

  testWidgets('shows available lockers count', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.textContaining('1/1'), findsOneWidget);
  });

  testWidgets('calls onTap when card is tapped', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('fr'),
        home: Scaffold(
          body: LockerBayBottomCard(
            summary: testSummary,
            onTap: () => tapped = true,
            onClose: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gare de Lyon'));
    expect(tapped, isTrue);
  });

  testWidgets('calls onClose when close button is tapped', (tester) async {
    var closed = false;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('fr'),
        home: Scaffold(
          body: LockerBayBottomCard(
            summary: testSummary,
            onTap: () {},
            onClose: () => closed = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(IconButton));
    expect(closed, isTrue);
  });

  testWidgets('shows short distance in meters when very close', (tester) async {
    // User is very close to the bay (same area in Lyon)
    await tester.pumpWidget(
      createTestWidget(userPosition: const LatLng(45.7645, 4.8360)),
    );
    await tester.pumpAndSettle();

    // Should show distance in meters
    expect(find.textContaining('m'), findsWidgets);
  });
}
