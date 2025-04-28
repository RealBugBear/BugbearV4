// test/screens/profile_screen_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bugbear_app/firebase_options.dart';
import 'package:bugbear_app/generated/l10n.dart';
import 'package:bugbear_app/screens/profile_screen.dart';
import 'package:bugbear_app/services/training_service.dart';
import 'package:bugbear_app/models/training_session.dart';
import 'package:intl/intl.dart';

/// Fake service still returns no sessions, but calendar will render empty cells.
class FakeTrainingService implements TrainingService {
  @override
  Stream<List<TrainingSession>> getAllTrainingSessions({
    required String userId,
  }) =>
      Stream.value(<TrainingSession>[]);

  @override
  Stream<List<TrainingSession>> getTrainingSessions({
    required String trainingType,
    required String userId,
  }) =>
      Stream.value(<TrainingSession>[]);

  @override
  Future<void> logTrainingSession({
    required String trainingType,
    required String userId,
  }) async {
    // no-op
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (_) {
      // ignore
    }
  });

  group('ProfileScreen Widget Tests', () {
    late MockFirebaseAuth mockAuth;
    late FakeTrainingService fakeService;

    setUp(() {
      fakeService = FakeTrainingService();
    });

    testWidgets(
      'displays not-logged-in UI when no user is authenticated',
      (WidgetTester tester) async {
        mockAuth = MockFirebaseAuth(signedIn: false);

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
            home: ProfileScreen(
              trainingService: fakeService,
              auth: mockAuth,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(S.current.userNotLoggedIn), findsOneWidget);
      },
    );

    testWidgets(
      'renders calendar when user is logged in',
      (WidgetTester tester) async {
        // Arrange: mock a signed-in user
        final user = MockUser(uid: 'abc123', displayName: 'Tester');
        mockAuth = MockFirebaseAuth(signedIn: true, mockUser: user);

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
            home: ProfileScreen(
              trainingService: fakeService,
              auth: mockAuth,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert: at least one Table (the calendar) is present
        expect(find.byType(Table), findsWidgets);

        // And the current month’s name appears
        final currentMonth = DateFormat.MMMM('en').format(DateTime.now());
        expect(find.text(currentMonth), findsWidgets);
      },
    );
  });
}
