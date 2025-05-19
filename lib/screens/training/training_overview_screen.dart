// File: lib/screens/training/training_overview_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bugbear_app/services/training_service.dart';
import 'package:bugbear_app/models/session.dart';

class TrainingOverviewScreen extends StatefulWidget {
  const TrainingOverviewScreen({Key? key}) : super(key: key);

  @override
  TrainingOverviewScreenState createState() => TrainingOverviewScreenState();
}

class TrainingOverviewScreenState extends State<TrainingOverviewScreen> {
  bool _isLoading = true;
  String? _error;
  List<SessionModel> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    try {
      final service = context.read<TrainingService>();
      final sessions = await service.fetchSessions();
      if (!mounted) return;
      setState(() {
        _sessions = sessions;
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
    return Scaffold(
      appBar: AppBar(title: const Text('Trainingübersicht')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Fehler: $_error'))
              : ListView.builder(
                  itemCount: _sessions.length,
                  itemBuilder: (context, i) {
                    final s = _sessions[i];
                    final dateStr = s.date
                        .toLocal()
                        .toIso8601String()
                        .split('T')
                        .first;
                    final count = s.completedExercises?.length ?? 0;
                    return ListTile(
                      title: Text('Session am $dateStr'),
                      subtitle: Text('Übungen: $count'),
                      onTap: () {
                        // Navigation ggf. ergänzen
                      },
                    );
                  },
                ),
    );
  }
}
