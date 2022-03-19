// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class L {
  L();

  static L? _current;

  static L get current {
    assert(_current != null,
        'No instance of L was loaded. Try to initialize the L delegate before accessing L.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<L> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = L();
      L._current = instance;

      return instance;
    });
  }

  static L of(BuildContext context) {
    final instance = L.maybeOf(context);
    assert(instance != null,
        'No instance of L present in the widget tree. Did you add L.delegate in localizationsDelegates?');
    return instance!;
  }

  static L? maybeOf(BuildContext context) {
    return Localizations.of<L>(context, L);
  }

  /// `Loading - {progress}%`
  String loadingProgress(Object progress) {
    return Intl.message(
      'Loading - $progress%',
      name: 'loadingProgress',
      desc: '',
      args: [progress],
    );
  }

  /// `Recent login required`
  String get recentLoginRequired {
    return Intl.message(
      'Recent login required',
      name: 'recentLoginRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please log out and back in to proceed.`
  String get logInAgainToProceed {
    return Intl.message(
      'Please log out and back in to proceed.',
      name: 'logInAgainToProceed',
      desc: '',
      args: [],
    );
  }

  /// `Signing in failed`
  String get signingInFailed {
    return Intl.message(
      'Signing in failed',
      name: 'signingInFailed',
      desc: '',
      args: [],
    );
  }

  /// `Signing up failed`
  String get signingUpFailed {
    return Intl.message(
      'Signing up failed',
      name: 'signingUpFailed',
      desc: '',
      args: [],
    );
  }

  /// `Password reset failed`
  String get passwordResetFailed {
    return Intl.message(
      'Password reset failed',
      name: 'passwordResetFailed',
      desc: '',
      args: [],
    );
  }

  /// `Email update failed`
  String get emailUpdateFailed {
    return Intl.message(
      'Email update failed',
      name: 'emailUpdateFailed',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get invalidEmail {
    return Intl.message(
      'Invalid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Invalid password`
  String get invalidPassword {
    return Intl.message(
      'Invalid password',
      name: 'invalidPassword',
      desc: '',
      args: [],
    );
  }

  /// `Weak password`
  String get weakPassword {
    return Intl.message(
      'Weak password',
      name: 'weakPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password mismatch`
  String get passwordMismatch {
    return Intl.message(
      'Password mismatch',
      name: 'passwordMismatch',
      desc: '',
      args: [],
    );
  }

  /// `Email address taken`
  String get emailAddressTaken {
    return Intl.message(
      'Email address taken',
      name: 'emailAddressTaken',
      desc: '',
      args: [],
    );
  }

  /// `User not found`
  String get userNotFound {
    return Intl.message(
      'User not found',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `User disabled`
  String get userDisabled {
    return Intl.message(
      'User disabled',
      name: 'userDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error occurred`
  String get unknownErrorOccured {
    return Intl.message(
      'Unknown error occurred',
      name: 'unknownErrorOccured',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message(
      'Sign up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? Click here to create one!`
  String get dontYouHaveAccount {
    return Intl.message(
      'Don\'t have an account? Click here to create one!',
      name: 'dontYouHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Do you have an account? Click here to sign in!`
  String get doYouHaveAccount {
    return Intl.message(
      'Do you have an account? Click here to sign in!',
      name: 'doYouHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient permissions`
  String get insufficientPermissions {
    return Intl.message(
      'Insufficient permissions',
      name: 'insufficientPermissions',
      desc: '',
      args: [],
    );
  }

  /// `The following permissions are denied`
  String get theFollowingPermissionsAreDenied {
    return Intl.message(
      'The following permissions are denied',
      name: 'theFollowingPermissionsAreDenied',
      desc: '',
      args: [],
    );
  }

  /// `The following permissions are permanently denied. You need to grant them in your phones settings.`
  String get theFollowingPermissionsArePermanentlyDenied {
    return Intl.message(
      'The following permissions are permanently denied. You need to grant them in your phones settings.',
      name: 'theFollowingPermissionsArePermanentlyDenied',
      desc: '',
      args: [],
    );
  }

  /// `Grant permissions`
  String get grantPermissions {
    return Intl.message(
      'Grant permissions',
      name: 'grantPermissions',
      desc: '',
      args: [],
    );
  }

  /// `Open settings`
  String get openSettings {
    return Intl.message(
      'Open settings',
      name: 'openSettings',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<L> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<L> load(Locale locale) => L.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
