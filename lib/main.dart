import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bugbear_app/firebase_options.dart';
import 'package:bugbear_app/screens/login_screen.dart';
import 'package:bugbear_app/screens/profile_screen.dart';
import 'package:bugbear_app/screens/spinalergalant_screen.dart';
import 'package:bugbear_app/screens/moro_trainer_screen.dart';

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
    return MaterialApp(
      title: 'Bugbear App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => ProfileScreen(),
        '/spinalergalant': (context) => const SpinalergalantScreen(),
        '/moro': (context) => const MoroTrainerScreen(),
      },
    );
  }
}
