// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(cycle) => "Cycle ${cycle} complete";

  static String m1(error) => "Error: ${error}";

  static String m2(idx) => "Exercise ${idx} done.";

  static String m3(idx) => "Exercise ${idx} in progress.";

  static String m4(idx) => "Get into position for exercise ${idx}.";

  static String m5(message) => "Error: ${message}";

  static String m6(current, total) => "Question ${current} of ${total}";

  static String m7(idx) => "▶️ Start cycle ${idx}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "allCyclesCompleted": MessageLookupByLibrary.simpleMessage(
      "All cycles completed!",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("Bugbear App"),
    "classicpack": MessageLookupByLibrary.simpleMessage("Classicpack"),
    "cycleComplete": m0,
    "dayDi": MessageLookupByLibrary.simpleMessage("Tu"),
    "dayDo": MessageLookupByLibrary.simpleMessage("Th"),
    "dayFr": MessageLookupByLibrary.simpleMessage("Fr"),
    "dayMi": MessageLookupByLibrary.simpleMessage("We"),
    "dayMo": MessageLookupByLibrary.simpleMessage("Mo"),
    "daySa": MessageLookupByLibrary.simpleMessage("Sa"),
    "daySo": MessageLookupByLibrary.simpleMessage("Su"),
    "defaultEmail": MessageLookupByLibrary.simpleMessage("No email"),
    "defaultUsername": MessageLookupByLibrary.simpleMessage("User"),
    "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "errorLoading": m1,
    "exerciseDone": m2,
    "exerciseInProgress": m3,
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot password?"),
    "german": MessageLookupByLibrary.simpleMessage("German"),
    "getIntoPosition": m4,
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "languageSettings": MessageLookupByLibrary.simpleMessage("Language"),
    "logOut": MessageLookupByLibrary.simpleMessage("Log Out"),
    "loginButton": MessageLookupByLibrary.simpleMessage("Login"),
    "loginErrorDefault": MessageLookupByLibrary.simpleMessage("Login error"),
    "loginTitle": MessageLookupByLibrary.simpleMessage("Login"),
    "memepack": MessageLookupByLibrary.simpleMessage("Memepack"),
    "moroTrainerTitle": MessageLookupByLibrary.simpleMessage("Moro Trainer"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "overallProgressTitle": MessageLookupByLibrary.simpleMessage(
      "Overall Progress Calendar",
    ),
    "passwordLabel": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordResetError": m5,
    "pressStartNextCycle": MessageLookupByLibrary.simpleMessage(
      "Press START for the next cycle.",
    ),
    "profileTitle": MessageLookupByLibrary.simpleMessage("Profile"),
    "quizProgress": m6,
    "quizTitle": MessageLookupByLibrary.simpleMessage("Reflex Quiz"),
    "registerButton": MessageLookupByLibrary.simpleMessage("Register"),
    "registrationErrorDefault": MessageLookupByLibrary.simpleMessage(
      "Registration error",
    ),
    "resetAll": MessageLookupByLibrary.simpleMessage("Reset all"),
    "resetButton": MessageLookupByLibrary.simpleMessage("Reset"),
    "resetEmailSent": MessageLookupByLibrary.simpleMessage(
      "Password reset email sent.",
    ),
    "resetPasswordInstruction": MessageLookupByLibrary.simpleMessage(
      "Enter your email to receive a password reset email:",
    ),
    "resetPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Password Reset",
    ),
    "resultHeader": MessageLookupByLibrary.simpleMessage("Your Reflex Profile"),
    "screenshotHint": MessageLookupByLibrary.simpleMessage(
      "Take a screenshot to save your results.",
    ),
    "selectLanguage": MessageLookupByLibrary.simpleMessage("Select Language"),
    "soundSettingsTitle": MessageLookupByLibrary.simpleMessage("Sound Packs"),
    "spinalergalantTrainerTitle": MessageLookupByLibrary.simpleMessage(
      "Spinalergalant Trainer",
    ),
    "startCycle": m7,
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "An unexpected error occurred.",
    ),
    "unknownError": MessageLookupByLibrary.simpleMessage("Unknown error"),
    "userNotLoggedIn": MessageLookupByLibrary.simpleMessage(
      "User not logged in.",
    ),
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
  };
}
