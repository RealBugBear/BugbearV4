import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingSession {
  final String id;
  final String userId;
  final String trainingType; // e.g. "spinalergalant" or "moro"
  final DateTime sessionDate;

  TrainingSession({
    required this.id,
    required this.userId,
    required this.trainingType,
    required this.sessionDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'trainingType': trainingType,
      'sessionDate': Timestamp.fromDate(sessionDate),
    };
  }

  factory TrainingSession.fromMap(String id, Map<String, dynamic> map) {
    return TrainingSession(
      id: id,
      userId: map['userId'],
      trainingType: map['trainingType'],
      sessionDate: (map['sessionDate'] as Timestamp).toDate(),
    );
  }
}
