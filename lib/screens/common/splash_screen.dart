import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bugbear_app/state/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AppAuthProvider>();
      if (!auth.isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
