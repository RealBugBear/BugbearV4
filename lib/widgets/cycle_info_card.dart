import 'package:flutter/material.dart';

class CycleInfoCard extends StatelessWidget {
  final int currentCycle;
  final int totalCycles;
  final int currentRound;
  final int totalRounds;
  final int remainingTime;
  final bool isRunning;
  final bool isExercise;

  const CycleInfoCard({
    super.key,
    required this.currentCycle,
    required this.totalCycles,
    required this.currentRound,
    required this.totalRounds,
    required this.remainingTime,
    required this.isRunning,
    required this.isExercise,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Zyklus: $currentCycle von $totalCycles',
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          isRunning ? 'Runde: $currentRound von $totalRounds' : '',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        Text(
          isRunning
              ? (isExercise ? 'Übung läuft' : 'Pause')
              : 'Bereit für Start',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          '$remainingTime Sekunden',
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
