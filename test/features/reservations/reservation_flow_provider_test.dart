import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/address.dart';
import 'package:locked_in_mobile/core/models/company.dart';
import 'package:locked_in_mobile/core/models/locker.dart';
import 'package:locked_in_mobile/core/models/locker_bay.dart';
import 'package:locked_in_mobile/core/models/locker_status.dart';
import 'package:locked_in_mobile/core/models/specification.dart';
import 'package:locked_in_mobile/features/payment/data/services/mock_payment_service.dart';
import 'package:locked_in_mobile/features/payment/presentation/providers/payment_provider.dart';
import 'package:locked_in_mobile/features/reservations/data/datasources/mock_reservation_datasource.dart';
import 'package:locked_in_mobile/features/reservations/data/repositories/mock_reservation_repository.dart';
import 'package:locked_in_mobile/features/reservations/presentation/providers/reservation_flow_provider.dart';
import 'package:locked_in_mobile/features/reservations/presentation/providers/reservation_provider.dart';

Locker _createTestLocker({int? minDuration, int? maxDuration}) {
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
    lockerBay: LockerBay(
      id: 1,
      name: 'Gare de Lyon',
      latitude: 48.8443,
      longitude: 2.3744,
      minDuration: minDuration ?? 30,
      maxDuration: maxDuration ?? 120,
      company: Company(
        id: 1,
        name: 'LockerBox France',
        siren: '123456789',
        address: const Address(
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
        paymentServiceProvider.overrideWithValue(MockPaymentService()),
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
      expect(state.selectedDate, isNull);
      expect(state.selectedTime, isNull);
      expect(state.durationMinutes, 30); // minDuration default
      expect(state.canProceed, isFalse);
      expect(state.isSubmitting, isFalse);
      expect(state.reservationId, isNull);
      expect(state.publicForm, isNull);
    });

    test('canProceed is false when date or time not set', () {
      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.canProceed, isFalse);
    });

    test('minDuration and maxDuration come from lockerBay', () {
      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.minDuration, 30);
      expect(state.maxDuration, 120);
    });

    test('startsAt combines date and time', () {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      notifier.setDate(DateTime(2026, 4, 1));
      notifier.setTime(const TimeOfDay(hour: 14, minute: 30));

      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.startsAt, DateTime(2026, 4, 1, 14, 30));
    });

    test('endsAt adds duration to startsAt', () {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      notifier.setDate(DateTime(2026, 4, 1));
      notifier.setTime(const TimeOfDay(hour: 14, minute: 0));
      notifier.setDuration(90);

      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.endsAt, DateTime(2026, 4, 1, 15, 30));
    });
  });

  group('ReservationFlowNotifier', () {
    test('setDate updates selectedDate', () {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      notifier.setDate(DateTime(2026, 4, 1));

      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.selectedDate, DateTime(2026, 4, 1));
    });

    test('setTime updates selectedTime', () {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      notifier.setTime(const TimeOfDay(hour: 10, minute: 30));

      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.selectedTime, const TimeOfDay(hour: 10, minute: 30));
    });

    test('setDuration clamps to min/max', () {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );

      notifier.setDuration(10); // below min (30)
      expect(
        container.read(reservationFlowProvider(testLocker)).durationMinutes,
        30,
      );

      notifier.setDuration(200); // above max (120)
      expect(
        container.read(reservationFlowProvider(testLocker)).durationMinutes,
        120,
      );

      notifier.setDuration(60); // within range
      expect(
        container.read(reservationFlowProvider(testLocker)).durationMinutes,
        60,
      );
    });

    test('canProceed is true when date, time, and duration are set', () {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      notifier.setDate(DateTime(2026, 4, 1));
      notifier.setTime(const TimeOfDay(hour: 14, minute: 0));

      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.canProceed, isTrue);
    });

    test('goToSummary transitions to summary step', () {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      notifier.setDate(DateTime(2026, 4, 1));
      notifier.setTime(const TimeOfDay(hour: 14, minute: 0));
      notifier.goToSummary();

      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.step, ReservationFlowStep.summary);
    });

    test('goToSummary does nothing without date/time', () {
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
      notifier.setDate(DateTime(2026, 4, 1));
      notifier.setTime(const TimeOfDay(hour: 14, minute: 0));
      notifier.goToSummary();
      notifier.goBackToDateSelection();

      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.step, ReservationFlowStep.dateSelection);
      expect(state.selectedDate, isNotNull);
      expect(state.selectedTime, isNotNull);
    });

    test(
      'goToPayment transitions to payment step and creates intent',
      () async {
        container.listen(reservationFlowProvider(testLocker), (_, __) {});

        final notifier = container.read(
          reservationFlowProvider(testLocker).notifier,
        );
        notifier.setDate(DateTime(2026, 4, 1));
        notifier.setTime(const TimeOfDay(hour: 14, minute: 0));
        notifier.goToSummary();
        await notifier.goToPayment();

        final state = container.read(reservationFlowProvider(testLocker));
        expect(state.step, ReservationFlowStep.payment);
        expect(state.clientSecret, isNotNull);
        expect(state.reservationId, isNotNull);
        expect(state.isLoadingIntent, isFalse);
      },
    );

    test('goBackToSummary returns to summary step', () async {
      container.listen(reservationFlowProvider(testLocker), (_, __) {});

      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      notifier.setDate(DateTime(2026, 4, 1));
      notifier.setTime(const TimeOfDay(hour: 14, minute: 0));
      notifier.goToSummary();
      await notifier.goToPayment();
      notifier.goBackToSummary();

      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.step, ReservationFlowStep.summary);
    });

    test(
      'processPayment confirms card payment and transitions to confirmed',
      () async {
        container.listen(reservationFlowProvider(testLocker), (_, __) {});

        final notifier = container.read(
          reservationFlowProvider(testLocker).notifier,
        );
        notifier.setDate(DateTime(2026, 4, 1));
        notifier.setTime(const TimeOfDay(hour: 14, minute: 0));
        notifier.setDuration(60);
        notifier.goToSummary();
        await notifier.goToPayment();

        notifier.setCardComplete(true);
        await notifier.processPayment();

        final state = container.read(reservationFlowProvider(testLocker));
        expect(state.step, ReservationFlowStep.confirmed);
        expect(state.isSubmitting, isFalse);
        expect(state.reservationId, isNotNull);
        expect(state.publicForm, isNotNull);
        expect(state.publicForm, startsWith('RES-'));
        expect(state.error, isNull);
      },
    );

    test('processPayment does nothing without clientSecret', () async {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      await notifier.processPayment();

      final state = container.read(reservationFlowProvider(testLocker));
      expect(state.step, ReservationFlowStep.dateSelection);
      expect(state.reservationId, isNull);
    });
  });

  group('ReservationFlowState.formatDuration', () {
    test('formats minutes only when under 60', () {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      notifier.setDuration(45);

      final state = container.read(reservationFlowProvider(testLocker));
      final result = state.formatDuration((m) => '$m min', (h, m) => '${h}h$m');
      expect(result, '45 min');
    });

    test('formats hours and minutes when 60+', () {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      notifier.setDuration(90);

      final state = container.read(reservationFlowProvider(testLocker));
      final result = state.formatDuration((m) => '$m min', (h, m) => '${h}h$m');
      expect(result, '1h30');
    });

    test('formats exact hours', () {
      final notifier = container.read(
        reservationFlowProvider(testLocker).notifier,
      );
      notifier.setDuration(120);

      final state = container.read(reservationFlowProvider(testLocker));
      final result = state.formatDuration((m) => '$m min', (h, m) => '${h}h$m');
      expect(result, '2h00');
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
