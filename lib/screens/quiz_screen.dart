import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bugbear_app/providers/locale_provider.dart';
import 'package:bugbear_app/models/quiz_model.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late QuizModel model;
  late String locale;

  @override
  void initState() {
    super.initState();
    model = Provider.of<QuizModel>(context, listen: false);
    // null-sicherer Zugriff auf languageCode
    final lp = Provider.of<LocaleProvider>(context, listen: false);
    locale = lp.locale!.languageCode;
    model.load(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizModel>(
      builder: (ctx, qm, _) {
        if (qm.questions.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final q = qm.questions[qm.currentIndex];
        return Scaffold(
          appBar: AppBar(
            title: Text('Frage ${qm.currentIndex + 1}/${qm.questions.length}'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (qm.currentIndex + 1) / qm.questions.length,
                ),
                const SizedBox(height: 24),
                Text(
                  q.text[locale] ?? '',
                  style: const TextStyle(fontSize: 20),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        qm.answer(true);
                        qm.next(context);
                      },
                      child: const Text('Ja'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        qm.answer(false);
                        qm.next(context);
                      },
                      child: const Text('Nein'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
