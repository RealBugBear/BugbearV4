import 'package:flutter/material.dart';
import 'package:bugbear_app/models/question.dart';
import 'package:bugbear_app/services/question_service.dart';

class QuizModel extends ChangeNotifier {
  final QuestionService _service = QuestionService();
  List<Question> questions = [];
  int currentIndex = 0;
  int yesCount = 0;

  Future<void> load(String locale) async {
    questions = await _service.loadQuestions(locale);
    currentIndex = 0;
    yesCount = 0;
    notifyListeners();
  }

  void answer(bool yes) {
    if (yes) yesCount++;
    notifyListeners();
  }

  void next(BuildContext context) {
    if (currentIndex + 1 < questions.length) {
      currentIndex++;
      notifyListeners();
    } else {
      Navigator.of(context).pushReplacementNamed('/results');
    }
  }

  double get percent =>
      questions.isEmpty ? 0.0 : (yesCount / questions.length) * 100;
}
