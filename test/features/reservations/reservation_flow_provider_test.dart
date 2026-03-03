import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/address.dart';
import 'package:locked_in_mobile/core/models/company.dart';
import 'package:locked_in_mobile/core/models/locker.dart';
import 'package:locked_in_mobile/core/models/locker_bay.dart';
import 'package:locked_in_mobile/core/models/locker_status.dart';
import 'package:locked_in_mobile/core/models/specification.dart';
import 'package:locked_in_mobile/features/reservations/data/datasources/mock_reservation_datasource.dart';
import 'package:locked_in_mobile/features/reservations/data/repositories/mock_reservation_repository.dart';
import 'package:locked_in_mobile/features/reservations/presentation/providers/reservation_flow_provider.dart';
import 'package:locked_in_mobile/features/reservations/presentation/providers/reservation_provider.dart';

Locker _createTestLocker() {
  return Locker(
    id: 1,
    number: 1,
    specification: const Specification(
      id: 1,
      name: 'Small',
      width: 30,
      height: 40,
      depth: 50,
      material: 'Acier',
      isRechargeable: false,
    ),
    priceCents: 500,
    lockerBay: const LockerBay(
      id: 1,
      name: 'Gare de Lyon',
      latitude: 48.8443,
      longitude: 2.3744,
      company: Company(
        id: 1,
        name: 'LockerBox France',
        siren: '123456789',
        address: Address(
          id: 13,
          city: 'Paris',
          country: 'France',
          street: 'Boulevard Haussmann',
        ),
      ),
    ),
    status: LockerStatus.available,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2026, 3, 1),
  );
}

void main() {
  late ProviderContainer container;
  late Locker testLocker;

  setUp(() {
    testLocker = _createTestLocker();
    container = ProviderContainer(
      overrides: [
        reservationDatasourceProvider.overrideWithValue(
          MockReservationDatasource(),
        ),
        reservationRepositoryProvider.overrideWith((ref) {
          final ds = ref.watch(reservationDatasourceProvider);
          return MockReservationRepository(datasource: ds);
        }),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ReservationFlowState', () {
    test('initial state has dateSelection step', () {
      final state = container.read(reservationFlowProvider(testLocker));

      expect(state.step, ReservationFlowStep.dateSelection);
      expect(state.startDate, isNull);
      expect(state.endDate, isNull);
      expect(state.canProceed, isFalse);
      expect(state.isSubmitting, isFalse);
      expect(state.reservation, isNull);
      expect(state.publicForm, isNull);
    });

    test('canProceed is false when dates are not set', () {
      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.canProceed, isFalse);
    });

    test('durationDays returns 0 when dates are not set', () {
      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.durationDays, 0);
    });

    test('totalPrice returns 0 when duration is 0', () {
      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.totalPrice, 0);
    });
  });

  group('ReservationFlowNotifier', () {
    test('setDateRange updates start and end dates', () {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      final start = DateTime(2026, 4, 1);
      final end = DateTime(2026, 4, 3);

      notifier.setDateRange(start, end);

      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.startDate, start);
      expect(state.endDate, end);
      expect(state.canProceed, isTrue);
      expect(state.durationDays, 2);
    });

    test('totalPrice is calculated correctly', () {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      notifier.setDateRange(DateTime(2026, 4, 1), DateTime(2026, 4, 4));

      final state = container.read(reservationFlowProvider(testLocker));
      // 3 days * 5.00 EUR = 15.00 EUR
      expect(state.totalPrice, 15.0);
      expect(state.durationDays, 3);
    });

    test('goToSummary transitions to summary step', () {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      notifier.setDateRange(DateTime(2026, 4, 1), DateTime(2026, 4, 3));
      notifier.goToSummary();

      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.step, ReservationFlowStep.summary);
    });

    test('goToSummary does nothing without dates', () {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      notifier.goToSummary();

      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.step, ReservationFlowStep.dateSelection);
    });

    test('goBackToDateSelection returns to date step', () {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      notifier.setDateRange(DateTime(2026, 4, 1), DateTime(2026, 4, 3));
      notifier.goToSummary();
      notifier.goBackToDateSelection();

      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.step, ReservationFlowStep.dateSelection);
      // Dates should be preserved
      expect(state.startDate, isNotNull);
      expect(state.endDate, isNotNull);
    });

    test(
      'confirmReservation creates reservation and generates publicForm',
      () async {
        // Keep the provider alive during async operations
        container.listen(
          reservationFlowProvider(testLocker),
          (_, __) {},
        );

        final notifier = container.read(
          reservationFlowProvider(testLocker).notifier,
        );
        notifier.setDateRange(DateTime(2026, 4, 1), DateTime(2026, 4, 3));
        notifier.goToSummary();

        await notifier.confirmReservation();

        final state = container.read(reservationFlowProvider(testLocker));
        expect(state.step, ReservationFlowStep.confirmed);
        expect(state.isSubmitting, isFalse);
        expect(state.reservation, isNotNull);
        expect(state.publicForm, isNotNull);
        expect(state.publicForm, startsWith('LI-'));
        expect(state.publicForm!.length, 11); // "LI-" + 8 chars
        expect(state.error, isNull);
      },
    );

    test('confirmReservation does nothing without dates', () async {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      await notifier.confirmReservation();

      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.step, ReservationFlowStep.dateSelection);
      expect(state.reservation, isNull);
    });
  });

  group('ReservationsNotifier', () {
    test('loads reservations on build', () async {
      final reservations = await container.read(reservationsProvider.future);

      expect(reservations, isNotEmpty);
    });

    test('refresh reloads data', () async {
      final reservations1 = await container.read(reservationsProvider.future);

      await container.read(reservationsProvider.notifier).refresh();

      final reservations2 = await container.read(reservationsProvider.future);

      expect(reservations2, isNotEmpty);
      expect(reservations2.length, reservations1.length);
    });
  });
}
