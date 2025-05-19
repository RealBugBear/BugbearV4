// File: lib/services/quiz_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:bugbear_app/models/quiz_question.dart';

/// QuizService lädt Fragen aus JSON-Assets und speichert/spielt Antworten ab.
class QuizService {
  /// Lädt die Quiz-Fragen aus assets/quiz_questions_<lang>.json
  Future<List<QuizQuestion>> fetchQuizQuestions(
    String language,
  ) async {
    final path = 'assets/quiz_questions_$language.json';
    final jsonStr = await rootBundle.loadString(path);
    final List<dynamic> data = json.decode(jsonStr) as List<dynamic>;
    return data
        .map((e) => QuizQuestion.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  /// Speichert die Antworten (kann nach Bedarf an Firestore angebunden werden)
  Future<void> submitQuizAnswers(
    String quizId,
    Map<String, dynamic> answers,
  ) async {
    // TODO: Firestore-Speicherung z.B. unter users/{uid}/quizzes/{quizId}
  }

  /// Liest die Ergebnisse (kann berechnet oder aus Firestore geladen werden)
  Future<Map<String, dynamic>> fetchResults(
    String quizId,
  ) async {
    // TODO: Implementieren: z.B. aus Firestore oder lokal berechnen
    return <String, dynamic>{};
  }
}
