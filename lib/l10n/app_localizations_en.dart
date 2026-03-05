// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Locked In';

  @override
  String get home => 'Home';

  @override
  String get map => 'Map';

  @override
  String get reservations => 'Reservations';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get lightMode => 'Light mode';

  @override
  String get systemMode => 'System';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get loginSubtitle => 'Sign in to access your lockers';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Email is not valid';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get loginTitle => 'Book your lockers with ease';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get search => 'Search';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get noResults => 'No results';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String get italian => 'Italiano';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get registerSubtitle => 'Sign up to book your lockers';

  @override
  String get firstname => 'First name';

  @override
  String get lastname => 'Last name';

  @override
  String get phone => 'Phone';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get firstnameRequired => 'First name is required';

  @override
  String get lastnameRequired => 'Last name is required';

  @override
  String get phoneRequired => 'Phone is required';

  @override
  String get phoneInvalid => 'Phone number is not valid';

  @override
  String get confirmPasswordRequired => 'Password confirmation is required';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get registerSuccess => 'Registration successful! Please sign in.';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get homeGreeting => 'Welcome';

  @override
  String get homeTitle => 'Find your locker';

  @override
  String availableLockers(int available, int total) {
    return '$available/$total available';
  }

  @override
  String get rechargeable => 'Charging';

  @override
  String get notRechargeable => 'Not rechargeable';

  @override
  String get noLockersTitle => 'No lockers available';

  @override
  String get noLockersSubtitle =>
      'No locker points are available at the moment. Please check back later.';

  @override
  String get lockerBays => 'Locker points';

  @override
  String get searchLockerBays => 'Search locker points...';

  @override
  String noSearchResults(String query) {
    return 'No results for \"$query\". Try a different term.';
  }

  @override
  String get filters => 'Filters';

  @override
  String get resetFilters => 'Reset';

  @override
  String get filterPrice => 'Price';

  @override
  String get filterSize => 'Size';

  @override
  String get filterMaterial => 'Material';

  @override
  String get filterRechargeable => 'Rechargeable only';

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
  String get filterDistanceNoLimit => 'Unlimited';

  @override
  String showResults(int count) {
    return 'Show $count results';
  }

  @override
  String get noFilterResults => 'No lockers match your filters';

  @override
  String get lockerBayDetail => 'Point details';

  @override
  String get lockerBayAddress => 'Address';

  @override
  String get lockerBayCompany => 'Company';

  @override
  String get lockerBayLockers => 'Lockers';

  @override
  String lockerNumber(int number) {
    return 'Locker #$number';
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
  String get lockerAvailable => 'Available';

  @override
  String get lockerReserved => 'Reserved';

  @override
  String get lockerOccupied => 'Occupied';

  @override
  String get lockerOutOfOrder => 'Out of order';

  @override
  String get lockerOffline => 'Offline';

  @override
  String get reserveLocker => 'Reserve';

  @override
  String pricePerDay(String price) {
    return '$price €';
  }

  @override
  String get mapLockerBays => 'Locker points';

  @override
  String mapLockerBayCount(int count) {
    return '$count lockers';
  }

  @override
  String get mapSeeDetails => 'See details';

  @override
  String get mapAroundMe => 'Around me';

  @override
  String get mapNearest => 'Nearest';

  @override
  String mapDistance(String distance) {
    return '$distance';
  }

  @override
  String get mapLocationDenied => 'Location access was denied';

  @override
  String get mapLocationDeniedForever =>
      'Location access is disabled. Enable it in settings.';

  @override
  String get mapLocationServiceDisabled => 'Location service is disabled';

  @override
  String get mapOpenSettings => 'Open settings';

  @override
  String get mapMyPosition => 'My position';

  @override
  String get reservationFlowTitle => 'Reserve a locker';

  @override
  String get reservationSelectDate => 'Plan your reservation';

  @override
  String get reservationStartDate => 'Date';

  @override
  String get reservationStartTime => 'Start time';

  @override
  String get reservationDurationLabel => 'Duration';

  @override
  String reservationDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String reservationDurationHoursMinutes(int hours, String minutes) {
    return '${hours}h$minutes';
  }

  @override
  String get reservationNext => 'Continue';

  @override
  String get reservationSummaryTitle => 'Summary';

  @override
  String get reservationLocker => 'Locker';

  @override
  String get reservationLocation => 'Location';

  @override
  String get reservationPeriod => 'Period';

  @override
  String get reservationTotalPrice => 'Total';

  @override
  String reservationPrice(String price) {
    return '$price €';
  }

  @override
  String get reservationConfirm => 'Confirm reservation';

  @override
  String get reservationSuccessTitle => 'Reservation confirmed!';

  @override
  String get reservationSuccessSubtitle =>
      'Your locker is reserved. Show this code on arrival.';

  @override
  String get reservationCode => 'Reservation code';

  @override
  String get reservationBackToHome => 'Back to home';

  @override
  String get reservationViewAll => 'View my reservations';

  @override
  String get reservationSelectDateHint => 'Tap to select';

  @override
  String get reservationDateFrom => 'Start';

  @override
  String get reservationDateTo => 'End';

  @override
  String reservationMaxDuration(int minutes) {
    return 'Max duration: $minutes min';
  }

  @override
  String get reservationErrorGeneric => 'An error occurred. Please try again.';

  @override
  String get reservationsEmpty => 'No reservations';

  @override
  String get reservationsEmptySubtitle =>
      'You don\'t have any reservations yet. Book your first locker!';

  @override
  String get reservationStatusPending => 'Pending';

  @override
  String get reservationStatusConfirmed => 'Confirmed';

  @override
  String get reservationStatusActive => 'Active';

  @override
  String get reservationStatusCompleted => 'Completed';

  @override
  String get reservationStatusCancelled => 'Cancelled';

  @override
  String get reservationStatusExpired => 'Expired';

  @override
  String get reservationsUpcoming => 'Upcoming';

  @override
  String get reservationsPast => 'Past';

  @override
  String get reservationCancelTitle => 'Cancel reservation';

  @override
  String get reservationCancelMessage =>
      'Are you sure you want to cancel this reservation?';

  @override
  String get reservationCancelConfirm => 'Confirm cancellation';

  @override
  String get reservationDetailTitle => 'Reservation detail';

  @override
  String get reservationDetailLocker => 'Locker';

  @override
  String get reservationDetailLockerBay => 'Pickup point';

  @override
  String get reservationDetailPeriod => 'Period';

  @override
  String get reservationDetailDuration => 'Duration';

  @override
  String get reservationDetailPrice => 'Price';

  @override
  String get reservationDetailSpecifications => 'Specifications';

  @override
  String reservationDetailDimensions(int width, int height, int depth) {
    return '$width × $height × $depth cm';
  }

  @override
  String get reservationDetailMaterial => 'Material';

  @override
  String get reservationDetailCancelReservation => 'Cancel reservation';

  @override
  String get profilePersonalInfo => 'Personal information';

  @override
  String get profilePreferences => 'Preferences';

  @override
  String get profileAbout => 'About';

  @override
  String profileVersion(String version) {
    return 'Version $version';
  }

  @override
  String profileMemberSince(String date) {
    return 'Member since $date';
  }

  @override
  String get profileTerms => 'Terms of use';

  @override
  String get profilePrivacy => 'Privacy policy';

  @override
  String get profileHelp => 'Help & support';

  @override
  String get profileLogoutConfirm => 'Are you sure you want to log out?';

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get profileChangePassword => 'Change password';

  @override
  String get profileCurrentPassword => 'Current password';

  @override
  String get profileNewPassword => 'New password';

  @override
  String get profileEditSuccess => 'Profile updated successfully';

  @override
  String get profileEditError => 'Failed to update profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get paymentSubtitle => 'Complete your reservation securely';

  @override
  String get paymentCardDetails => 'Card payment';

  @override
  String get paymentStripeInfo =>
      'You will be redirected to a secure Stripe payment form.';

  @override
  String paymentPay(String price) {
    return 'Pay $price €';
  }

  @override
  String get paymentProceed => 'Proceed to payment';

  @override
  String get paymentSecure => 'Secure payment';

  @override
  String get paymentError => 'Payment failed. Please try again.';

  @override
  String get errorNetwork =>
      'Unable to connect. Check your internet connection and try again.';

  @override
  String get errorServer => 'A server error occurred. Please try again later.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please try again.';

  @override
  String get nearbyBays => 'Near you';

  @override
  String get allBays => 'All points';

  @override
  String get seeAll => 'See all';

  @override
  String get nearbyDescription => 'Locker points closest to you';

  @override
  String totalLockers(int count) {
    return '$count lockers total';
  }

  @override
  String cities(int count) {
    return '$count cities';
  }

  @override
  String fromPrice(String price) {
    return 'from $price €';
  }

  @override
  String filteredResults(int count) {
    return '$count lockers found';
  }

  @override
  String get clearFilters => 'Clear filters';
}
