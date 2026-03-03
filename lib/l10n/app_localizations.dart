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
