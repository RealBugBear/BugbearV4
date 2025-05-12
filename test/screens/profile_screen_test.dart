// test/screens/profile_screen_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'package:bugbear_app/firebase_options.dart';
import 'package:bugbear_app/generated/l10n.dart';
import 'package:bugbear_app/screens/profile_screen.dart';
import 'package:bugbear_app/services/training_service.dart';
import 'package:bugbear_app/services/local_storage_service.dart';

// Bring in the model types and data:
import 'package:bugbear_app/models/training_session.dart';
import 'package:bugbear_app/models/user_program.dart';
import 'package:bugbear_app/models/training_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (_) {
      // already initialized
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
      (tester) async {
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
              localStorage: FakeLocalStorageService(),
              auth: mockAuth,
            ),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(
          find.text(S.of(tester.element(find.byType(ProfileScreen))).userNotLoggedIn),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders calendar when user is logged in',
      (tester) async {
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
              localStorage: FakeLocalStorageService(),
              auth: mockAuth,
            ),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Verify the calendar widget is present
        expect(find.byType(TableCalendar), findsOneWidget);

        // Verify the current month name appears in the header (may include year)
        final currentMonth = DateFormat.MMMM('en').format(DateTime.now());
        expect(find.textContaining(currentMonth), findsWidgets);
      },
    );
  });
}

/// A stub implementation that never touches Firebase, Firestore, or Hive.
class FakeTrainingService implements TrainingService {
  @override
  Stream<List<TrainingSession>> getAllTrainingSessions({required String userId}) =>
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
  }) async {}

  @override
  Future<void> setActiveProgram(String uid, String programId, DateTime startDate) async {}

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

  @override
  Future<void> deleteAllSessions(String uid) async {}

  @override
  Future<void> updateSkipped(String uid, int skipped) async {}
}

/// A stub implementation of LocalStorageService that never opens Hive.
class FakeLocalStorageService implements LocalStorageService {
  @override
  Future<void> init() async {}

  @override
  UserProgram? loadUserProgram() => UserProgram(
        activeProgramId: allPrograms.first.id,
        programStartDate: DateTime.now(),
        skippedWeekdays: 0,
      );

  @override
  Set<DateTime> loadCompletedDates() => <DateTime>{};

  @override
  DateTime? loadLastDaily() => null;

  @override
  DateTime? loadLastWeekly() => null;

  @override
  List<Map<String, dynamic>> loadQuizResults() => <Map<String, dynamic>>[];

  @override
  Future<void> saveUserProgram(UserProgram up) async {}

  @override
  Future<void> clearAll() async {}

  @override
  Future<void> clearCompletedDates() async {}

  @override
  Future<void> saveCompletedDates(Set<DateTime> dates) async {}

  @override
  Future<void> saveLastDaily(DateTime date) async {}

  @override
  Future<void> saveLastWeekly(DateTime date) async {}

  @override
  Future<void> saveQuizResults(List<Map<String, dynamic>> results) async {}
}
