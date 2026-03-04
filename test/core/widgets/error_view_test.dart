import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/widgets/error_view.dart';
import 'package:locked_in_mobile/l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  Widget buildTestWidget({
    VoidCallback? onRetry,
    IconData? icon,
    String? title,
    String? message,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fr'),
      home: Scaffold(
        body: ErrorView(
          onRetry: onRetry ?? () {},
          icon: icon,
          title: title,
          message: message,
        ),
      ),
    );
  }

  group('ErrorView', () {
    testWidgets('renders default icon when no icon is provided', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.wifiOff), findsOneWidget);
    });

    testWidgets('renders custom icon when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(icon: LucideIcons.alertTriangle));
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.alertTriangle), findsOneWidget);
      expect(find.byIcon(LucideIcons.wifiOff), findsNothing);
    });

    testWidgets('renders message when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(message: 'Test error message'));
      await tester.pumpAndSettle();

      expect(find.text('Test error message'), findsOneWidget);
    });

    testWidgets('does not render message when null', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should only have the title text, not a message
      expect(find.byIcon(LucideIcons.refreshCw), findsOneWidget);
    });

    testWidgets('renders custom title when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(title: 'Custom Title'));
      await tester.pumpAndSettle();

      expect(find.text('Custom Title'), findsOneWidget);
    });

    testWidgets('calls onRetry when retry button is tapped', (tester) async {
      var retryCalled = false;
      await tester.pumpWidget(
        buildTestWidget(onRetry: () => retryCalled = true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(LucideIcons.refreshCw));
      expect(retryCalled, isTrue);
    });

    testWidgets('renders retry button with refresh icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.refreshCw), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });
  });
}
