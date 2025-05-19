/// lib/models/exercise.dart
class ExerciseModel {
  final String id;
  final String programId;
  final String title;
  final String? description;
  final int? durationSeconds;

  ExerciseModel({
    required this.id,
    required this.programId,
    required this.title,
    this.description,
    this.durationSeconds,
  });

  factory ExerciseModel.fromMap(Map<String, dynamic> data, String docId) {
    return ExerciseModel(
      id: docId,
      programId: data['programId'] as String,
      title: data['title'] as String,
      description: data['description'] as String?,
      durationSeconds: data['durationSeconds'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
    'programId': programId,
    'title': title,
    'description': description,
    'durationSeconds': durationSeconds,
  };
}
