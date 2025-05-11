import 'package:flutter/services.dart' show rootBundle;
import 'package:bugbear_app/models/quiz_question.dart';

/// Lädt quiz questions aus assets per Locale und parsed im Hintergrund-Isolate.
class LocalQuestionService {
  Future<List<QuizQuestion>> loadQuestions(String locale) async {
    // 1. Asset-Pfad anhand locale
    final fileName = 'assets/quiz_questions_${locale.toLowerCase()}.json';

    // 2. Rohes JSON einlesen
    final rawJson = await rootBundle.loadString(fileName);

    // 3. Parsing in Hintergrund-Isolate
    return await parseQuestionsIsolate(rawJson);
  }
}
