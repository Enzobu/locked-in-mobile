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
}
