import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/timer_screen.dart';
import 'screens/moro_trainer_screen.dart';
import 'screens/Training.dart'; // TrainingScreen
import 'screens/spinalergalant_screen.dart'; // SpinalergalantScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Timer App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Set the WelcomeScreen as the initial route
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/timer': (context) => const TimerScreen(),
        '/moro': (context) => const MoroTrainerScreen(),
        '/training': (context) => const TrainingScreen(),
        '/spinalergalant': (context) => const SpinalergalantScreen(),
      },
    );
  }
}
