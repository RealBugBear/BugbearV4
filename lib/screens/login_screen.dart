import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bugbear_app/widgets/custom_text_field.dart';
import 'package:bugbear_app/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  bool isLoading = false;
  String errorMessage = '';
  
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
      // Navigate to home (profile) after successful login.
      Navigator.pushReplacementNamed(context, '/profile');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Login error';
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Unknown error';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
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
      Navigator.pushReplacementNamed(context, '/profile');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Registration error';
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Unknown error';
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
            CustomTextField(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Password',
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
                      CustomButton(
                        text: 'Login',
                        onPressed: _login,
                      ),
                      CustomButton(
                        text: 'Register',
                        onPressed: _register,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
