import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quiz_question.g.dart';

/// A single quiz question, with localized text and linked reflex‐category IDs.
@JsonSerializable()
class QuizQuestion {
  final String id;
  final Map<String, String> text;
  final List<String> categoryIds;

  QuizQuestion({
    required this.id,
    required this.text,
    required this.categoryIds,
  });

  /// Factory, wird von json_serializable generiert.
  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);

  /// Serialisierung, wird von json_serializable generiert.
  Map<String, dynamic> toJson() => _$QuizQuestionToJson(this);
}

/// Top-Level-Funktion zum JSON-Parsing in einem Hintergrund-Isolate.
List<QuizQuestion> parseQuestions(String rawJson) {
  final List<dynamic> jsonList = jsonDecode(rawJson) as List<dynamic>;
  return jsonList
      .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
      .toList();
}

/// Async-Hilfsfunktion, die `parseQuestions` in einem Isolate ausführt.
Future<List<QuizQuestion>> parseQuestionsIsolate(String rawJson) =>
    compute(parseQuestions, rawJson);
