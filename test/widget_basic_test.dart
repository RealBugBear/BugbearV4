// test/widget_basic_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:bugbear_app/services/local_storage_service.dart';
import 'package:bugbear_app/core/providers/locale_provider.dart';
import 'package:bugbear_app/models/quiz_model.dart';
import 'package:bugbear_app/screens/login_screen.dart';
import 'package:bugbear_app/screens/profile_screen.dart';

/// A test-only root that picks the screen synchronously from currentUser.
class TestRoot extends StatelessWidget {
  final FirebaseAuth auth;

  const TestRoot({Key? key, required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    return user != null
        ? ProfileScreen()   // no const here
        : LoginScreen();    // no const here
  }
}

void main() {
  testWidgets('App starts without errors', (tester) async {
    // 1) Create a mock auth that has no signed-in user
    final mockAuth = MockFirebaseAuth(signedIn: false);

    // 2) Init your real LocalStorageService (no Hive box opened)
    final localStorage = LocalStorageService();
    await localStorage.init();

    // 3) Build the app, overriding its home with TestRoot(auth: mockAuth)
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => QuizModel()),
          Provider<LocalStorageService>.value(value: localStorage),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: TestRoot(auth: mockAuth),
        ),
      ),
    );

    // 4) Let the first frame build, then a short delay
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // 5) Verify MaterialApp rendered and LoginScreen is shown
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
