import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bugbear_app/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller für E-Mail und Passwort
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Firebase Auth Instanz
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String errorMessage = '';

  // Funktion zum Anmelden
  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Abrufen der UID, z.B. zur Verknüpfung mit Trainingsdaten
      String uid = userCredential.user?.uid ?? '';
      debugPrint('Login erfolgreich. UID: $uid');
      // Weiterleitung oder weitere Logik hier einfügen
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Login-Fehler';
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Unbekannter Fehler';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Funktion zur Registrierung
  Future<void> _register() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String uid = userCredential.user?.uid ?? '';
      debugPrint('Registrierung erfolgreich. UID: $uid');
      // Nach erfolgreicher Registrierung ggf. direkt einloggen oder weiterleiten
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Registrierungsfehler';
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Unbekannter Fehler';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // E-Mail Eingabe
            CustomTextField(
              label: 'E-Mail',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Passwort Eingabe
            CustomTextField(
              label: 'Passwort',
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            isLoading
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _login,
                        child: const Text('Login'),
                      ),
                      ElevatedButton(
                        onPressed: _register,
                        child: const Text('Registrieren'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
