// test/screens/login_screen_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:bugbear_app/generated/l10n.dart';
import 'package:bugbear_app/core/widgets/custom_button.dart';
import 'package:bugbear_app/screens/login_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginScreen Widget Tests', () {
    late MockFirebaseAuth mockAuth;

    setUp(() {
      // We don't need a signed-in user here—the login screen shows fields regardless.
      mockAuth = MockFirebaseAuth(signedIn: false);
    });

    testWidgets('renders email & password fields and action buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: LoginScreen(auth: mockAuth),
        ),
      );
      await tester.pumpAndSettle();

      // Two underlying TextFields
      expect(find.byType(TextField), findsNWidgets(2));

      // Buttons labelled by your localized strings
      expect(find.widgetWithText(CustomButton, S.current.loginButton),
          findsOneWidget,);
      expect(find.widgetWithText(CustomButton, S.current.registerButton),
          findsOneWidget,);
    });
  });
}
