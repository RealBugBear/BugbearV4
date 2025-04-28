import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:bugbear_app/models/question.dart';

class QuestionService {
  /// Lädt alle Fragen für die angegebene Locale ('de' oder 'en').
  Future<List<Question>> loadQuestions(String locale) async {
    final raw = await rootBundle.loadString('assets/fragen_${locale}.json');
    final list = json.decode(raw) as List<dynamic>;
    return list
        .map((e) => Question.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
