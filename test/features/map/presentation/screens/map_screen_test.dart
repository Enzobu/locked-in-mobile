import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/features/home/data/datasources/mock_locker_bay_datasource.dart';
import 'package:locked_in_mobile/features/home/data/repositories/mock_locker_bay_repository.dart';
import 'package:locked_in_mobile/features/home/presentation/providers/home_provider.dart';
import 'package:locked_in_mobile/features/map/presentation/screens/map_screen.dart';
import 'package:locked_in_mobile/l10n/app_localizations.dart';

void main() {
  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        lockerBayDatasourceProvider.overrideWithValue(
          MockLockerBayDatasource(),
        ),
        lockerBayRepositoryProvider.overrideWith((ref) {
          final ds = ref.watch(lockerBayDatasourceProvider);
          return MockLockerBayRepository(datasource: ds);
        }),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: MapScreen(),
      ),
    );
  }

  testWidgets('displays loading then map', (tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(FlutterMap), findsOneWidget);
  });

  testWidgets('displays map markers after loading', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.byType(MarkerLayer), findsOneWidget);
  });

  testWidgets('zoom buttons are visible', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.byType(InkWell), findsWidgets);
  });
}
