import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // App strings
  String get appTitle => 'Igitabu';
  String get signIn => _getLocalizedString('signIn');
  String get signUp => _getLocalizedString('signUp');
  String get email => _getLocalizedString('email');
  String get password => _getLocalizedString('password');
  String get home => _getLocalizedString('home');
  String get explore => _getLocalizedString('explore');
  String get downloads => _getLocalizedString('downloads');
  String get favorites => _getLocalizedString('favorites');
  String get profile => _getLocalizedString('profile');
  String get settings => _getLocalizedString('settings');

  String _getLocalizedString(String key) {
    final strings = _getStrings();
    return strings[key] ?? key;
  }

  Map<String, String> _getStrings() {
    switch (locale.languageCode) {
      case 'fr':
        return {
          'signIn': 'Se connecter',
          'signUp': 'S\'inscrire',
          'email': 'Email',
          'password': 'Mot de passe',
          'home': 'Accueil',
          'explore': 'Explorer',
          'downloads': 'Téléchargements',
          'favorites': 'Favoris',
          'profile': 'Profil',
          'settings': 'Paramètres',
        };
      case 'rn':
        return {
          'signIn': 'Kwinjira',
          'signUp': 'Kwiyandikisha',
          'email': 'Imeyili',
          'password': 'Ijambo ry\'ibanga',
          'home': 'Ahabanza',
          'explore': 'Shakisha',
          'downloads': 'Byakuruwe',
          'favorites': 'Byakunze',
          'profile': 'Umwirondoro',
          'settings': 'Amagenamiterere',
        };
      default: // English
        return {
          'signIn': 'Sign In',
          'signUp': 'Sign Up',
          'email': 'Email',
          'password': 'Password',
          'home': 'Home',
          'explore': 'Explore',
          'downloads': 'Downloads',
          'favorites': 'Favorites',
          'profile': 'Profile',
          'settings': 'Settings',
        };
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'rn'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}