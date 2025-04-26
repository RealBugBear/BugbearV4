// training_data.dart
class TrainingProgram {
  final String id;             // Eindeutige Programm-ID
  final String name;           // Name des Programms
  DateTime lastTraining;       // Letzter Trainingszeitpunkt
  // Optional: Weitere Parameter, z.B. Schwierigkeitsgrad oder geplante Wiederholung
  final String? difficulty;    // Kann null sein, wenn nicht angegeben

  TrainingProgram({
    required this.id,
    required this.name,
    required this.lastTraining,
    this.difficulty,
  });

  // Optional: Eine Methode zum Aktualisieren des Trainingszeitpunkts, z.B. nach einem Training
  void updateTrainingTime(DateTime newTime) {
    lastTraining = newTime;
  }
}
