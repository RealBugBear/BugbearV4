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

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Bugbear App`
  String get appTitle {
    return Intl.message('Bugbear App', name: 'appTitle', desc: '', args: []);
  }

  /// `Reflex Quiz`
  String get quizTitle {
    return Intl.message('Reflex Quiz', name: 'quizTitle', desc: '', args: []);
  }

  /// `Login`
  String get loginTitle {
    return Intl.message('Login', name: 'loginTitle', desc: '', args: []);
  }

  /// `Email`
  String get emailLabel {
    return Intl.message('Email', name: 'emailLabel', desc: '', args: []);
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message('Password', name: 'passwordLabel', desc: '', args: []);
  }

  /// `Login`
  String get loginButton {
    return Intl.message('Login', name: 'loginButton', desc: '', args: []);
  }

  /// `Register`
  String get registerButton {
    return Intl.message('Register', name: 'registerButton', desc: '', args: []);
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Your Reflex Profile`
  String get resultHeader {
    return Intl.message(
      'Your Reflex Profile',
      name: 'resultHeader',
      desc: '',
      args: [],
    );
  }

  /// `Take a screenshot to save your results.`
  String get screenshotHint {
    return Intl.message(
      'Take a screenshot to save your results.',
      name: 'screenshotHint',
      desc: '',
      args: [],
    );
  }

  /// `Login error`
  String get loginErrorDefault {
    return Intl.message(
      'Login error',
      name: 'loginErrorDefault',
      desc: '',
      args: [],
    );
  }

  /// `Registration error`
  String get registrationErrorDefault {
    return Intl.message(
      'Registration error',
      name: 'registrationErrorDefault',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error`
  String get unknownError {
    return Intl.message(
      'Unknown error',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Moro Trainer`
  String get moroTrainerTitle {
    return Intl.message(
      'Moro Trainer',
      name: 'moroTrainerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Get into position for exercise {idx}.`
  String getIntoPosition(Object idx) {
    return Intl.message(
      'Get into position for exercise $idx.',
      name: 'getIntoPosition',
      desc: 'Prompt before starting exercise number',
      args: [idx],
    );
  }

  /// `Exercise {idx} in progress.`
  String exerciseInProgress(Object idx) {
    return Intl.message(
      'Exercise $idx in progress.',
      name: 'exerciseInProgress',
      desc: 'Prompt while exercise is in progress',
      args: [idx],
    );
  }

  /// `Exercise {idx} done.`
  String exerciseDone(Object idx) {
    return Intl.message(
      'Exercise $idx done.',
      name: 'exerciseDone',
      desc: 'Prompt when exercise is done',
      args: [idx],
    );
  }

  /// `Cycle {cycle} complete`
  String cycleComplete(Object cycle) {
    return Intl.message(
      'Cycle $cycle complete',
      name: 'cycleComplete',
      desc: 'Dialog title when one cycle is complete',
      args: [cycle],
    );
  }

  /// `Press START for the next cycle.`
  String get pressStartNextCycle {
    return Intl.message(
      'Press START for the next cycle.',
      name: 'pressStartNextCycle',
      desc: '',
      args: [],
    );
  }

  /// `All cycles completed!`
  String get allCyclesCompleted {
    return Intl.message(
      'All cycles completed!',
      name: 'allCyclesCompleted',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `▶️ Start cycle {idx}`
  String startCycle(Object idx) {
    return Intl.message(
      '▶️ Start cycle $idx',
      name: 'startCycle',
      desc: 'Button text to start a given cycle',
      args: [idx],
    );
  }

  /// `Reset all`
  String get resetAll {
    return Intl.message('Reset all', name: 'resetAll', desc: '', args: []);
  }

  /// `Password Reset`
  String get resetPasswordTitle {
    return Intl.message(
      'Password Reset',
      name: 'resetPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email to receive a password reset email:`
  String get resetPasswordInstruction {
    return Intl.message(
      'Enter your email to receive a password reset email:',
      name: 'resetPasswordInstruction',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get resetButton {
    return Intl.message('Reset', name: 'resetButton', desc: '', args: []);
  }

  /// `Password reset email sent.`
  String get resetEmailSent {
    return Intl.message(
      'Password reset email sent.',
      name: 'resetEmailSent',
      desc: '',
      args: [],
    );
  }

  /// `Error: {message}`
  String passwordResetError(Object message) {
    return Intl.message(
      'Error: $message',
      name: 'passwordResetError',
      desc: 'Error message when password reset fails',
      args: [message],
    );
  }

  /// `An unexpected error occurred.`
  String get unexpectedError {
    return Intl.message(
      'An unexpected error occurred.',
      name: 'unexpectedError',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileTitle {
    return Intl.message('Profile', name: 'profileTitle', desc: '', args: []);
  }

  /// `User not logged in.`
  String get userNotLoggedIn {
    return Intl.message(
      'User not logged in.',
      name: 'userNotLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `Overall Progress Calendar`
  String get overallProgressTitle {
    return Intl.message(
      'Overall Progress Calendar',
      name: 'overallProgressTitle',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String errorLoading(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'errorLoading',
      desc: 'Error message when loading training data',
      args: [error],
    );
  }

  /// `Mo`
  String get dayMo {
    return Intl.message('Mo', name: 'dayMo', desc: '', args: []);
  }

  /// `Tu`
  String get dayDi {
    return Intl.message('Tu', name: 'dayDi', desc: '', args: []);
  }

  /// `We`
  String get dayMi {
    return Intl.message('We', name: 'dayMi', desc: '', args: []);
  }

  /// `Th`
  String get dayDo {
    return Intl.message('Th', name: 'dayDo', desc: '', args: []);
  }

  /// `Fr`
  String get dayFr {
    return Intl.message('Fr', name: 'dayFr', desc: '', args: []);
  }

  /// `Sa`
  String get daySa {
    return Intl.message('Sa', name: 'daySa', desc: '', args: []);
  }

  /// `Su`
  String get daySo {
    return Intl.message('Su', name: 'daySo', desc: '', args: []);
  }

  /// `User`
  String get defaultUsername {
    return Intl.message('User', name: 'defaultUsername', desc: '', args: []);
  }

  /// `No email`
  String get defaultEmail {
    return Intl.message('No email', name: 'defaultEmail', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Spinalergalant Trainer`
  String get spinalergalantTrainerTitle {
    return Intl.message(
      'Spinalergalant Trainer',
      name: 'spinalergalantTrainerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sound Packs`
  String get soundSettingsTitle {
    return Intl.message(
      'Sound Packs',
      name: 'soundSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logOut {
    return Intl.message('Log Out', name: 'logOut', desc: '', args: []);
  }

  /// `Language`
  String get languageSettings {
    return Intl.message(
      'Language',
      name: 'languageSettings',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `German`
  String get german {
    return Intl.message('German', name: 'german', desc: '', args: []);
  }

  /// `Memepack`
  String get memepack {
    return Intl.message('Memepack', name: 'memepack', desc: '', args: []);
  }

  /// `Classicpack`
  String get classicpack {
    return Intl.message('Classicpack', name: 'classicpack', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
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
