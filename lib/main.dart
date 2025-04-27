// File: lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:bugbear_app/generated/l10n.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:bugbear_app/widgets/app_drawer.dart';
import 'package:bugbear_app/firebase_options.dart';
import 'package:bugbear_app/screens/login_screen.dart';
import 'package:bugbear_app/screens/profile_screen.dart';
// Prefix imports to avoid name conflicts:
import 'package:bugbear_app/screens/spinalergalant_screen.dart' as spinal;
import 'package:bugbear_app/screens/moro_trainer_screen.dart' as moro;
import 'package:bugbear_app/screens/passwort_reset_screen.dart';
import 'package:bugbear_app/screens/sound_settings_screen.dart';

import 'package:bugbear_app/notification_service.dart';
import 'package:bugbear_app/services/sound_manager.dart';
import 'package:bugbear_app/services/sound_packs.dart';
import 'package:bugbear_app/providers/locale_provider.dart';

// Global plugin for local notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. SoundManager init with classic pack (preload-assets)
  await SoundManager().init(pack: classicpack);

  // 2. Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. Android-specific notification settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // 4. Global notification settings
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // 5. Initialize notification plugin
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      final payload = response.payload;
      if (payload != null) {
        debugPrint('Notification payload: $payload');
      }
    },
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(), // nothing changes here
    ),
  );
}

class MyApp extends StatelessWidget {
  // ✨ NEW: allow injecting a LocaleProvider for tests
  final LocaleProvider? testLocaleProvider;
  const MyApp({super.key, this.testLocaleProvider});

  @override
  Widget build(BuildContext context) {
    // use the injected provider if present, otherwise read from context
    final provider = testLocaleProvider ?? Provider.of<LocaleProvider>(context);
    final locale = provider.locale;

    return MaterialApp(
      // Dynamic title after localization loaded
      onGenerateTitle: (ctx) => S.of(ctx).appTitle,
      locale: locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StreamBuilder<User?>(
        // no change here
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(title: Text(S.of(context).overallProgressTitle)),
              drawer: const AppDrawer(),
              body: ProfileScreen(),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await SoundManager().playOnce(SoundType.start);
                  showTrainingNotification();
                },
                child: const Icon(Icons.notifications),
              ),
            );
          }
          return const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => ProfileScreen(),
        '/spinalergalant': (context) => spinal.SpinalergalantScreen(),
        '/moro': (context) => moro.MoroTrainerScreen(),
        '/reset-password': (context) => const PasswordResetScreen(),
        '/sound-settings': (context) => const SoundSettingsScreen(),
      },
    );
  }
}
