import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:bugbear_app/firebase_options.dart';
import 'package:bugbear_app/screens/login_screen.dart';
import 'package:bugbear_app/screens/profile_screen.dart';
import 'package:bugbear_app/screens/spinalergalant_screen.dart';
import 'package:bugbear_app/screens/moro_trainer_screen.dart';
import 'package:bugbear_app/screens/passwort_reset_screen.dart';
import 'package:bugbear_app/notification_service.dart'; // Import der Benachrichtigungsdienste

// Initialisiere das Plugin für lokale Benachrichtigungen
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialisieren
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Android-spezifische Einstellungen für Benachrichtigungen
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // Gesamtinitialisierung für alle Plattformen
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Plugin initialisieren mit Callback, falls eine Benachrichtigung ausgewählt wird
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      final payload = response.payload;
      if (payload != null) {
        print("Notification payload: $payload");
        // Hier können Sie Navigationslogik oder andere Aktionen einbauen
      }
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bugbear App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Überwacht den Authentifizierungsstatus des Benutzers
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // Falls ein Benutzer angemeldet ist, zeigen wir den ProfileScreen mit einem Test-Button
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Profile Screen'),
              ),
              body: ProfileScreen(),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Löst die Erinnerungsbenachrichtigung aus, die in notification_service.dart definiert ist
                  showTrainingNotification();
                },
                child: const Icon(Icons.notifications),
              ),
            );
          }
          // Falls kein Benutzer angemeldet ist, zeigen wir den LoginScreen
          return const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => ProfileScreen(),
        '/spinalergalant': (context) => const SpinalergalantScreen(),
        '/moro': (context) => const MoroTrainerScreen(),
        '/reset-password': (context) => const PasswordResetScreen(),
      },
    );
  }
}
