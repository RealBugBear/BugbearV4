// File: lib/screens/quiz/quiz_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bugbear_app/services/quiz_service.dart';
import 'package:bugbear_app/models/quiz_question.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  bool _isLoading = true;
  String? _error;
  List<QuizQuestion> _questions = [];
  final Map<String, dynamic> _answers = {};

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final service = context.read<QuizService>();
      final qs = await service.fetchQuizQuestions('de');
      if (!mounted) return;
      setState(() {
        _questions = qs;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _submitQuiz() async {
    setState(() => _isLoading = true);
    try {
      final service = context.read<QuizService>();
      await service.submitQuizAnswers('defaultQuiz', _answers);
      if (!mounted) return;
      Navigator.pushNamed(
        context,
        '/quiz/results',
        arguments: 'defaultQuiz',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: Center(child: Text('Fehler: $_error')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _questions.length,
        itemBuilder: (context, i) {
          final q = _questions[i];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Frage ${i + 1}: ${q.question}'),
              const SizedBox(height: 8),
              if (q.options != null)
                ...List.generate(
                  q.options!.length,
                  (j) => RadioListTile<String>(
                    title: Text(q.options![j]),
                    value: q.options![j],
                    groupValue: _answers['$i'] as String?,
                    onChanged: (v) => setState(() => _answers['$i'] = v),
                  ),
                )
              else
                TextField(
                  decoration: const InputDecoration(labelText: 'Antwort'),
                  onChanged: (v) => _answers['$i'] = v,
                ),
              const Divider(),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _submitQuiz,
          child: const Text('Quiz abschicken'),
        ),
      ),
    );
  }
}
