// File: lib/screens/results_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bugbear_app/models/quiz_model.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quiz = Provider.of<QuizModel>(context);
    final answered = quiz.yesCount;
    final total = quiz.questions.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Center(
        child: Text('You answered $answered out of $total.'),
      ),
    );
  }
}
