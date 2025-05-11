import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bugbear_app/models/quiz_model.dart';
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
      // Aktuelle Sprache ermitteln (z.B. "de" oder "en")
      final lang = Localizations.localeOf(context).languageCode;
      // Quiz-Daten laden
      context.read<QuizModel>().loadAll(lang);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizModel = context.watch<QuizModel>();

    // Noch keine Fragen geladen?
    if (quizModel.questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Daten liegen vor – aktuelle Frage anzeigen
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
            // Fortschrittsbalken
            LinearProgressIndicator(
              value: (quizModel.currentIndex + 1) /
                  quizModel.questions.length,
              minHeight: 8,
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .surface
                  .withAlpha((0.3 * 255).round()),
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            // Text mit aktuellem Fortschritt
            Text(
              S.of(context).quizProgress(
                quizModel.currentIndex + 1,
                quizModel.questions.length,
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            // Frage-Text
            Text(
              questionText,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            // Antwort-Buttons
            _AnswerButtons(
              onYes: () {
                quizModel.answerCurrent(true);
                quizModel.next(context);
              },
              onNo: () {
                quizModel.answerCurrent(false);
                quizModel.next(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerButtons extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;

  const _AnswerButtons({
    Key? key,
    required this.onYes,
    required this.onNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onYes,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          child: Text(S.of(context).yes),
        ),
        ElevatedButton(
          onPressed: onNo,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          child: Text(S.of(context).no),
        ),
      ],
    );
  }
}
