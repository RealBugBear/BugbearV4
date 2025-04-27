// File: lib/screens/password_reset_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bugbear_app/generated/l10n.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

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
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _message = S.of(context).resetEmailSent;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = S.of(context).passwordResetError(e.message ?? '');
      });
    } catch (_) {
      setState(() {
        _message = S.of(context).unexpectedError;
      });
    } finally {
      if (!mounted) return;
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
      appBar: AppBar(title: Text(S.of(context).resetPasswordTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              S.of(context).resetPasswordInstruction,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: S.of(context).emailLabel),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                  onPressed: _resetPassword,
                  child: Text(S.of(context).resetButton),
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
