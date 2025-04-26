// File: lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:bugbear_app/firebase_options.dart';
import 'package:bugbear_app/screens/login_screen.dart';
import 'package:bugbear_app/screens/profile_screen.dart';
// Prefix-Importe zur Vermeidung von Namenskonflikten:
import 'package:bugbear_app/screens/spinalergalant_screen.dart' as spinal;  // Alias hinzugefügt
import 'package:bugbear_app/screens/moro_trainer_screen.dart' as moro;  // Alias hinzugefügt
import 'package:bugbear_app/screens/passwort_reset_screen.dart';
import 'package:bugbear_app/screens/sound_settings_screen.dart';

import 'package:bugbear_app/notification_service.dart';
import 'package:bugbear_app/services/sound_manager.dart';
import 'package:bugbear_app/services/sound_packs.dart';

// Globales Plugin für lokale Benachrichtigungen
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. SoundManager: Init mit Classicpack (Assets preloading)
  await SoundManager().init(pack: classicpack);

  // 2. Firebase initialisieren
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Android-spezifische Notification-Einstellungen
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // 4. Globale Notification-Einstellungen
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // 5. Notification-Plugin initialisieren
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      final payload = response.payload;
      if (payload != null) {
        debugPrint('Notification payload: $payload');
      }
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bugbear App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(title: const Text('Profile Screen')),
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
        '/login':          (context) => const LoginScreen(),
        '/profile':        (context) => ProfileScreen(),
        '/spinalergalant': (context) => spinal.SpinalergalantScreen(),
        '/moro':           (context) => moro.MoroTrainerScreen(),
        '/reset-password': (context) => PasswordResetScreen(),
        '/sound-settings': (context) => SoundSettingsScreen(),
      },
    );
  }
}
