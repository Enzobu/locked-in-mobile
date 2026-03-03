// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Locked In';

  @override
  String get home => 'Accueil';

  @override
  String get map => 'Carte';

  @override
  String get reservations => 'Réservations';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Réglages';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get lightMode => 'Mode clair';

  @override
  String get systemMode => 'Système';

  @override
  String get login => 'Connexion';

  @override
  String get register => 'Inscription';

  @override
  String get logout => 'Déconnexion';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get loginSubtitle => 'Connectez-vous pour accéder à vos casiers';

  @override
  String get emailRequired => 'L\'email est requis';

  @override
  String get emailInvalid => 'L\'email n\'est pas valide';

  @override
  String get passwordRequired => 'Le mot de passe est requis';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get loginTitle => 'Réservez vos casiers en toute simplicité';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get noAccount => 'Pas encore de compte ?';

  @override
  String get search => 'Rechercher';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get retry => 'Réessayer';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String get italian => 'Italiano';

  @override
  String get registerTitle => 'Créez votre compte';

  @override
  String get registerSubtitle => 'Inscrivez-vous pour réserver vos casiers';

  @override
  String get firstname => 'Prénom';

  @override
  String get lastname => 'Nom';

  @override
  String get phone => 'Téléphone';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get firstnameRequired => 'Le prénom est requis';

  @override
  String get lastnameRequired => 'Le nom est requis';

  @override
  String get phoneRequired => 'Le téléphone est requis';

  @override
  String get phoneInvalid => 'Le numéro de téléphone n\'est pas valide';

  @override
  String get confirmPasswordRequired =>
      'La confirmation du mot de passe est requise';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ?';

  @override
  String get registerSuccess => 'Inscription réussie ! Connectez-vous.';

  @override
  String get invalidCredentials => 'Email ou mot de passe incorrect';

  @override
  String get homeGreeting => 'Bienvenue';

  @override
  String get homeTitle => 'Trouvez votre casier';

  @override
  String availableLockers(int available, int total) {
    return '$available/$total disponibles';
  }

  @override
  String get rechargeable => 'Recharge';

  @override
  String get noLockersTitle => 'Aucun casier disponible';

  @override
  String get noLockersSubtitle =>
      'Aucun point de casiers n\'est disponible pour le moment. Revenez plus tard.';

  @override
  String get lockerBays => 'Points de casiers';

  @override
  String get searchLockerBays => 'Rechercher un point de casiers...';

  @override
  String noSearchResults(String query) {
    return 'Aucun résultat pour \"$query\". Essayez avec un autre terme.';
  }

  @override
  String get filters => 'Filtres';

  @override
  String get resetFilters => 'Réinitialiser';

  @override
  String get filterPrice => 'Prix';

  @override
  String get filterSize => 'Taille';

  @override
  String get filterMaterial => 'Matériau';

  @override
  String get filterRechargeable => 'Rechargeable uniquement';

  @override
  String get filterSizeSmall => 'S';

  @override
  String get filterSizeMedium => 'M';

  @override
  String get filterSizeLarge => 'L';

  @override
  String showResults(int count) {
    return 'Voir $count résultats';
  }

  @override
  String get noFilterResults => 'Aucun casier ne correspond à vos filtres';

  @override
  String get lockerBayDetail => 'Détail du point';

  @override
  String get lockerBayAddress => 'Adresse';

  @override
  String get lockerBayCompany => 'Entreprise';

  @override
  String get lockerBayLockers => 'Casiers';

  @override
  String lockerNumber(int number) {
    return 'Casier n°$number';
  }

  @override
  String lockerSize(int width, int height, int depth) {
    return '$width × $height × $depth cm';
  }

  @override
  String get lockerAvailable => 'Disponible';

  @override
  String get lockerReserved => 'Réservé';

  @override
  String get lockerOccupied => 'Occupé';

  @override
  String get lockerOutOfOrder => 'Hors service';

  @override
  String get lockerOffline => 'Hors ligne';

  @override
  String get reserveLocker => 'Réserver';

  @override
  String pricePerDay(String price) {
    return '$price €';
  }

  @override
  String get mapLockerBays => 'Points de casiers';

  @override
  String mapLockerBayCount(int count) {
    return '$count casiers';
  }

  @override
  String get mapSeeDetails => 'Voir les détails';

  @override
  String get mapAroundMe => 'Autour de moi';

  @override
  String get mapSortByProximity => 'Tri par proximité';

  @override
  String get mapSortDefault => 'Tri par défaut';

  @override
  String mapDistance(String distance) {
    return '$distance';
  }

  @override
  String get mapLocationDenied => 'L\'accès à la localisation a été refusé';

  @override
  String get mapLocationDeniedForever =>
      'L\'accès à la localisation est désactivé. Activez-le dans les réglages.';

  @override
  String get mapLocationServiceDisabled =>
      'Le service de localisation est désactivé';

  @override
  String get mapOpenSettings => 'Ouvrir les réglages';

  @override
  String get mapMyPosition => 'Ma position';

  @override
  String get reservationFlowTitle => 'Réserver un casier';

  @override
  String get reservationSelectDate => 'Sélectionnez vos dates';

  @override
  String get reservationStartDate => 'Date de début';

  @override
  String get reservationEndDate => 'Date de fin';

  @override
  String reservationDuration(int days) {
    return '$days jour(s)';
  }

  @override
  String get reservationNext => 'Continuer';

  @override
  String get reservationSummaryTitle => 'Récapitulatif';

  @override
  String get reservationLocker => 'Casier';

  @override
  String get reservationLocation => 'Emplacement';

  @override
  String get reservationPeriod => 'Période';

  @override
  String get reservationTotalPrice => 'Total';

  @override
  String reservationPrice(String price) {
    return '$price €';
  }

  @override
  String get reservationConfirm => 'Confirmer la réservation';

  @override
  String get reservationSuccessTitle => 'Réservation confirmée !';

  @override
  String get reservationSuccessSubtitle =>
      'Votre casier est réservé. Présentez ce code à l\'arrivée.';

  @override
  String get reservationCode => 'Code de réservation';

  @override
  String get reservationBackToHome => 'Retour à l\'accueil';

  @override
  String get reservationViewAll => 'Voir mes réservations';

  @override
  String get reservationSelectDateHint => 'Touchez pour sélectionner';

  @override
  String get reservationDateFrom => 'Du';

  @override
  String get reservationDateTo => 'Au';

  @override
  String get reservationErrorGeneric =>
      'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get reservationsEmpty => 'Aucune réservation';

  @override
  String get reservationsEmptySubtitle =>
      'Vous n\'avez pas encore de réservation. Réservez votre premier casier !';

  @override
  String get reservationStatusPending => 'En attente';

  @override
  String get reservationStatusConfirmed => 'Confirmée';

  @override
  String get reservationStatusActive => 'Active';

  @override
  String get reservationStatusCompleted => 'Terminée';

  @override
  String get reservationStatusCancelled => 'Annulée';

  @override
  String get reservationStatusExpired => 'Expirée';

  @override
  String get reservationsUpcoming => 'À venir';

  @override
  String get reservationsPast => 'Passées';
}
