// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  static String m0(cycle) => "Zyklus ${cycle} abgeschlossen";

  static String m1(error) => "Fehler: ${error}";

  static String m2(idx) => "Übung ${idx} abgeschlossen.";

  static String m3(idx) => "Übung ${idx} läuft.";

  static String m4(idx) => "Nimm Position für Übung ${idx} ein.";

  static String m5(message) => "Fehler: ${message}";

  static String m6(current, total) => "Frage ${current} von ${total}";

  static String m7(idx) => "▶️ Starte Zyklus ${idx}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "allCyclesCompleted": MessageLookupByLibrary.simpleMessage(
      "Alle Zyklen abgeschlossen!",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("Bugbear App"),
    "classicpack": MessageLookupByLibrary.simpleMessage("Classicpack"),
    "cycleComplete": m0,
    "dayDi": MessageLookupByLibrary.simpleMessage("Di"),
    "dayDo": MessageLookupByLibrary.simpleMessage("Do"),
    "dayFr": MessageLookupByLibrary.simpleMessage("Fr"),
    "dayMi": MessageLookupByLibrary.simpleMessage("Mi"),
    "dayMo": MessageLookupByLibrary.simpleMessage("Mo"),
    "daySa": MessageLookupByLibrary.simpleMessage("Sa"),
    "daySo": MessageLookupByLibrary.simpleMessage("So"),
    "defaultEmail": MessageLookupByLibrary.simpleMessage("Keine E-Mail"),
    "defaultUsername": MessageLookupByLibrary.simpleMessage("Benutzer"),
    "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
    "english": MessageLookupByLibrary.simpleMessage("Englisch"),
    "errorLoading": m1,
    "exerciseDone": m2,
    "exerciseInProgress": m3,
    "forgotPassword": MessageLookupByLibrary.simpleMessage(
      "Passwort vergessen?",
    ),
    "german": MessageLookupByLibrary.simpleMessage("Deutsch"),
    "getIntoPosition": m4,
    "home": MessageLookupByLibrary.simpleMessage("Start"),
    "languageSettings": MessageLookupByLibrary.simpleMessage("Sprache"),
    "logOut": MessageLookupByLibrary.simpleMessage("Abmelden"),
    "loginButton": MessageLookupByLibrary.simpleMessage("Anmelden"),
    "loginErrorDefault": MessageLookupByLibrary.simpleMessage("Anmeldefehler"),
    "loginTitle": MessageLookupByLibrary.simpleMessage("Login"),
    "memepack": MessageLookupByLibrary.simpleMessage("Memepack"),
    "moroTrainerTitle": MessageLookupByLibrary.simpleMessage("Moro Trainer"),
    "no": MessageLookupByLibrary.simpleMessage("Nein"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "overallProgressTitle": MessageLookupByLibrary.simpleMessage(
      "Gesamtfortschritt-Kalender",
    ),
    "passwordLabel": MessageLookupByLibrary.simpleMessage("Passwort"),
    "passwordResetError": m5,
    "pressStartNextCycle": MessageLookupByLibrary.simpleMessage(
      "Drücke START für den nächsten Zyklus.",
    ),
    "profileTitle": MessageLookupByLibrary.simpleMessage("Profil"),
    "quizProgress": m6,
    "quizTitle": MessageLookupByLibrary.simpleMessage("Reflex-Quiz"),
    "registerButton": MessageLookupByLibrary.simpleMessage("Registrieren"),
    "registrationErrorDefault": MessageLookupByLibrary.simpleMessage(
      "Registrierungsfehler",
    ),
    "resetAll": MessageLookupByLibrary.simpleMessage("Alles zurücksetzen"),
    "resetButton": MessageLookupByLibrary.simpleMessage("Zurücksetzen"),
    "resetEmailSent": MessageLookupByLibrary.simpleMessage(
      "Die Passwort-Zurücksetzungs-E-Mail wurde gesendet.",
    ),
    "resetPasswordInstruction": MessageLookupByLibrary.simpleMessage(
      "Gib deine E-Mail-Adresse ein, um eine Passwort-Zurücksetzungs-E-Mail zu erhalten:",
    ),
    "resetPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Passwort zurücksetzen",
    ),
    "resultHeader": MessageLookupByLibrary.simpleMessage("Ihr Reflex-Profil"),
    "screenshotHint": MessageLookupByLibrary.simpleMessage(
      "Machen Sie einen Screenshot, um Ihre Ergebnisse zu speichern.",
    ),
    "selectLanguage": MessageLookupByLibrary.simpleMessage("Sprache wählen"),
    "soundSettingsTitle": MessageLookupByLibrary.simpleMessage("Sound-Pakete"),
    "spinalergalantTrainerTitle": MessageLookupByLibrary.simpleMessage(
      "Spinalergalant Trainer",
    ),
    "startCycle": m7,
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "Ein unerwarteter Fehler ist aufgetreten.",
    ),
    "unknownError": MessageLookupByLibrary.simpleMessage("Unbekannter Fehler"),
    "userNotLoggedIn": MessageLookupByLibrary.simpleMessage(
      "Benutzer nicht angemeldet.",
    ),
    "yes": MessageLookupByLibrary.simpleMessage("Ja"),
  };
}
