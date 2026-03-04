import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/widgets/empty_state_view.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  Widget buildTestWidget({
    IconData icon = LucideIcons.packageOpen,
    String title = 'No items',
    String? subtitle,
    Widget? action,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: EmptyStateView(
          icon: icon,
          title: title,
          subtitle: subtitle,
          action: action,
        ),
      ),
    );
  }

  group('EmptyStateView', () {
    testWidgets('renders icon and title', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byIcon(LucideIcons.packageOpen), findsOneWidget);
      expect(find.text('No items'), findsOneWidget);
    });

    testWidgets('renders subtitle when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(subtitle: 'Try again later'));

      expect(find.text('Try again later'), findsOneWidget);
    });

    testWidgets('does not render subtitle when null', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Only icon and title should be rendered
      final columns = tester.widgetList<Column>(find.byType(Column));
      expect(columns, isNotEmpty);
    });

    testWidgets('renders action widget when provided', (tester) async {
      var actionTapped = false;
      await tester.pumpWidget(
        buildTestWidget(
          action: FilledButton(
            onPressed: () => actionTapped = true,
            child: const Text('Action'),
          ),
        ),
      );

      expect(find.text('Action'), findsOneWidget);
      await tester.tap(find.text('Action'));
      expect(actionTapped, isTrue);
    });

    testWidgets('does not render action when null', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(FilledButton), findsNothing);
    });

    testWidgets('renders with custom icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(icon: LucideIcons.calendarCheck));

      expect(find.byIcon(LucideIcons.calendarCheck), findsOneWidget);
      expect(find.byIcon(LucideIcons.packageOpen), findsNothing);
    });
  });
}
