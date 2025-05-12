// lib/models/training_data.dart

import 'package:flutter/foundation.dart';

/// Repräsentiert ein Trainingsprogramm mit einer eindeutigen ID,
/// einem Anzeigenamen, der Anzahl geplanter Trainingstage und der Dauer.
@immutable
class TrainingProgram {
  /// Eindeutige Kennung, muss mit `users/{uid}.activeProgramId` übereinstimmen.
  final String id;

  /// Anzeigename in der Benutzeroberfläche.
  final String name;

  /// Anzahl der geplanten Trainingstage (Sessions).
  final int plannedSessions;

  /// Geschätzte Dauer des Programms (z. B. 30 Tage).
  final Duration duration;

  /// Konst‐Konstruktor für Unveränderbarkeit und Performance.
  const TrainingProgram({
    required this.id,
    required this.name,
    required this.plannedSessions,
    required this.duration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainingProgram &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          plannedSessions == other.plannedSessions &&
          duration == other.duration;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      plannedSessions.hashCode ^
      duration.hashCode;

  @override
  String toString() =>
      'TrainingProgram(id: $id, name: $name, sessions: $plannedSessions, duration: $duration)';
}

/// Alle verfügbaren Trainingsprogramme.
/// Zum Hinzufügen: einfach neuen Eintrag ergänzen.
const List<TrainingProgram> allPrograms = <TrainingProgram>[
  TrainingProgram(
    id: 'moro_flr',
    name: 'Moro & FLR',
    plannedSessions: 20,
    duration: Duration(days: 30),
  ),
  TrainingProgram(
    id: 'tlr',
    name: 'TLR',
    plannedSessions: 20,
    duration: Duration(days: 30),
  ),
  TrainingProgram(
    id: 'stnr',
    name: 'STNR',
    plannedSessions: 20,
    duration: Duration(days: 30),
  ),
  TrainingProgram(
    id: 'spinaler_galant_amphibien',
    name: 'Spinaler Galant & Amphibienreflex',
    plannedSessions: 20,
    duration: Duration(days: 30),
  ),
  TrainingProgram(
    id: 'landau',
    name: 'Landau',
    plannedSessions: 20,
    duration: Duration(days: 30),
  ),
  TrainingProgram(
    id: 'babinski',
    name: 'Babinski',
    plannedSessions: 20,
    duration: Duration(days: 30),
  ),
  TrainingProgram(
    id: 'atnr',
    name: 'ATNR',
    plannedSessions: 20,
    duration: Duration(days: 30),
  ),
  TrainingProgram(
    id: 'babkin_plantar_greif',
    name: 'Babkin & Plantar & Greifreflex',
    plannedSessions: 20,
    duration: Duration(days: 30),
  ),
  TrainingProgram(
    id: 'such_saug',
    name: 'Such-Saug-Reflex',
    plannedSessions: 20,
    duration: Duration(days: 30),
  ),
  TrainingProgram(
    id: 'vorbereitung',
    name: 'Vorbereitung',
    plannedSessions: 20,
    duration: Duration(days: 30),
  ),
];
