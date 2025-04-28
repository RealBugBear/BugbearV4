// File: test/widget_basic_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:bugbear_app/main.dart';
import 'package:flutter/material.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockUser = MockUser(uid: 'test-uid', email: 'test@example.com');
  final mockAuth = MockFirebaseAuth(mockUser: mockUser);

  group('Basic widget tests', () {
    testWidgets('Shows profile when user is signed in', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RootScreen(auth: mockAuth),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Profile'), findsOneWidget);
    });
  });
}
