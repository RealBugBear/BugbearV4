import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      setState(() {
        _message = 'Die Passwort-Zurücksetzungs-E-Mail wurde gesendet.';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = 'Fehler: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _message = 'Ein unerwarteter Fehler ist aufgetreten.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passwort zurücksetzen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Gib deine E-Mail-Adresse ein, um eine Passwort-Zurücksetzungs-E-Mail zu erhalten:',
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-Mail',
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _resetPassword,
                    child: const Text('Zurücksetzen'),
                  ),
            if (_message != null) ...[
              const SizedBox(height: 20),
              Text(
                _message!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
