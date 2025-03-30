import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

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

  // currentCycle counts the number of cycles that have been started.
  // When no cycle has started, currentCycle == 0.
  int currentCycle = 0;
  int currentRound = 0;
  int remainingTime = 0;

  bool isRunning = false;
  bool isExercise = true;

  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Plays the "letsego" sound, waits for it to finish, then starts the exercise phase.
  Future<void> _startExercisePhase() async {
    print('Starting to play exercise sound...');
    final Completer<void> exerciseSoundCompleted = Completer<void>();
    _audioPlayer.onPlayerComplete.listen((event) {
      if (!exerciseSoundCompleted.isCompleted) {
        print('Exercise sound complete event received.');
        exerciseSoundCompleted.complete();
      }
    });
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
        _startPausePhaseWithSound();
      }
    });
  }

  // Plays the pause sound, waits for it to complete, then starts the pause timer.
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
          // End of cycle: play success sound then show dialog.
          _playSuccessSoundThenShowDialog();
          setState(() {
            isRunning = false;
          });
        }
      }
    });
  }

  // Plays the "greatsuccess" sound and, when finished, shows the cycle finished dialog.
  Future<void> _playSuccessSoundThenShowDialog() async {
    print('Starting to play success sound...');
    final Completer<void> successSoundCompleted = Completer<void>();
    _audioPlayer.onPlayerComplete.listen((event) {
      if (!successSoundCompleted.isCompleted) {
        print('Success sound complete event received.');
        successSoundCompleted.complete();
      }
    });
    await _audioPlayer.play(AssetSource('sounds/greatsuccess.mp3'));
    print('Waiting for success sound to complete...');
    await successSoundCompleted.future;
    print('Success sound completed. Showing cycle finished dialog.');
    _showCycleFinishedDialog();
  }

  // Starts a new cycle by initiating the exercise phase.
  void _startCycle() {
    if (isRunning || currentCycle >= totalCycles) return;
    setState(() {
      currentCycle++; // Increment cycle count when starting.
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
    // Determine which image to display:
    // - When a cycle is active, show the current cycle's image.
    // - When not running, show the image for the upcoming cycle.
    int imageCycle;
    if (isRunning) {
      imageCycle = currentCycle;
    } else {
      // If no cycle has started, upcoming cycle is 1; otherwise, use currentCycle + 1 (up to totalCycles).
      imageCycle = currentCycle < totalCycles ? currentCycle + 1 : totalCycles;
    }
    String cycleImagePath = 'assets/images/spin$imageCycle.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spinalergalant Trainer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Display the image for the current/upcoming cycle.
            Image.asset(cycleImagePath, width: 200, height: 200),
            const SizedBox(height: 20),
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
                child: Text("▶️ Start Zyklus ${currentCycle < totalCycles ? currentCycle + 1 : totalCycles}"),
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
