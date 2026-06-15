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
  String get notRechargeable => 'Non rechargeable';

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
  String get filterDistance => 'Distance';

  @override
  String filterDistanceMax(String distance) {
    return 'Max. $distance km';
  }

  @override
  String get filterDistanceNoLimit => 'Illimité';

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
  String get dimensions => 'Dimensions';

  @override
  String get lockerType => 'Type';

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
  String get mapNearest => 'Le plus proche';

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
  String get reservationSelectDate => 'Planifiez votre réservation';

  @override
  String get reservationStartDate => 'Date';

  @override
  String get reservationStartTime => 'Heure de début';

  @override
  String get reservationDurationLabel => 'Durée';

  @override
  String reservationDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String reservationDurationHoursMinutes(int hours, String minutes) {
    return '${hours}h$minutes';
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
  String get reservationDateFrom => 'Début';

  @override
  String get reservationDateTo => 'Fin';

  @override
  String reservationMaxDuration(int minutes) {
    return 'Durée max : $minutes min';
  }

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

  @override
  String get reservationCancelTitle => 'Annuler la réservation';

  @override
  String get reservationCancelMessage =>
      'Êtes-vous sûr de vouloir annuler cette réservation ?';

  @override
  String get reservationCancelConfirm => 'Confirmer l\'annulation';

  @override
  String get reservationDetailTitle => 'Détail de la réservation';

  @override
  String get reservationDetailLocker => 'Casier';

  @override
  String get reservationDetailLockerBay => 'Point de retrait';

  @override
  String get reservationDetailPeriod => 'Période';

  @override
  String get reservationDetailDuration => 'Durée';

  @override
  String get reservationDetailPrice => 'Prix';

  @override
  String get reservationDetailSpecifications => 'Spécifications';

  @override
  String reservationDetailDimensions(int width, int height, int depth) {
    return '$width × $height × $depth cm';
  }

  @override
  String get reservationDetailMaterial => 'Matériau';

  @override
  String get reservationDetailCancelReservation => 'Annuler la réservation';

  @override
  String get profilePersonalInfo => 'Informations personnelles';

  @override
  String get profilePreferences => 'Préférences';

  @override
  String get profileAbout => 'À propos';

  @override
  String profileVersion(String version) {
    return 'Version $version';
  }

  @override
  String profileMemberSince(String date) {
    return 'Membre depuis $date';
  }

  @override
  String get profileTerms => 'Conditions d\'utilisation';

  @override
  String get profilePrivacy => 'Politique de confidentialité';

  @override
  String get profileHelp => 'Aide et support';

  @override
  String get profileLogoutConfirm =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get profileEdit => 'Modifier le profil';

  @override
  String get profileChangePassword => 'Modifier le mot de passe';

  @override
  String get profileCurrentPassword => 'Mot de passe actuel';

  @override
  String get profileNewPassword => 'Nouveau mot de passe';

  @override
  String get profileEditSuccess => 'Profil mis à jour avec succès';

  @override
  String get profileEditError => 'Erreur lors de la mise à jour du profil';

  @override
  String get notifications => 'Notifications';

  @override
  String get paymentTitle => 'Paiement';

  @override
  String get paymentSubtitle => 'Finalisez votre réservation en toute sécurité';

  @override
  String get paymentCardDetails => 'Paiement par carte';

  @override
  String get paymentStripeInfo =>
      'Vous serez redirigé vers un formulaire de paiement sécurisé Stripe.';

  @override
  String paymentPay(String price) {
    return 'Payer $price €';
  }

  @override
  String get paymentProceed => 'Procéder au paiement';

  @override
  String get paymentSecure => 'Paiement sécurisé';

  @override
  String get paymentError => 'Le paiement a échoué. Veuillez réessayer.';

  @override
  String get errorNetwork =>
      'Impossible de se connecter. Vérifiez votre connexion internet et réessayez.';

  @override
  String get errorServer =>
      'Une erreur serveur est survenue. Veuillez réessayer plus tard.';

  @override
  String get errorUnknown =>
      'Une erreur inattendue est survenue. Veuillez réessayer.';

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
    return '$count casiers trouvés';
  }

  @override
  String get clearFilters => 'Supprimer les filtres';

  @override
  String get openLocker => 'Ouvrir le casier';

  @override
  String get openLockerOpening => 'Ouverture du casier...';

  @override
  String get openLockerSuccess => 'Casier ouvert !';

  @override
  String get openLockerSuccessSubtitle =>
      'Votre casier est maintenant déverrouillé. Vous pouvez y accéder.';

  @override
  String get openLockerError =>
      'Impossible d\'ouvrir le casier. Veuillez réessayer.';

  @override
  String get openLockerDone => 'Terminé';

  @override
  String get profilePasswordChangeSuccess => 'Mot de passe modifié avec succès';

  @override
  String get profileCurrentPasswordIncorrect =>
      'Le mot de passe actuel est incorrect';

  @override
  String get profileNewPasswordInvalid =>
      'Le nouveau mot de passe n\'est pas valide';

  @override
  String get profilePasswordChangeError =>
      'Impossible de modifier le mot de passe. Réessayez.';

  @override
  String get profileNewPasswordTooShort =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get profileNewPasswordSameAsCurrent =>
      'Le nouveau mot de passe doit être différent de l\'actuel';

  @override
  String get bookingSlotUnavailable =>
      'Ce créneau n\'est plus disponible pour ce casier. Choisissez-en un autre.';

  @override
  String get bookingInvalidDuration =>
      'La durée sélectionnée n\'est pas valide pour ce casier.';

  @override
  String get bookingNetworkError =>
      'Connexion impossible. Vérifiez votre réseau et réessayez.';

  @override
  String get authTooManyAttempts =>
      'Trop de tentatives. Réessayez dans une minute.';

  @override
  String get reservationRefundLabel => 'Remboursement';

  @override
  String get reservationRefundSucceeded => 'Effectué';

  @override
  String get reservationRefundPending => 'En cours';

  @override
  String get reservationRefundFailed => 'Échec';

  @override
  String get reservationRefundNotApplicable => 'Non applicable';

  @override
  String reservationCancelledOn(String date) {
    return 'Annulée le $date';
  }
}
