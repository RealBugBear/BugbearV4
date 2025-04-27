import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bugbear_app/models/training_session.dart';

class TrainingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logTrainingSession({
    required String userId,
    required String trainingType,
  }) async {
    // Normalize to just the date (year, month, day)
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    // Query if a session for this training and day already exists.
    // Note: Use the generic type <Map<String, dynamic>> for QuerySnapshot.
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore
            .collection('trainingSessions')
            .where('userId', isEqualTo: userId)
            .where('trainingType', isEqualTo: trainingType)
            .where('sessionDate', isEqualTo: Timestamp.fromDate(today))
            .get();

    if (querySnapshot.docs.isEmpty) {
      await _firestore.collection('trainingSessions').add({
        'userId': userId,
        'trainingType': trainingType,
        'sessionDate': Timestamp.fromDate(today),
      });
      debugPrint("Training session logged for $trainingType on $today");
    } else {
      debugPrint(
        "Training session for $trainingType already logged for today.",
      );
    }
  }

  Stream<List<TrainingSession>> getTrainingSessions({
    required String userId,
    required String trainingType,
  }) {
    return _firestore
        .collection('trainingSessions')
        .where('userId', isEqualTo: userId)
        .where('trainingType', isEqualTo: trainingType)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => TrainingSession.fromMap(doc.id, doc.data()))
                  .toList(),
        );
  }

  // For overall progress calendar (all training types)
  Stream<List<TrainingSession>> getAllTrainingSessions({
    required String userId,
  }) {
    return _firestore
        .collection('trainingSessions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => TrainingSession.fromMap(doc.id, doc.data()))
                  .toList(),
        );
  }
}
