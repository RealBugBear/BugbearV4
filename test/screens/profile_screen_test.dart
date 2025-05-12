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
import 'package:bugbear_app/models/user_program.dart';
import 'package:bugbear_app/models/training_data.dart';
import 'package:intl/intl.dart';

/// FakeService erbt von TrainingService und stubbt nur die benötigten Methoden.
class FakeTrainingService extends TrainingService {
  @override
  Stream<List<TrainingSession>> getAllTrainingSessions({
    required String userId,
  }) =>
      Stream.value(<TrainingSession>[]);

  @override
  Stream<List<TrainingSession>> getTrainingSessions({
    required String userId,
    required String trainingType,
  }) =>
      Stream.value(<TrainingSession>[]);

  @override
  Future<void> logTrainingSession({
    required String userId,
    required String trainingType,
  }) async {
    // no-op
  }

  @override
  Future<void> setActiveProgram(
    String uid,
    String programId,
    DateTime startDate,
  ) async {
    // no-op
  }

  @override
  Stream<UserProgram> watchUserProgram(String uid) => Stream.value(
        UserProgram(
          activeProgramId: allPrograms.first.id,
          programStartDate: DateTime.now(),
          skippedWeekdays: 0,
        ),
      );

  @override
  String currentUid() => 'test-uid';

  @override
  TrainingProgram getProgramById(String id) => allPrograms.first;
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
        final user = MockUser(uid: 'abc123');
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

        // Mindestens eine Table (Kalender)
        expect(find.byType(Table), findsWidgets);

        // Monatsname wird angezeigt
        final currentMonth = DateFormat.MMMM('en').format(DateTime.now());
        expect(find.text(currentMonth), findsWidgets);
      },
    );
  });
}
