// lib/screens/quiz_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bugbear_app/models/quiz_model.dart';
import 'package:bugbear_app/services/local_storage_service.dart';
import 'package:bugbear_app/generated/l10n.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      final lang = Localizations.localeOf(context).languageCode;
      context.read<QuizModel>().loadAll(lang);
    }
  }

  Future<void> _onAnswer(bool yes) async {
    final quizModel = context.read<QuizModel>();
    quizModel.answerCurrent(yes);

    final isLast = quizModel.currentIndex + 1 == quizModel.questions.length;
    if (!isLast) {
      quizModel.next(context);
      return;
    }

    quizModel.calculateScores();

    // Sicherstellen, dass der Kontext noch gemountet ist
    if (!mounted) return;

    final save = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(S.of(dialogCtx).quizTitle),
        content: const Text('Möchten Sie das Ergebnis speichern?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(S.of(dialogCtx).no),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: Text(S.of(dialogCtx).yes),
          ),
        ],
      ),
    );

    if (save == true) {
      final localStorage = context.read<LocalStorageService>();
      final jsonList = quizModel.categories
          .map((c) => {'id': c.id, 'name': c.name, 'score': c.score})
          .toList();
      await localStorage.saveQuizResults(jsonList);
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(
      save == true ? '/reflex_profile' : '/results',
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizModel = context.watch<QuizModel>();

    if (quizModel.questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final current = quizModel.questions[quizModel.currentIndex];
    final lang = Localizations.localeOf(context).languageCode;
    final questionText = current.text[lang] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${S.of(context).quizTitle} ${quizModel.currentIndex + 1}/${quizModel.questions.length}',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (quizModel.currentIndex + 1) /
                  quizModel.questions.length,
              minHeight: 8,
              backgroundColor:
                  Theme.of(context).colorScheme.surface.withAlpha(30),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              S.of(context).quizProgress(
                    quizModel.currentIndex + 1,
                    quizModel.questions.length,
                  ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text(
              questionText,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _onAnswer(true),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(S.of(context).yes),
                ),
                ElevatedButton(
                  onPressed: () => _onAnswer(false),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(S.of(context).no),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
