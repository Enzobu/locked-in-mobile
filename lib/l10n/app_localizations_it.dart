// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Locked In';

  @override
  String get home => 'Home';

  @override
  String get map => 'Mappa';

  @override
  String get reservations => 'Prenotazioni';

  @override
  String get profile => 'Profilo';

  @override
  String get settings => 'Impostazioni';

  @override
  String get language => 'Lingua';

  @override
  String get theme => 'Tema';

  @override
  String get darkMode => 'Modalità scura';

  @override
  String get lightMode => 'Modalità chiara';

  @override
  String get systemMode => 'Sistema';

  @override
  String get login => 'Accedi';

  @override
  String get register => 'Registrati';

  @override
  String get logout => 'Esci';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get loginSubtitle => 'Accedi per utilizzare i tuoi armadietti';

  @override
  String get emailRequired => 'L\'email è obbligatoria';

  @override
  String get emailInvalid => 'L\'email non è valida';

  @override
  String get passwordRequired => 'La password è obbligatoria';

  @override
  String get passwordTooShort =>
      'La password deve contenere almeno 6 caratteri';

  @override
  String get loginTitle => 'Prenota i tuoi armadietti con facilità';

  @override
  String get forgotPassword => 'Password dimenticata?';

  @override
  String get noAccount => 'Non hai un account?';

  @override
  String get search => 'Cerca';

  @override
  String get cancel => 'Annulla';

  @override
  String get confirm => 'Conferma';

  @override
  String get save => 'Salva';

  @override
  String get delete => 'Elimina';

  @override
  String get retry => 'Riprova';

  @override
  String get loading => 'Caricamento...';

  @override
  String get error => 'Errore';

  @override
  String get noResults => 'Nessun risultato';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String get italian => 'Italiano';

  @override
  String get registerTitle => 'Crea il tuo account';

  @override
  String get registerSubtitle => 'Registrati per prenotare i tuoi armadietti';

  @override
  String get firstname => 'Nome';

  @override
  String get lastname => 'Cognome';

  @override
  String get phone => 'Telefono';

  @override
  String get confirmPassword => 'Conferma password';

  @override
  String get firstnameRequired => 'Il nome è obbligatorio';

  @override
  String get lastnameRequired => 'Il cognome è obbligatorio';

  @override
  String get phoneRequired => 'Il telefono è obbligatorio';

  @override
  String get phoneInvalid => 'Il numero di telefono non è valido';

  @override
  String get confirmPasswordRequired =>
      'La conferma della password è obbligatoria';

  @override
  String get passwordsDoNotMatch => 'Le password non corrispondono';

  @override
  String get alreadyHaveAccount => 'Hai già un account?';

  @override
  String get registerSuccess => 'Registrazione riuscita! Effettua l\'accesso.';

  @override
  String get invalidCredentials => 'Email o password non validi';

  @override
  String get homeGreeting => 'Benvenuto';

  @override
  String get homeTitle => 'Trova il tuo armadietto';

  @override
  String availableLockers(int available, int total) {
    return '$available/$total disponibili';
  }

  @override
  String get rechargeable => 'Ricarica';

  @override
  String get notRechargeable => 'Non ricaricabile';

  @override
  String get noLockersTitle => 'Nessun armadietto disponibile';

  @override
  String get noLockersSubtitle =>
      'Nessun punto armadietti è disponibile al momento. Riprova più tardi.';

  @override
  String get lockerBays => 'Punti armadietti';

  @override
  String get searchLockerBays => 'Cerca punti armadietti...';

  @override
  String noSearchResults(String query) {
    return 'Nessun risultato per \"$query\". Prova con un altro termine.';
  }

  @override
  String get filters => 'Filtri';

  @override
  String get resetFilters => 'Reimposta';

  @override
  String get filterPrice => 'Prezzo';

  @override
  String get filterSize => 'Dimensione';

  @override
  String get filterMaterial => 'Materiale';

  @override
  String get filterRechargeable => 'Solo ricaricabile';

  @override
  String get filterSizeSmall => 'S';

  @override
  String get filterSizeMedium => 'M';

  @override
  String get filterSizeLarge => 'L';

  @override
  String get filterDistance => 'Distanza';

  @override
  String filterDistanceMax(String distance) {
    return 'Max. $distance km';
  }

  @override
  String get filterDistanceNoLimit => 'Illimitato';

  @override
  String showResults(int count) {
    return 'Mostra $count risultati';
  }

  @override
  String get noFilterResults => 'Nessun armadietto corrisponde ai tuoi filtri';

  @override
  String get lockerBayDetail => 'Dettagli punto';

  @override
  String get lockerBayAddress => 'Indirizzo';

  @override
  String get lockerBayCompany => 'Azienda';

  @override
  String get lockerBayLockers => 'Armadietti';

  @override
  String lockerNumber(int number) {
    return 'Armadietto n°$number';
  }

  @override
  String get dimensions => 'Dimensioni';

  @override
  String get lockerType => 'Tipo';

  @override
  String lockerSize(int width, int height, int depth) {
    return '$width × $height × $depth cm';
  }

  @override
  String get lockerAvailable => 'Disponibile';

  @override
  String get lockerReserved => 'Prenotato';

  @override
  String get lockerOccupied => 'Occupato';

  @override
  String get lockerOutOfOrder => 'Fuori servizio';

  @override
  String get lockerOffline => 'Offline';

  @override
  String get reserveLocker => 'Prenota';

  @override
  String pricePerDay(String price) {
    return '$price €';
  }

  @override
  String get mapLockerBays => 'Punti armadietti';

  @override
  String mapLockerBayCount(int count) {
    return '$count armadietti';
  }

  @override
  String get mapSeeDetails => 'Vedi dettagli';

  @override
  String get mapAroundMe => 'Intorno a me';

  @override
  String get mapNearest => 'Più vicino';

  @override
  String mapDistance(String distance) {
    return '$distance';
  }

  @override
  String get mapLocationDenied => 'L\'accesso alla posizione è stato negato';

  @override
  String get mapLocationDeniedForever =>
      'L\'accesso alla posizione è disabilitato. Abilitalo nelle impostazioni.';

  @override
  String get mapLocationServiceDisabled =>
      'Il servizio di localizzazione è disabilitato';

  @override
  String get mapOpenSettings => 'Apri impostazioni';

  @override
  String get mapMyPosition => 'La mia posizione';

  @override
  String get reservationFlowTitle => 'Prenota un armadietto';

  @override
  String get reservationSelectDate => 'Pianifica la prenotazione';

  @override
  String get reservationStartDate => 'Data';

  @override
  String get reservationStartTime => 'Ora di inizio';

  @override
  String get reservationDurationLabel => 'Durata';

  @override
  String reservationDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String reservationDurationHoursMinutes(int hours, String minutes) {
    return '${hours}h$minutes';
  }

  @override
  String get reservationNext => 'Continua';

  @override
  String get reservationSummaryTitle => 'Riepilogo';

  @override
  String get reservationLocker => 'Armadietto';

  @override
  String get reservationLocation => 'Posizione';

  @override
  String get reservationPeriod => 'Periodo';

  @override
  String get reservationTotalPrice => 'Totale';

  @override
  String reservationPrice(String price) {
    return '$price €';
  }

  @override
  String get reservationConfirm => 'Conferma prenotazione';

  @override
  String get reservationSuccessTitle => 'Prenotazione confermata!';

  @override
  String get reservationSuccessSubtitle =>
      'Il tuo armadietto è prenotato. Mostra questo codice all\'arrivo.';

  @override
  String get reservationCode => 'Codice di prenotazione';

  @override
  String get reservationBackToHome => 'Torna alla home';

  @override
  String get reservationViewAll => 'Vedi le mie prenotazioni';

  @override
  String get reservationSelectDateHint => 'Tocca per selezionare';

  @override
  String get reservationDateFrom => 'Inizio';

  @override
  String get reservationDateTo => 'Fine';

  @override
  String reservationMaxDuration(int minutes) {
    return 'Durata max: $minutes min';
  }

  @override
  String get reservationErrorGeneric => 'Si è verificato un errore. Riprova.';

  @override
  String get reservationsEmpty => 'Nessuna prenotazione';

  @override
  String get reservationsEmptySubtitle =>
      'Non hai ancora prenotazioni. Prenota il tuo primo armadietto!';

  @override
  String get reservationStatusPending => 'In attesa';

  @override
  String get reservationStatusConfirmed => 'Confermata';

  @override
  String get reservationStatusActive => 'Attiva';

  @override
  String get reservationStatusCompleted => 'Completata';

  @override
  String get reservationStatusCancelled => 'Annullata';

  @override
  String get reservationStatusExpired => 'Scaduta';

  @override
  String get reservationsUpcoming => 'Prossime';

  @override
  String get reservationsPast => 'Passate';

  @override
  String get reservationCancelTitle => 'Annulla prenotazione';

  @override
  String get reservationCancelMessage =>
      'Sei sicuro di voler annullare questa prenotazione?';

  @override
  String get reservationCancelConfirm => 'Conferma annullamento';

  @override
  String get reservationDetailTitle => 'Dettaglio prenotazione';

  @override
  String get reservationDetailLocker => 'Armadietto';

  @override
  String get reservationDetailLockerBay => 'Punto di ritiro';

  @override
  String get reservationDetailPeriod => 'Periodo';

  @override
  String get reservationDetailDuration => 'Durata';

  @override
  String get reservationDetailPrice => 'Prezzo';

  @override
  String get reservationDetailSpecifications => 'Specifiche';

  @override
  String reservationDetailDimensions(int width, int height, int depth) {
    return '$width × $height × $depth cm';
  }

  @override
  String get reservationDetailMaterial => 'Materiale';

  @override
  String get reservationDetailCancelReservation => 'Annulla prenotazione';

  @override
  String get profilePersonalInfo => 'Informazioni personali';

  @override
  String get profilePreferences => 'Preferenze';

  @override
  String get profileAbout => 'Informazioni';

  @override
  String profileVersion(String version) {
    return 'Versione $version';
  }

  @override
  String profileMemberSince(String date) {
    return 'Membro dal $date';
  }

  @override
  String get profileTerms => 'Condizioni d\'uso';

  @override
  String get profilePrivacy => 'Informativa sulla privacy';

  @override
  String get profileHelp => 'Aiuto e supporto';

  @override
  String get profileLogoutConfirm => 'Sei sicuro di voler uscire?';

  @override
  String get profileEdit => 'Modifica profilo';

  @override
  String get profileChangePassword => 'Cambia password';

  @override
  String get profileCurrentPassword => 'Password attuale';

  @override
  String get profileNewPassword => 'Nuova password';

  @override
  String get profileEditSuccess => 'Profilo aggiornato con successo';

  @override
  String get profileEditError => 'Errore durante l\'aggiornamento del profilo';

  @override
  String get notifications => 'Notifiche';

  @override
  String get paymentTitle => 'Pagamento';

  @override
  String get paymentSubtitle => 'Completa la tua prenotazione in sicurezza';

  @override
  String get paymentCardDetails => 'Pagamento con carta';

  @override
  String get paymentStripeInfo =>
      'Verrai reindirizzato a un modulo di pagamento sicuro Stripe.';

  @override
  String paymentPay(String price) {
    return 'Paga $price €';
  }

  @override
  String get paymentProceed => 'Procedi al pagamento';

  @override
  String get paymentSecure => 'Pagamento sicuro';

  @override
  String get paymentError => 'Pagamento non riuscito. Riprova.';

  @override
  String get errorNetwork =>
      'Impossibile connettersi. Controlla la tua connessione internet e riprova.';

  @override
  String get errorServer =>
      'Si è verificato un errore del server. Riprova più tardi.';

  @override
  String get errorUnknown => 'Si è verificato un errore imprevisto. Riprova.';

  @override
  String get nearbyBays => 'Autour de vous';

  @override
  String get allBays => 'Tous les points';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get nearbyDescription =>
      'Les points de casiers les plus proches de vous';

  @override
  String totalLockers(int count) {
    return '$count casiers au total';
  }

  @override
  String cities(int count) {
    return '$count villes';
  }

  @override
  String fromPrice(String price) {
    return 'dès $price €';
  }

  @override
  String filteredResults(int count) {
    return '$count armadietti trovati';
  }

  @override
  String get clearFilters => 'Cancella filtri';

  @override
  String get openLocker => 'Apri armadietto';

  @override
  String get openLockerOpening => 'Apertura dell\'armadietto...';

  @override
  String get openLockerSuccess => 'Armadietto aperto!';

  @override
  String get openLockerSuccessSubtitle =>
      'Il tuo armadietto è ora sbloccato. Puoi accedervi.';

  @override
  String get openLockerError => 'Impossibile aprire l\'armadietto. Riprova.';

  @override
  String get openLockerDone => 'Fatto';

  @override
  String get profilePasswordChangeSuccess => 'Password modificata con successo';

  @override
  String get profileCurrentPasswordIncorrect =>
      'La password attuale non è corretta';

  @override
  String get profileNewPasswordInvalid => 'La nuova password non è valida';

  @override
  String get profilePasswordChangeError =>
      'Impossibile modificare la password. Riprova.';

  @override
  String get profileNewPasswordTooShort =>
      'La password deve contenere almeno 8 caratteri';

  @override
  String get profileNewPasswordSameAsCurrent =>
      'La nuova password deve essere diversa da quella attuale';

  @override
  String get bookingSlotUnavailable =>
      'Questa fascia oraria non è più disponibile per questo armadietto. Scegline un\'altra.';

  @override
  String get bookingInvalidDuration =>
      'La durata selezionata non è valida per questo armadietto.';

  @override
  String get bookingNetworkError =>
      'Connessione non riuscita. Controlla la rete e riprova.';

  @override
  String get authTooManyAttempts => 'Troppi tentativi. Riprova tra un minuto.';

  @override
  String get reservationRefundLabel => 'Rimborso';

  @override
  String get reservationRefundSucceeded => 'Completato';

  @override
  String get reservationRefundPending => 'In corso';

  @override
  String get reservationRefundFailed => 'Non riuscito';

  @override
  String get reservationRefundNotApplicable => 'Non applicabile';

  @override
  String reservationCancelledOn(String date) {
    return 'Annullata il $date';
  }
}
