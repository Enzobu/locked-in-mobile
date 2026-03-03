// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Locked In';

  @override
  String get home => 'Startseite';

  @override
  String get map => 'Karte';

  @override
  String get reservations => 'Reservierungen';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get theme => 'Thema';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get lightMode => 'Hellmodus';

  @override
  String get systemMode => 'System';

  @override
  String get login => 'Anmelden';

  @override
  String get register => 'Registrieren';

  @override
  String get logout => 'Abmelden';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get loginSubtitle =>
      'Melden Sie sich an, um auf Ihre Schließfächer zuzugreifen';

  @override
  String get emailRequired => 'E-Mail ist erforderlich';

  @override
  String get emailInvalid => 'E-Mail ist ungültig';

  @override
  String get passwordRequired => 'Passwort ist erforderlich';

  @override
  String get passwordTooShort =>
      'Das Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get loginTitle => 'Buchen Sie Ihre Schließfächer ganz einfach';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get noAccount => 'Noch kein Konto?';

  @override
  String get search => 'Suchen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get loading => 'Laden...';

  @override
  String get error => 'Fehler';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String get italian => 'Italiano';

  @override
  String get registerTitle => 'Erstellen Sie Ihr Konto';

  @override
  String get registerSubtitle =>
      'Registrieren Sie sich, um Schließfächer zu buchen';

  @override
  String get firstname => 'Vorname';

  @override
  String get lastname => 'Nachname';

  @override
  String get phone => 'Telefon';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get firstnameRequired => 'Vorname ist erforderlich';

  @override
  String get lastnameRequired => 'Nachname ist erforderlich';

  @override
  String get phoneRequired => 'Telefonnummer ist erforderlich';

  @override
  String get phoneInvalid => 'Telefonnummer ist ungültig';

  @override
  String get confirmPasswordRequired => 'Passwortbestätigung ist erforderlich';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get alreadyHaveAccount => 'Bereits ein Konto?';

  @override
  String get registerSuccess =>
      'Registrierung erfolgreich! Bitte melden Sie sich an.';

  @override
  String get invalidCredentials => 'Ungültige E-Mail oder Passwort';

  @override
  String get homeGreeting => 'Willkommen';

  @override
  String get homeTitle => 'Finden Sie Ihr Schließfach';

  @override
  String availableLockers(int available, int total) {
    return '$available/$total verfügbar';
  }

  @override
  String get rechargeable => 'Aufladen';

  @override
  String get noLockersTitle => 'Keine Schließfächer verfügbar';

  @override
  String get noLockersSubtitle =>
      'Derzeit sind keine Schließfachpunkte verfügbar. Bitte versuchen Sie es später erneut.';

  @override
  String get lockerBays => 'Schließfachpunkte';

  @override
  String get searchLockerBays => 'Schließfachpunkte suchen...';

  @override
  String noSearchResults(String query) {
    return 'Keine Ergebnisse für \"$query\". Versuchen Sie einen anderen Begriff.';
  }

  @override
  String get filters => 'Filter';

  @override
  String get resetFilters => 'Zurücksetzen';

  @override
  String get filterPrice => 'Preis';

  @override
  String get filterSize => 'Größe';

  @override
  String get filterMaterial => 'Material';

  @override
  String get filterRechargeable => 'Nur aufladbar';

  @override
  String get filterSizeSmall => 'S';

  @override
  String get filterSizeMedium => 'M';

  @override
  String get filterSizeLarge => 'L';

  @override
  String showResults(int count) {
    return '$count Ergebnisse anzeigen';
  }

  @override
  String get noFilterResults => 'Keine Schließfächer entsprechen Ihren Filtern';

  @override
  String get lockerBayDetail => 'Punktdetails';

  @override
  String get lockerBayAddress => 'Adresse';

  @override
  String get lockerBayCompany => 'Unternehmen';

  @override
  String get lockerBayLockers => 'Schließfächer';

  @override
  String lockerNumber(int number) {
    return 'Schließfach Nr. $number';
  }

  @override
  String lockerSize(int width, int height, int depth) {
    return '$width × $height × $depth cm';
  }

  @override
  String get lockerAvailable => 'Verfügbar';

  @override
  String get lockerReserved => 'Reserviert';

  @override
  String get lockerOccupied => 'Belegt';

  @override
  String get lockerOutOfOrder => 'Außer Betrieb';

  @override
  String get lockerOffline => 'Offline';

  @override
  String get reserveLocker => 'Reservieren';

  @override
  String pricePerDay(String price) {
    return '$price €';
  }

  @override
  String get mapLockerBays => 'Schließfachpunkte';

  @override
  String mapLockerBayCount(int count) {
    return '$count Schließfächer';
  }

  @override
  String get mapSeeDetails => 'Details anzeigen';

  @override
  String get mapAroundMe => 'In meiner Nähe';

  @override
  String get mapSortByProximity => 'Nach Entfernung sortieren';

  @override
  String get mapSortDefault => 'Standardsortierung';

  @override
  String mapDistance(String distance) {
    return '$distance';
  }

  @override
  String get mapLocationDenied => 'Standortzugriff wurde verweigert';

  @override
  String get mapLocationDeniedForever =>
      'Standortzugriff ist deaktiviert. Aktivieren Sie ihn in den Einstellungen.';

  @override
  String get mapLocationServiceDisabled => 'Ortungsdienst ist deaktiviert';

  @override
  String get mapOpenSettings => 'Einstellungen öffnen';

  @override
  String get mapMyPosition => 'Meine Position';
}
