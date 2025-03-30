import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class MoroTrainerScreen extends StatefulWidget {
  const MoroTrainerScreen({super.key});

  @override
  State<MoroTrainerScreen> createState() => _MoroTrainerScreenState();
}

class _MoroTrainerScreenState extends State<MoroTrainerScreen> {
  static const int totalCycles = 8;
  static const int totalRounds = 6;
  static const int exerciseDuration = 7;
  static const int pauseDuration = 3;

  int currentCycle = 0;
  int currentRound = 0;
  int remainingTime = 0;

  bool isRunning = false;
  bool isExercise = true;

  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Plays the "letsego" sound and then starts the exercise timer.
  Future<void> _startExercisePhase() async {
    print('Starting to play exercise sound...');
    final Completer<void> exerciseSoundCompleted = Completer<void>();
    _audioPlayer.onPlayerComplete.listen((event) {
      if (!exerciseSoundCompleted.isCompleted) {
        print('Exercise sound complete event received.');
        exerciseSoundCompleted.complete();
      }
    });
    // Provide the asset path relative to the assets folder.
    await _audioPlayer.play(AssetSource('sounds/letsego.mp3'));
    print('Waiting for exercise sound to complete...');
    await exerciseSoundCompleted.future;
    print('Exercise sound completed. Starting exercise timer.');

    setState(() {
      remainingTime = exerciseDuration;
      isExercise = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        // When exercise phase finishes, play pause sound first.
        _startPausePhaseWithSound();
      }
    });
  }

  // Plays the pause sound, waits for it to finish, then starts the pause timer.
  Future<void> _startPausePhaseWithSound() async {
    print('Starting to play pause sound...');
    final Completer<void> pauseSoundCompleted = Completer<void>();
    _audioPlayer.onPlayerComplete.listen((event) {
      if (!pauseSoundCompleted.isCompleted) {
        print('Pause sound complete event received.');
        pauseSoundCompleted.complete();
      }
    });
    await _audioPlayer.play(AssetSource('sounds/daddychill.mp3'));
    print('Waiting for pause sound to complete...');
    await pauseSoundCompleted.future;
    print('Pause sound completed. Starting pause timer.');

    setState(() {
      isExercise = false;
      remainingTime = pauseDuration;
    });
    _startPauseTimer();
  }

  // Starts the pause timer countdown.
  void _startPauseTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        if (currentRound < totalRounds) {
          setState(() {
            currentRound++;
          });
          _startExercisePhase();
        } else {
          _showCycleFinishedDialog();
          setState(() {
            isRunning = false;
          });
        }
      }
    });
  }

  // Starts a new cycle by initiating the exercise phase.
  void _startCycle() {
    if (isRunning || currentCycle >= totalCycles) return;
    setState(() {
      currentCycle++;
      currentRound = 1;
      isRunning = true;
    });
    _startExercisePhase();
  }

  void _resetAll() {
    _timer?.cancel();
    setState(() {
      currentCycle = 0;
      currentRound = 0;
      remainingTime = 0;
      isRunning = false;
      isExercise = true;
    });
  }

  void _showCycleFinishedDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Zyklus $currentCycle abgeschlossen"),
        content: currentCycle < totalCycles
            ? const Text("Drücke START für den nächsten Zyklus.")
            : const Text("Alle 8 Zyklen abgeschlossen! 🎉"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (currentCycle >= totalCycles) {
                _resetAll();
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moro Trainer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              "Zyklus: $currentCycle von $totalCycles",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              isRunning ? "Runde: $currentRound von $totalRounds" : "",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              isRunning
                  ? (isExercise ? "Übung läuft" : "Pause")
                  : "Bereit für Start",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "$remainingTime Sekunden",
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            if (!isRunning && currentCycle < totalCycles)
              ElevatedButton(
                onPressed: _startCycle,
                child: Text("▶️ Start Zyklus ${currentCycle + 1}"),
              ),
            if (!isRunning && currentCycle == totalCycles)
              ElevatedButton(
                onPressed: _resetAll,
                child: const Text("🔄 Alles zurücksetzen"),
              ),
          ],
        ),
      ),
    );
  }
}
