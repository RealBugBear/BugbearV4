// lib/models/user_program.dart

import 'package:cloud_firestore/cloud_firestore.dart';

/// Mapping des Firestore-Dokuments /users/{uid}
class UserProgram {
  /// Entspricht dem Feld `activeProgramId` in Firestore
  final String activeProgramId;

  /// Entspricht dem Feld `programStartDate` in Firestore
  final DateTime programStartDate;

  /// Entspricht dem Feld `skippedWeekdays` in Firestore
  final int skippedWeekdays;

  UserProgram({
    required this.activeProgramId,
    required this.programStartDate,
    required this.skippedWeekdays,
  });

  /// Erzeugt ein UserProgram aus Firestore-Daten
  factory UserProgram.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snap,) {
    final data = snap.data()!;
    return UserProgram(
      activeProgramId: data['activeProgramId'] as String,
      programStartDate: (data['programStartDate'] as Timestamp).toDate(),
      skippedWeekdays: data['skippedWeekdays'] as int,
    );
  }

  /// Zum Serialisieren (falls benötigt)
  Map<String, dynamic> toMap() => {
        'activeProgramId': activeProgramId,
        'programStartDate': Timestamp.fromDate(programStartDate),
        'skippedWeekdays': skippedWeekdays,
      };
}
