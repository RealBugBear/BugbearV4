// lib/widgets/materialapp.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bugbear_app/generated/l10n.dart';
import 'package:bugbear_app/providers/locale_provider.dart';
import 'package:bugbear_app/themes/app_theme.dart';

import 'package:bugbear_app/screens/login_screen.dart';
import 'package:bugbear_app/screens/profile_screen.dart';
import 'package:bugbear_app/screens/passwort_reset_screen.dart';
import 'package:bugbear_app/screens/sound_settings_screen.dart';
import 'package:bugbear_app/screens/spinalergalant_screen.dart' as spinal;
import 'package:bugbear_app/screens/moro_trainer_screen.dart' as moro;
import 'package:bugbear_app/screens/debug_audio_screen.dart';
import 'package:bugbear_app/screens/quiz_screen.dart';
import 'package:bugbear_app/screens/results_screen.dart';

/// A wrapper around [MaterialApp] that wires up:
///  • theming
///  • localization (S.delegate)
///  • named routes
class AppMaterial extends StatelessWidget {
  const AppMaterial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

    return MaterialApp(
      onGenerateTitle: (ctx) => S.of(ctx).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (ctx) => RootScreen(),
        '/login': (ctx) => LoginScreen(),
        '/profile': (ctx) => ProfileScreen(),
        '/spinalergalant': (ctx) => spinal.SpinalergalantScreen(),
        '/moro': (ctx) => moro.MoroTrainerScreen(),
        '/reset-password': (ctx) => PasswordResetScreen(),
        '/sound-settings': (ctx) => SoundSettingsScreen(),
        '/quiz': (ctx) => QuizScreen(),
        '/results': (ctx) => ResultsScreen(),
        '/debug-audio': (ctx) => DebugAudioScreen(),
      },
    );
  }
}

/// Exactly the same RootScreen as in main.dart, so your tests work
class RootScreen extends StatelessWidget {
  final FirebaseAuth auth;
  final Widget Function(BuildContext, User?) builder;

  RootScreen({
    Key? key,
    FirebaseAuth? auth,
    Widget Function(BuildContext, User?)? builder,
  })  : auth = auth ?? FirebaseAuth.instance,
        builder = builder ??
            ((_, user) => user != null
                ? ProfileScreen()
                : LoginScreen()),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return builder(ctx, snap.data);
      },
    );
  }
}
