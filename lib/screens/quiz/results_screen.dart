// File: lib/screens/quiz/results_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bugbear_app/services/quiz_service.dart';

class ResultsScreen extends StatefulWidget {
  final String quizId;
  const ResultsScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  ResultsScreenState createState() => ResultsScreenState();
}

class ResultsScreenState extends State<ResultsScreen> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _results;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    try {
      final service = context.read<QuizService>();
      final res = await service.fetchResults(widget.quizId);
      if (!mounted) return;
      setState(() {
        _results = res;
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ergebnisse')),
        body: Center(child: Text('Fehler: $_error')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Ergebnisse')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _results!.entries.map((e) {
          return ListTile(
            title: Text(e.key),
            trailing: Text(e.value.toString()),
          );
        }).toList(),
      ),
    );
  }
}
