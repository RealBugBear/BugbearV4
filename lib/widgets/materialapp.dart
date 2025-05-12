// lib/widgets/materialapp.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bugbear_app/generated/l10n.dart';
import 'package:bugbear_app/core/providers/locale_provider.dart';
import 'package:bugbear_app/core/themes/app_theme.dart';

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
        '/': (ctx) => const RootScreen(),
        '/login': (ctx) => const LoginScreen(),
        '/profile': (ctx) => const ProfileScreen(),
        '/spinalergalant': (ctx) => const spinal.SpinalergalantScreen(),
        '/moro': (ctx) => const moro.MoroTrainerScreen(),
        '/reset-password': (ctx) => const PasswordResetScreen(),
        '/sound-settings': (ctx) => const SoundSettingsScreen(),
        '/quiz': (ctx) => const QuizScreen(),
        '/results': (ctx) => const ResultsScreen(),
        '/debug-audio': (ctx) => const DebugAudioScreen(),
      },
    );
  }
}

/// Exactly the same RootScreen as in main.dart, so your tests work
class RootScreen extends StatelessWidget {
  final FirebaseAuth auth;
  final Widget Function(BuildContext, User?) builder;

  const RootScreen({
    Key? key,
    FirebaseAuth? auth,
    Widget Function(BuildContext, User?)? builder,
  })  : auth = auth ?? FirebaseAuth.instance,
        builder = builder ??
            ((_, user) => user != null ? const ProfileScreen() : const LoginScreen()),
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
