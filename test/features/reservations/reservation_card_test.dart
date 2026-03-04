import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in_mobile/core/models/address.dart';
import 'package:locked_in_mobile/core/models/customer.dart';
import 'package:locked_in_mobile/core/models/locker.dart';
import 'package:locked_in_mobile/core/models/locker_bay.dart';
import 'package:locked_in_mobile/core/models/locker_status.dart';
import 'package:locked_in_mobile/core/models/reservation.dart';
import 'package:locked_in_mobile/core/models/reservation_status.dart';
import 'package:locked_in_mobile/core/models/specification.dart';
import 'package:locked_in_mobile/features/reservations/presentation/widgets/reservation_card.dart';
import 'package:locked_in_mobile/l10n/app_localizations.dart';

void main() {
  const testSpec = Specification(
    id: 1,
    name: 'Small',
    height: 40,
    width: 30,
    depth: 50,
    material: 'Acier',
    isRechargeable: false,
  );

  const testLockerBay = LockerBay(
    id: 1,
    name: 'Gare de Lyon',
    latitude: 48.8443,
    longitude: 2.3744,
  );

  final now = DateTime(2026, 3, 3);

  final testLocker = Locker(
    id: 1,
    number: 3,
    specification: testSpec,
    priceCents: 500,
    lockerBay: testLockerBay,
    createdAt: now,
    updatedAt: now,
    status: LockerStatus.available,
  );

  final testCustomer = Customer(
    id: 1,
    email: 'test@test.com',
    firstname: 'Jean',
    lastname: 'Dupont',
    birthDate: DateTime(1995, 6, 15),
    addresses: const [
      Address(id: 1, city: 'Paris', country: 'France', street: 'Rue de Rivoli'),
    ],
    createdAt: now,
    updatedAt: now,
  );

  Widget createTestWidget(Reservation reservation) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fr'),
      home: Scaffold(body: ReservationCard(reservation: reservation)),
    );
  }

  group('ReservationCard', () {
    testWidgets('displays locker bay name', (tester) async {
      final reservation = Reservation(
        id: 1,
        publicForm: 'RES-TEST-001',
        startsAt: DateTime(2026, 4, 1),
        endsAt: DateTime(2026, 4, 3),
        customer: testCustomer,
        locker: testLocker,
        status: ReservationStatus.confirmed,
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(createTestWidget(reservation));
      await tester.pumpAndSettle();

      expect(find.text('Gare de Lyon'), findsOneWidget);
    });

    testWidgets('displays status badge for active reservation', (tester) async {
      final reservation = Reservation(
        id: 1,
        publicForm: 'RES-TEST-001',
        startsAt: DateTime(2026, 4, 1),
        endsAt: DateTime(2026, 4, 3),
        customer: testCustomer,
        locker: testLocker,
        status: ReservationStatus.active,
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(createTestWidget(reservation));
      await tester.pumpAndSettle();

      // Active status should be shown
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('displays status badge for cancelled reservation', (
      tester,
    ) async {
      final reservation = Reservation(
        id: 1,
        publicForm: 'RES-TEST-001',
        startsAt: DateTime(2026, 4, 1),
        endsAt: DateTime(2026, 4, 3),
        customer: testCustomer,
        locker: testLocker,
        status: ReservationStatus.cancelled,
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(createTestWidget(reservation));
      await tester.pumpAndSettle();

      expect(find.text('Annulée'), findsOneWidget);
    });
  });
}
