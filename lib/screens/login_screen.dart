import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bugbear_app/widgets/custom_text_field.dart';
import 'package:bugbear_app/core/widgets/custom_button.dart';
import 'package:bugbear_app/generated/l10n.dart';

class LoginScreen extends StatefulWidget {
  // Injected FirebaseAuth for easier testing
  final FirebaseAuth auth;

  // Removed 'const' since auth cannot be a compile-time constant
  LoginScreen({
    Key? key,
    FirebaseAuth? auth,
  })  : auth = auth ?? FirebaseAuth.instance,
        super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FirebaseAuth _auth;

  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _auth = widget.auth;
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/profile');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.message ?? S.of(context).loginErrorDefault;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        errorMessage = S.of(context).unknownError;
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _register() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/profile');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.message ?? S.of(context).registrationErrorDefault;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        errorMessage = S.of(context).unknownError;
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
      appBar: AppBar(title: Text(S.of(context).loginTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CustomTextField(
              label: S.of(context).emailLabel,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: S.of(context).passwordLabel,
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    text: S.of(context).loginButton,
                    onPressed: _login,
                  ),
                  CustomButton(
                    text: S.of(context).registerButton,
                    onPressed: _register,
                  ),
                ],
              ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/reset-password');
              },
              child: Text(S.of(context).forgotPassword),
            ),
          ],
        ),
      ),
    );
  }
}
