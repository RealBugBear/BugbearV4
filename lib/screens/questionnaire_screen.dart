import 'package:flutter/material.dart';

class QuestionnaireScreen extends StatelessWidget {
  const QuestionnaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Questionnaire")),
      body: const Center(child: Text("Questionnaire Screen")),
    );
  }
}
