// File: lib/services/training_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bugbear_app/models/session.dart';

/// TrainingService kümmert sich um das Anlegen und Laden von Trainings-Sessions.
class TrainingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<SessionModel>> fetchSessions() async {
    final uid = _auth.currentUser!.uid;
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .orderBy('date')
        .get();
    return snapshot.docs
        .map((doc) => SessionModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> createSession(
    DateTime date,
  ) async {
    final uid = _auth.currentUser!.uid;
    await _db
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .add({
      'userId':            uid,
      'date':              Timestamp.fromDate(date),
      'completedExercises': <String>[],
    });
  }

  Future<void> updateSession(
    String sessionId,
    Map<String, dynamic> updates,
  ) {
    final uid = _auth.currentUser!.uid;
    return _db
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .doc(sessionId)
        .update(updates);
  }
}
