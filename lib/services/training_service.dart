import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bugbear_app/models/training_session.dart';
import 'package:bugbear_app/models/user_program.dart';
import 'package:bugbear_app/models/training_data.dart';

class TrainingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Setzt oder aktualisiert das aktive Programm.
  Future<void> setActiveProgram(
    String uid,
    String programId,
    DateTime startDate,
  ) async {
    final doc = _firestore.collection('users').doc(uid);
    await doc.set({
      'activeProgramId': programId,
      'programStartDate': Timestamp.fromDate(startDate),
      'skippedWeekdays': 0,
    }, SetOptions(merge: true),);
    debugPrint('setActiveProgram → $uid / $programId @ $startDate');
  }

  /// Beobachtet UserProgram in Firestore.
  Stream<UserProgram> watchUserProgram(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) => UserProgram.fromSnapshot(snap));
  }

  /// Loggt eine Trainingseinheit (einmal täglich).
  Future<void> logTrainingSession({
    required String userId,
    required String trainingType,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final ts = Timestamp.fromDate(today);

    final qs = await _firestore
        .collection('trainingSessions')
        .where('userId', isEqualTo: userId)
        .where('trainingType', isEqualTo: trainingType)
        .where('sessionDate', isEqualTo: ts)
        .get();

    if (qs.docs.isEmpty) {
      await _firestore.collection('trainingSessions').add({
        'userId': userId,
        'trainingType': trainingType,
        'sessionDate': ts,
      });
      debugPrint('Training logged: $trainingType @ $today');
    }
  }

  /// Alle Sessions eines Users.
  Stream<List<TrainingSession>> getAllTrainingSessions({
    required String userId,
  }) {
    return _firestore
        .collection('trainingSessions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => TrainingSession.fromMap(d.id, d.data())).toList(),);
  }

  /// Sessions eines Users nach Typ.
  Stream<List<TrainingSession>> getTrainingSessions({
    required String userId,
    required String trainingType,
  }) {
    return _firestore
        .collection('trainingSessions')
        .where('userId', isEqualTo: userId)
        .where('trainingType', isEqualTo: trainingType)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => TrainingSession.fromMap(d.id, d.data())).toList(),);
  }

  /// Löscht alle Sessions eines Users.
  Future<void> deleteAllSessions(String userId) async {
    final qs = await _firestore
        .collection('trainingSessions')
        .where('userId', isEqualTo: userId)
        .get();
    final batch = _firestore.batch();
    for (var doc in qs.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    debugPrint('deleteAllSessions → $userId');
  }

  /// Aktuelle User-ID.
  String currentUid() {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) throw StateError('No user logged in');
    return u.uid;
  }

  /// Holt Programm-Daten aus training_data.dart.
  TrainingProgram getProgramById(String id) {
    return allPrograms.firstWhere(
      (p) => p.id == id,
      orElse: () => throw ArgumentError('Program $id not found'),
    );
  }

  /// Aktualisiert skippedWeekdays in Firestore.
  Future<void> updateSkipped(String uid, int skipped) {
    return _firestore.collection('users').doc(uid).update({
      'skippedWeekdays': skipped,
    });
  }
}
