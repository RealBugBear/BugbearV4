// File: lib/screens/results_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bugbear_app/models/quiz_model.dart';
import 'package:bugbear_app/generated/l10n.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).resultHeader),
      ),
      body: Consumer<QuizModel>(
        builder: (context, quizModel, _) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quizModel.categories.length,
            itemBuilder: (context, index) {
              final category = quizModel.categories[index];
              final percentage = category.score.clamp(0.0, 100.0);
              return ListTile(
                title: Text(category.name),
                subtitle: Text('${percentage.toStringAsFixed(2)} %'),
                trailing: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
