import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/app/notification_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('NotificationsNotifier', () {
    test('initial state is true (enabled)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final enabled = container.read(notificationsProvider);
      expect(enabled, isTrue);
    });

    test('toggle changes state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(notificationsProvider), isTrue);

      container.read(notificationsProvider.notifier).toggle();
      expect(container.read(notificationsProvider), isFalse);

      container.read(notificationsProvider.notifier).toggle();
      expect(container.read(notificationsProvider), isTrue);
    });

    test('setEnabled sets specific value', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(notificationsProvider.notifier).setEnabled(false);
      expect(container.read(notificationsProvider), isFalse);

      container.read(notificationsProvider.notifier).setEnabled(true);
      expect(container.read(notificationsProvider), isTrue);
    });

    test('persists value to SharedPreferences', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(notificationsProvider.notifier).toggle();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('notifications_enabled'), isFalse);
    });
  });
}
