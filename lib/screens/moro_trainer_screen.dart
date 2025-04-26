import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bugbear_app/widgets/cycle_info_card.dart';
import 'package:bugbear_app/widgets/custom_button.dart';
import 'package:bugbear_app/widgets/timer_ring.dart' as timer_ring;
import 'package:bugbear_app/services/training_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bugbear_app/widgets/app_drawer.dart';
import 'package:bugbear_app/services/sound_manager.dart';

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
  final TrainingService _trainingService = TrainingService();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Index für Anzeige von Bild und Text:
  /// - Wenn gerade kein Zyklus läuft, Preview für nächsten Zyklus
  /// - Ansonsten aktueller Zyklus
  int get _displayCycleIndex {
    if (!isRunning && currentCycle > 0 && currentCycle < totalCycles) {
      return currentCycle + 1;
    }
    return currentCycle == 0 ? 1 : currentCycle;
  }

  /// Liefert den Asset-Pfad für das Bild des angezeigten Zyklus
  String _getImageAsset() {
    switch (_displayCycleIndex) {
      case 1:
        return 'assets/images/moro1.png';
      case 2:
        return 'assets/images/moro2.png';
      case 3:
      case 4:
        return 'assets/images/moro3u4.png';
      case 5:
        return 'assets/images/moro5.png';
      case 6:
        return 'assets/images/moro6.png';
      case 7:
        return 'assets/images/moro7.png';
      case 8:
        return 'assets/images/moro8.png';
      default:
        return '';
    }
  }

  /// Prompt-Text basierend auf Phase und Anzeige-Zyklus
  String _getPromptText() {
    final idx = _displayCycleIndex;
    if (!isRunning) {
      return 'Get into position for exercise $idx.';
    }
    return isExercise
        ? 'Exercise $idx in progress.'
        : 'Exercise $idx done.';
  }

  /// Startet einen neuen Zyklus (Trainingsserie)
  void _startCycle() {
    if (isRunning || currentCycle >= totalCycles) return;
    setState(() {
      currentCycle++;
      currentRound = 1;
      isRunning = true;
    });
    _startExercisePhase();
  }

  /// Beginnt die Übungsphase jeder Runde mit Start-Sound
  Future<void> _startExercisePhase() async {
    // 1) Start-Sound abspielen für jede Runde
    await SoundManager().playOnce(SoundType.start);

    // 2) UI-Update: Übung aktiv, Timer zurücksetzen
    setState(() {
      isExercise = true;
      remainingTime = exerciseDuration;
    });

    // 3) Tick-Sound starten
    SoundManager().startLoop(SoundType.tick);

    // 4) Countdown starten
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() => remainingTime--);
      } else {
        timer.cancel();
        SoundManager().stopLoop(SoundType.tick);
        setState(() => isExercise = false);
        _startPausePhase();
      }
    });
  }

  /// Beginnt die Pausenphase, spielt Pause-Sound nur einmal
  Future<void> _startPausePhase() async {
    setState(() {
      remainingTime = pauseDuration;
    });
    await SoundManager().playOnce(SoundType.pause);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() => remainingTime--);
      } else {
        timer.cancel();
        if (currentRound < totalRounds) {
          setState(() => currentRound++);
          _startExercisePhase();
        } else {
          _completeCycle();
        }
      }
    });
  }

  /// Nach Abschluss aller Runden: Ende-Sound, Logging, Dialog und Bild-Preview aktualisieren
  Future<void> _completeCycle() async {
    await SoundManager().playOnce(SoundType.end);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _trainingService.logTrainingSession(
        userId: user.uid,
        trainingType: 'moro',
      );
    }

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Zyklus $currentCycle abgeschlossen'),
        content: currentCycle < totalCycles
            ? const Text('Drücke START für den nächsten Zyklus.')
            : const Text('Alle Zyklen abgeschlossen! 🎉'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (currentCycle >= totalCycles) {
                _resetAll();
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // Nach Dialog-Show bleibt isRunning false, und _displayCycleIndex
    // zeigt automatisch die Vorschau für den nächsten Zyklus.
    setState(() => isRunning = false);
  }

  /// Rücksetzen aller Zähler
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
  Widget build(BuildContext context) {
    double progress = 0;
    if (isRunning) {
      final total = isExercise ? exerciseDuration : pauseDuration;
      progress = (total - remainingTime) / total;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Moro Trainer')),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Image.asset(
                _getImageAsset(),
                width: double.infinity,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Text(
                _getPromptText(),
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              timer_ring.TimerRing(
                progress: progress.clamp(0, 1),
                size: 120,
                backgroundColor: Colors.grey.shade300,
                progressColor: isExercise ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),
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
                  text: '▶️ Start Zyklus ${currentCycle + 1}',
                  onPressed: _startCycle,
                ),
              if (!isRunning && currentCycle >= totalCycles)
                CustomButton(
                  text: '🔄 Alles zurücksetzen',
                  onPressed: _resetAll,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
