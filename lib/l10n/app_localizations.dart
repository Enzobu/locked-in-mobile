import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('it'),
  ];

  /// Nom de l'application
  ///
  /// In fr, this message translates to:
  /// **'Locked In'**
  String get appName;

  /// Label navigation accueil
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get home;

  /// Label navigation carte
  ///
  /// In fr, this message translates to:
  /// **'Carte'**
  String get map;

  /// Label navigation réservations
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get reservations;

  /// Label navigation profil
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profile;

  /// Label réglages
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get settings;

  /// Label choix de langue
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// Label choix de thème
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get theme;

  /// Label toggle dark mode
  ///
  /// In fr, this message translates to:
  /// **'Mode sombre'**
  String get darkMode;

  /// Label mode clair
  ///
  /// In fr, this message translates to:
  /// **'Mode clair'**
  String get lightMode;

  /// Label mode système
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get systemMode;

  /// Bouton connexion
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get login;

  /// Bouton inscription
  ///
  /// In fr, this message translates to:
  /// **'Inscription'**
  String get register;

  /// Bouton déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get logout;

  /// Label champ email
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email;

  /// Label champ mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// Sous-titre page login
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour accéder à vos casiers'**
  String get loginSubtitle;

  /// Erreur email vide
  ///
  /// In fr, this message translates to:
  /// **'L\'email est requis'**
  String get emailRequired;

  /// Erreur email invalide
  ///
  /// In fr, this message translates to:
  /// **'L\'email n\'est pas valide'**
  String get emailInvalid;

  /// Erreur mot de passe vide
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe est requis'**
  String get passwordRequired;

  /// Erreur mot de passe trop court
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 6 caractères'**
  String get passwordTooShort;

  /// Titre page login
  ///
  /// In fr, this message translates to:
  /// **'Réservez vos casiers en toute simplicité'**
  String get loginTitle;

  /// Lien mot de passe oublié
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPassword;

  /// Texte avant lien inscription
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get noAccount;

  /// Placeholder recherche
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get search;

  /// Bouton annuler
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// Bouton confirmer
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// Bouton enregistrer
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// Bouton supprimer
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// Bouton réessayer
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// Texte de chargement
  ///
  /// In fr, this message translates to:
  /// **'Chargement...'**
  String get loading;

  /// Titre erreur
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get error;

  /// Message aucun résultat
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get noResults;

  /// Nom de la langue française
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get french;

  /// Nom de la langue anglaise
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get english;

  /// Nom de la langue allemande
  ///
  /// In fr, this message translates to:
  /// **'Deutsch'**
  String get german;

  /// Nom de la langue italienne
  ///
  /// In fr, this message translates to:
  /// **'Italiano'**
  String get italian;

  /// Titre page inscription
  ///
  /// In fr, this message translates to:
  /// **'Créez votre compte'**
  String get registerTitle;

  /// Sous-titre page inscription
  ///
  /// In fr, this message translates to:
  /// **'Inscrivez-vous pour réserver vos casiers'**
  String get registerSubtitle;

  /// Label champ prénom
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get firstname;

  /// Label champ nom
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get lastname;

  /// Label champ téléphone
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get phone;

  /// Label champ confirmation mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get confirmPassword;

  /// Erreur prénom vide
  ///
  /// In fr, this message translates to:
  /// **'Le prénom est requis'**
  String get firstnameRequired;

  /// Erreur nom vide
  ///
  /// In fr, this message translates to:
  /// **'Le nom est requis'**
  String get lastnameRequired;

  /// Erreur téléphone vide
  ///
  /// In fr, this message translates to:
  /// **'Le téléphone est requis'**
  String get phoneRequired;

  /// Erreur téléphone invalide
  ///
  /// In fr, this message translates to:
  /// **'Le numéro de téléphone n\'est pas valide'**
  String get phoneInvalid;

  /// Erreur confirmation vide
  ///
  /// In fr, this message translates to:
  /// **'La confirmation du mot de passe est requise'**
  String get confirmPasswordRequired;

  /// Erreur mots de passe différents
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get passwordsDoNotMatch;

  /// Texte avant lien connexion
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ?'**
  String get alreadyHaveAccount;

  /// Message succès inscription
  ///
  /// In fr, this message translates to:
  /// **'Inscription réussie ! Connectez-vous.'**
  String get registerSuccess;

  /// Erreur identifiants incorrects
  ///
  /// In fr, this message translates to:
  /// **'Email ou mot de passe incorrect'**
  String get invalidCredentials;

  /// Salutation page accueil
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue'**
  String get homeGreeting;

  /// Titre principal page accueil
  ///
  /// In fr, this message translates to:
  /// **'Trouvez votre casier'**
  String get homeTitle;

  /// Nombre de casiers disponibles sur le total
  ///
  /// In fr, this message translates to:
  /// **'{available}/{total} disponibles'**
  String availableLockers(int available, int total);

  /// Label casier rechargeable
  ///
  /// In fr, this message translates to:
  /// **'Recharge'**
  String get rechargeable;

  /// Titre état vide casiers
  ///
  /// In fr, this message translates to:
  /// **'Aucun casier disponible'**
  String get noLockersTitle;

  /// Sous-titre état vide casiers
  ///
  /// In fr, this message translates to:
  /// **'Aucun point de casiers n\'est disponible pour le moment. Revenez plus tard.'**
  String get noLockersSubtitle;

  /// Label liste des points de casiers
  ///
  /// In fr, this message translates to:
  /// **'Points de casiers'**
  String get lockerBays;

  /// Placeholder barre de recherche casiers
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un point de casiers...'**
  String get searchLockerBays;

  /// Message aucun résultat de recherche
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat pour \"{query}\". Essayez avec un autre terme.'**
  String noSearchResults(String query);

  /// Titre section filtres
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get filters;

  /// Bouton réinitialiser les filtres
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get resetFilters;

  /// Label filtre prix
  ///
  /// In fr, this message translates to:
  /// **'Prix'**
  String get filterPrice;

  /// Label filtre taille
  ///
  /// In fr, this message translates to:
  /// **'Taille'**
  String get filterSize;

  /// Label filtre matériau
  ///
  /// In fr, this message translates to:
  /// **'Matériau'**
  String get filterMaterial;

  /// Label filtre rechargeable
  ///
  /// In fr, this message translates to:
  /// **'Rechargeable uniquement'**
  String get filterRechargeable;

  /// Label taille petit
  ///
  /// In fr, this message translates to:
  /// **'S'**
  String get filterSizeSmall;

  /// Label taille moyen
  ///
  /// In fr, this message translates to:
  /// **'M'**
  String get filterSizeMedium;

  /// Label taille grand
  ///
  /// In fr, this message translates to:
  /// **'L'**
  String get filterSizeLarge;

  /// Bouton voir résultats filtrés
  ///
  /// In fr, this message translates to:
  /// **'Voir {count} résultats'**
  String showResults(int count);

  /// Message aucun résultat avec filtres
  ///
  /// In fr, this message translates to:
  /// **'Aucun casier ne correspond à vos filtres'**
  String get noFilterResults;

  /// Titre page détail d'un locker bay
  ///
  /// In fr, this message translates to:
  /// **'Détail du point'**
  String get lockerBayDetail;

  /// Label section adresse
  ///
  /// In fr, this message translates to:
  /// **'Adresse'**
  String get lockerBayAddress;

  /// Label section entreprise
  ///
  /// In fr, this message translates to:
  /// **'Entreprise'**
  String get lockerBayCompany;

  /// Label section liste des casiers
  ///
  /// In fr, this message translates to:
  /// **'Casiers'**
  String get lockerBayLockers;

  /// Numéro du casier
  ///
  /// In fr, this message translates to:
  /// **'Casier n°{number}'**
  String lockerNumber(int number);

  /// Dimensions du casier
  ///
  /// In fr, this message translates to:
  /// **'{width} × {height} × {depth} cm'**
  String lockerSize(int width, int height, int depth);

  /// Statut casier disponible
  ///
  /// In fr, this message translates to:
  /// **'Disponible'**
  String get lockerAvailable;

  /// Statut casier réservé
  ///
  /// In fr, this message translates to:
  /// **'Réservé'**
  String get lockerReserved;

  /// Statut casier occupé
  ///
  /// In fr, this message translates to:
  /// **'Occupé'**
  String get lockerOccupied;

  /// Statut casier hors service
  ///
  /// In fr, this message translates to:
  /// **'Hors service'**
  String get lockerOutOfOrder;

  /// Statut casier hors ligne
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne'**
  String get lockerOffline;

  /// Bouton réserver un casier
  ///
  /// In fr, this message translates to:
  /// **'Réserver'**
  String get reserveLocker;

  /// Prix du casier
  ///
  /// In fr, this message translates to:
  /// **'{price} €'**
  String pricePerDay(String price);

  /// Titre des markers sur la carte
  ///
  /// In fr, this message translates to:
  /// **'Points de casiers'**
  String get mapLockerBays;

  /// Nombre de casiers dans un point
  ///
  /// In fr, this message translates to:
  /// **'{count} casiers'**
  String mapLockerBayCount(int count);

  /// Bouton voir détails sur la carte
  ///
  /// In fr, this message translates to:
  /// **'Voir les détails'**
  String get mapSeeDetails;

  /// Bouton géolocalisation autour de moi
  ///
  /// In fr, this message translates to:
  /// **'Autour de moi'**
  String get mapAroundMe;

  /// Label tri par proximité
  ///
  /// In fr, this message translates to:
  /// **'Tri par proximité'**
  String get mapSortByProximity;

  /// Label tri par défaut
  ///
  /// In fr, this message translates to:
  /// **'Tri par défaut'**
  String get mapSortDefault;

  /// Distance affichée sur les cards
  ///
  /// In fr, this message translates to:
  /// **'{distance}'**
  String mapDistance(String distance);

  /// Message permission refusée
  ///
  /// In fr, this message translates to:
  /// **'L\'accès à la localisation a été refusé'**
  String get mapLocationDenied;

  /// Message permission refusée définitivement
  ///
  /// In fr, this message translates to:
  /// **'L\'accès à la localisation est désactivé. Activez-le dans les réglages.'**
  String get mapLocationDeniedForever;

  /// Message service désactivé
  ///
  /// In fr, this message translates to:
  /// **'Le service de localisation est désactivé'**
  String get mapLocationServiceDisabled;

  /// Bouton ouvrir les réglages
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir les réglages'**
  String get mapOpenSettings;

  /// Label ma position
  ///
  /// In fr, this message translates to:
  /// **'Ma position'**
  String get mapMyPosition;

  /// Titre du flow de réservation
  ///
  /// In fr, this message translates to:
  /// **'Réserver un casier'**
  String get reservationFlowTitle;

  /// Titre étape sélection date
  ///
  /// In fr, this message translates to:
  /// **'Planifiez votre réservation'**
  String get reservationSelectDate;

  /// Label date
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get reservationStartDate;

  /// Label heure de début
  ///
  /// In fr, this message translates to:
  /// **'Heure de début'**
  String get reservationStartTime;

  /// Label durée
  ///
  /// In fr, this message translates to:
  /// **'Durée'**
  String get reservationDurationLabel;

  /// Durée en minutes
  ///
  /// In fr, this message translates to:
  /// **'{minutes} min'**
  String reservationDurationMinutes(int minutes);

  /// Durée en heures et minutes
  ///
  /// In fr, this message translates to:
  /// **'{hours}h{minutes}'**
  String reservationDurationHoursMinutes(int hours, String minutes);

  /// Bouton étape suivante
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get reservationNext;

  /// Titre étape récapitulatif
  ///
  /// In fr, this message translates to:
  /// **'Récapitulatif'**
  String get reservationSummaryTitle;

  /// Label section casier
  ///
  /// In fr, this message translates to:
  /// **'Casier'**
  String get reservationLocker;

  /// Label section emplacement
  ///
  /// In fr, this message translates to:
  /// **'Emplacement'**
  String get reservationLocation;

  /// Label section période
  ///
  /// In fr, this message translates to:
  /// **'Période'**
  String get reservationPeriod;

  /// Label prix total
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get reservationTotalPrice;

  /// Prix formaté
  ///
  /// In fr, this message translates to:
  /// **'{price} €'**
  String reservationPrice(String price);

  /// Bouton confirmer réservation
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la réservation'**
  String get reservationConfirm;

  /// Titre succès réservation
  ///
  /// In fr, this message translates to:
  /// **'Réservation confirmée !'**
  String get reservationSuccessTitle;

  /// Sous-titre succès réservation
  ///
  /// In fr, this message translates to:
  /// **'Votre casier est réservé. Présentez ce code à l\'arrivée.'**
  String get reservationSuccessSubtitle;

  /// Label code de réservation
  ///
  /// In fr, this message translates to:
  /// **'Code de réservation'**
  String get reservationCode;

  /// Bouton retour accueil
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get reservationBackToHome;

  /// Bouton voir réservations
  ///
  /// In fr, this message translates to:
  /// **'Voir mes réservations'**
  String get reservationViewAll;

  /// Hint sélection date
  ///
  /// In fr, this message translates to:
  /// **'Touchez pour sélectionner'**
  String get reservationSelectDateHint;

  /// Label début
  ///
  /// In fr, this message translates to:
  /// **'Début'**
  String get reservationDateFrom;

  /// Label fin
  ///
  /// In fr, this message translates to:
  /// **'Fin'**
  String get reservationDateTo;

  /// Indication durée max
  ///
  /// In fr, this message translates to:
  /// **'Durée max : {minutes} min'**
  String reservationMaxDuration(int minutes);

  /// Message erreur générique réservation
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue. Veuillez réessayer.'**
  String get reservationErrorGeneric;

  /// Titre état vide réservations
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation'**
  String get reservationsEmpty;

  /// Sous-titre état vide réservations
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas encore de réservation. Réservez votre premier casier !'**
  String get reservationsEmptySubtitle;

  /// Statut réservation en attente
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get reservationStatusPending;

  /// Statut réservation confirmée
  ///
  /// In fr, this message translates to:
  /// **'Confirmée'**
  String get reservationStatusConfirmed;

  /// Statut réservation active
  ///
  /// In fr, this message translates to:
  /// **'Active'**
  String get reservationStatusActive;

  /// Statut réservation terminée
  ///
  /// In fr, this message translates to:
  /// **'Terminée'**
  String get reservationStatusCompleted;

  /// Statut réservation annulée
  ///
  /// In fr, this message translates to:
  /// **'Annulée'**
  String get reservationStatusCancelled;

  /// Statut réservation expirée
  ///
  /// In fr, this message translates to:
  /// **'Expirée'**
  String get reservationStatusExpired;

  /// Section réservations à venir
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get reservationsUpcoming;

  /// Section réservations passées
  ///
  /// In fr, this message translates to:
  /// **'Passées'**
  String get reservationsPast;

  /// Titre dialogue annulation réservation
  ///
  /// In fr, this message translates to:
  /// **'Annuler la réservation'**
  String get reservationCancelTitle;

  /// Message dialogue annulation réservation
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir annuler cette réservation ?'**
  String get reservationCancelMessage;

  /// Bouton confirmer annulation
  ///
  /// In fr, this message translates to:
  /// **'Confirmer l\'annulation'**
  String get reservationCancelConfirm;

  /// Titre écran détail réservation
  ///
  /// In fr, this message translates to:
  /// **'Détail de la réservation'**
  String get reservationDetailTitle;

  /// Section casier détail réservation
  ///
  /// In fr, this message translates to:
  /// **'Casier'**
  String get reservationDetailLocker;

  /// Section locker bay détail réservation
  ///
  /// In fr, this message translates to:
  /// **'Point de retrait'**
  String get reservationDetailLockerBay;

  /// Section période détail réservation
  ///
  /// In fr, this message translates to:
  /// **'Période'**
  String get reservationDetailPeriod;

  /// Label durée détail réservation
  ///
  /// In fr, this message translates to:
  /// **'Durée'**
  String get reservationDetailDuration;

  /// Section prix détail réservation
  ///
  /// In fr, this message translates to:
  /// **'Prix'**
  String get reservationDetailPrice;

  /// Section spécifications détail réservation
  ///
  /// In fr, this message translates to:
  /// **'Spécifications'**
  String get reservationDetailSpecifications;

  /// Dimensions du casier
  ///
  /// In fr, this message translates to:
  /// **'{width} × {height} × {depth} cm'**
  String reservationDetailDimensions(int width, int height, int depth);

  /// Label matériau
  ///
  /// In fr, this message translates to:
  /// **'Matériau'**
  String get reservationDetailMaterial;

  /// Bouton annuler réservation détail
  ///
  /// In fr, this message translates to:
  /// **'Annuler la réservation'**
  String get reservationDetailCancelReservation;

  /// Section infos personnelles profil
  ///
  /// In fr, this message translates to:
  /// **'Informations personnelles'**
  String get profilePersonalInfo;

  /// Section préférences profil
  ///
  /// In fr, this message translates to:
  /// **'Préférences'**
  String get profilePreferences;

  /// Section à propos profil
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get profileAbout;

  /// Version de l'application
  ///
  /// In fr, this message translates to:
  /// **'Version {version}'**
  String profileVersion(String version);

  /// Date d'inscription
  ///
  /// In fr, this message translates to:
  /// **'Membre depuis {date}'**
  String profileMemberSince(String date);

  /// Lien conditions d'utilisation
  ///
  /// In fr, this message translates to:
  /// **'Conditions d\'utilisation'**
  String get profileTerms;

  /// Lien politique de confidentialité
  ///
  /// In fr, this message translates to:
  /// **'Politique de confidentialité'**
  String get profilePrivacy;

  /// Lien aide et support
  ///
  /// In fr, this message translates to:
  /// **'Aide et support'**
  String get profileHelp;

  /// Message confirmation déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir vous déconnecter ?'**
  String get profileLogoutConfirm;

  /// Titre écran modification profil
  ///
  /// In fr, this message translates to:
  /// **'Modifier le profil'**
  String get profileEdit;

  /// Message succès modification profil
  ///
  /// In fr, this message translates to:
  /// **'Profil mis à jour avec succès'**
  String get profileEditSuccess;

  /// Message erreur modification profil
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la mise à jour du profil'**
  String get profileEditError;

  /// Label toggle notifications
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Titre étape paiement
  ///
  /// In fr, this message translates to:
  /// **'Paiement'**
  String get paymentTitle;

  /// Sous-titre étape paiement
  ///
  /// In fr, this message translates to:
  /// **'Finalisez votre réservation en toute sécurité'**
  String get paymentSubtitle;

  /// Section détails carte
  ///
  /// In fr, this message translates to:
  /// **'Paiement par carte'**
  String get paymentCardDetails;

  /// Info redirection Stripe
  ///
  /// In fr, this message translates to:
  /// **'Vous serez redirigé vers un formulaire de paiement sécurisé Stripe.'**
  String get paymentStripeInfo;

  /// Bouton payer avec montant
  ///
  /// In fr, this message translates to:
  /// **'Payer {price} €'**
  String paymentPay(String price);

  /// Bouton aller au paiement
  ///
  /// In fr, this message translates to:
  /// **'Procéder au paiement'**
  String get paymentProceed;

  /// Label paiement sécurisé
  ///
  /// In fr, this message translates to:
  /// **'Paiement sécurisé'**
  String get paymentSecure;

  /// Message erreur paiement
  ///
  /// In fr, this message translates to:
  /// **'Le paiement a échoué. Veuillez réessayer.'**
  String get paymentError;

  /// Message erreur réseau
  ///
  /// In fr, this message translates to:
  /// **'Impossible de se connecter. Vérifiez votre connexion internet et réessayez.'**
  String get errorNetwork;

  /// Message erreur serveur
  ///
  /// In fr, this message translates to:
  /// **'Une erreur serveur est survenue. Veuillez réessayer plus tard.'**
  String get errorServer;

  /// Message erreur inconnue
  ///
  /// In fr, this message translates to:
  /// **'Une erreur inattendue est survenue. Veuillez réessayer.'**
  String get errorUnknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
