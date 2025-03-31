import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:bugbear_app/widgets/custom_button.dart';
import 'package:bugbear_app/widgets/cycle_info_card.dart';
import 'package:bugbear_app/widgets/timer_ring.dart' as timer_ring;

class SpinalergalantScreen extends StatefulWidget {
  const SpinalergalantScreen({super.key});

  @override
  State<SpinalergalantScreen> createState() => _SpinalergalantScreenState();
}

class _SpinalergalantScreenState extends State<SpinalergalantScreen> {
  static const int totalCycles = 4;
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

  Future<void> _startExercisePhase() async {
    debugPrint('Starting to play exercise sound...');
    final Completer<void> exerciseSoundCompleted = Completer<void>();
    _audioPlayer.onPlayerComplete.listen((event) {
      if (!exerciseSoundCompleted.isCompleted) {
        debugPrint('Exercise sound complete event received.');
        exerciseSoundCompleted.complete();
      }
    });
    await _audioPlayer.play(AssetSource('sounds/letsego.mp3'));
    debugPrint('Waiting for exercise sound to complete...');
    await exerciseSoundCompleted.future;
    debugPrint('Exercise sound completed. Starting exercise timer.');

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
        _startPausePhaseWithSound();
      }
    });
  }

  Future<void> _startPausePhaseWithSound() async {
    debugPrint('Starting to play pause sound...');
    final Completer<void> pauseSoundCompleted = Completer<void>();
    _audioPlayer.onPlayerComplete.listen((event) {
      if (!pauseSoundCompleted.isCompleted) {
        debugPrint('Pause sound complete event received.');
        pauseSoundCompleted.complete();
      }
    });
    await _audioPlayer.play(AssetSource('sounds/daddychill.mp3'));
    debugPrint('Waiting for pause sound to complete...');
    await pauseSoundCompleted.future;
    debugPrint('Pause sound completed. Starting pause timer.');

    setState(() {
      isExercise = false;
      remainingTime = pauseDuration;
    });
    _startPauseTimer();
  }

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

  Future<void> _showCycleFinishedDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Zyklus $currentCycle abgeschlossen"),
          content: currentCycle < totalCycles
              ? const Text("Drücke START für den nächsten Zyklus.")
              : const Text("Alle $totalCycles Zyklen abgeschlossen! 🎉"),
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
        );
      },
    );
  }

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

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = 0;
    if (isRunning) {
      progress = isExercise
          ? (exerciseDuration - remainingTime) / exerciseDuration
          : (pauseDuration - remainingTime) / pauseDuration;
      progress = progress.clamp(0, 1).toDouble();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spinalergalant Trainer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // TimerRing from timer_ring.dart
            timer_ring.TimerRing(
              progress: progress,
              size: 120,
              backgroundColor: Colors.grey.shade300,
              progressColor: isExercise ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 20),
            // Display cycle info using CycleInfoCard
            CycleInfoCard(
              currentCycle: currentCycle,
              totalCycles: totalCycles,
              currentRound: currentRound,
              totalRounds: totalRounds,
              remainingTime: remainingTime,
              isRunning: isRunning,
              isExercise: isExercise,
            ),
            const SizedBox(height: 30),
            if (!isRunning && currentCycle < totalCycles)
              CustomButton(
                text: "▶️ Start Zyklus ${currentCycle + 1}",
                onPressed: _startCycle,
              ),
            if (!isRunning && currentCycle >= totalCycles)
              CustomButton(
                text: "🔄 Alles zurücksetzen",
                onPressed: _resetAll,
              ),
          ],
        ),
      ),
    );
  }
}
