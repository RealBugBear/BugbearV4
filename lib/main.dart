import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:bugbear_app/firebase_options.dart';
import 'package:bugbear_app/services/auth_service.dart';
import 'package:bugbear_app/state/auth_provider.dart';
import 'package:bugbear_app/screens/common/splash_screen.dart';
import 'package:bugbear_app/screens/onboarding/login_screen.dart';
import 'package:bugbear_app/screens/onboarding/register_screen.dart';
import 'package:bugbear_app/screens/onboarding/role_selection_screen.dart';
import 'package:bugbear_app/screens/common/dashboard_screen.dart';
import 'package:bugbear_app/screens/training/training_screen.dart';
import 'package:bugbear_app/screens/calendar/calendar_screen.dart';
import 'package:bugbear_app/screens/forum/forum_screen.dart';
import 'package:bugbear_app/screens/profile/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppAuthProvider>(
          create: (_) => AppAuthProvider(),
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        title: 'BugBear App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (c) => const SplashScreen(),
          '/login': (c) => const LoginScreen(),
          '/register': (c) => const RegisterScreen(),
          '/select-role': (c) => const RoleSelectionScreen(),
          '/dashboard': (c) => const DashboardScreen(),
          '/training': (c) => const TrainingScreen(),
          '/calendar': (c) => const CalendarScreen(),
          '/forum': (c) => const ForumScreen(),
          '/settings': (c) => const SettingsScreen(),
        },
      ),
    );
  }
}
