// File: lib/models/quiz_question.dart

/// Repräsentiert eine Quizfrage aus den JSON-Assets.
class QuizQuestion {
  final String question;
  final List<String>? options;

  QuizQuestion({
    required this.question,
    this.options,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      question: map['question'] as String,
      options: map['options'] != null
          ? List<String>.from(map['options'] as List<dynamic>)
          : null,
    );
  }
}
