// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bugbear_app/generated/l10n.dart';
import 'package:bugbear_app/firebase_options.dart';
import 'package:bugbear_app/core/themes/app_theme.dart';
import 'package:bugbear_app/core/providers/locale_provider.dart';
import 'package:bugbear_app/models/quiz_model.dart';
import 'package:bugbear_app/services/sound_manager.dart';
import 'package:bugbear_app/services/sound_packs.dart';
import 'package:bugbear_app/services/local_storage_service.dart';
import 'package:bugbear_app/services/notification_manager.dart';

import 'package:bugbear_app/screens/login_screen.dart';
import 'package:bugbear_app/screens/profile_screen.dart';
import 'package:bugbear_app/screens/passwort_reset_screen.dart';
import 'package:bugbear_app/screens/sound_settings_screen.dart';
import 'package:bugbear_app/screens/spinalergalant_screen.dart' as spinal;
import 'package:bugbear_app/screens/moro_trainer_screen.dart' as moro;
import 'package:bugbear_app/screens/debug_audio_screen.dart';
import 'package:bugbear_app/screens/quiz_screen.dart';
import 'package:bugbear_app/screens/results_screen.dart';
import 'package:bugbear_app/screens/reflex_profile_screen.dart';
import 'package:bugbear_app/screens/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SoundManager().init(pack: classicpack);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final localStorage = LocalStorageService();
  await localStorage.init();
  await NotificationManager().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => QuizModel()),
        Provider<LocalStorageService>.value(value: localStorage),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: RootScreen(),
      routes: <String, WidgetBuilder>{
        '/login': (_) => LoginScreen(),
        '/profile': (_) => ProfileScreen(),
        '/spinalergalant': (_) => spinal.SpinalergalantScreen(),
        '/moro': (_) => moro.MoroTrainerScreen(),
        '/reset-password': (_) => PasswordResetScreen(),
        '/sound-settings': (_) => SoundSettingsScreen(),
        '/quiz': (_) => QuizScreen(),
        '/results': (_) => ResultsScreen(),
        '/reflex_profile': (_) => ReflexProfileScreen(),
        '/debug-audio': (_) => DebugAudioScreen(),
        '/settings': (_) => SettingsScreen(),
      },
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snap.data != null
            ? ProfileScreen()
            : LoginScreen();
      },
    );
  }
}
