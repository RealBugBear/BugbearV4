// File: lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bugbear_app/generated/l10n.dart';
import 'package:bugbear_app/firebase_options.dart';
import 'package:bugbear_app/screens/login_screen.dart';
import 'package:bugbear_app/screens/profile_screen.dart';
import 'package:bugbear_app/screens/passwort_reset_screen.dart';
import 'package:bugbear_app/screens/sound_settings_screen.dart';
import 'package:bugbear_app/screens/spinalergalant_screen.dart' as spinal;
import 'package:bugbear_app/screens/moro_trainer_screen.dart' as moro;
import 'package:bugbear_app/services/sound_manager.dart';
import 'package:bugbear_app/services/sound_packs.dart';
import 'package:bugbear_app/providers/locale_provider.dart';
import 'package:bugbear_app/models/quiz_model.dart';
import 'package:bugbear_app/screens/quiz_screen.dart';
import 'package:bugbear_app/screens/results_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SoundManager().init(pack: classicpack);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await notificationsPlugin.initialize(initSettings);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => QuizModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context).locale;
    return MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('de')],
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (_) => RootScreen(),
        '/login': (_) => LoginScreen(),
        '/profile': (_) => ProfileScreen(),
        '/spinalergalant': (_) => const spinal.SpinalergalantScreen(),
        '/moro': (_) => const moro.MoroTrainerScreen(),
        '/reset-password': (_) => const PasswordResetScreen(),
        '/sound-settings': (_) => const SoundSettingsScreen(),
        '/quiz': (_) => const QuizScreen(),
        '/results': (_) => const ResultsScreen(),
      },
    );
  }
}

class RootScreen extends StatelessWidget {
  final FirebaseAuth auth;

  // no longer const; FirebaseAuth.instance is not a compile-time constant
  RootScreen({Key? key, FirebaseAuth? auth})
      : auth = auth ?? FirebaseAuth.instance,
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
        return snap.hasData ? ProfileScreen() : LoginScreen();
      },
    );
  }
}
