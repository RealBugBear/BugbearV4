// File: lib/screens/spinalergalant_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bugbear_app/widgets/app_drawer.dart';
import 'package:bugbear_app/widgets/cycle_info_card.dart';
import 'package:bugbear_app/core/widgets/timer_ring.dart' as timer_ring;
import 'package:bugbear_app/services/training_service.dart';
import 'package:bugbear_app/services/sound_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bugbear_app/generated/l10n.dart';

class SpinalergalantScreen extends StatefulWidget {
  const SpinalergalantScreen({Key? key}) : super(key: key);

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

  final TrainingService _trainingService = TrainingService();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _displayCycleIndex => currentCycle == 0 ? 1 : currentCycle;

  String _getImageAsset() {
    switch (_displayCycleIndex) {
      case 1:
        return 'assets/images/spin1.png';
      case 2:
        return 'assets/images/spin2.png';
      case 3:
        return 'assets/images/spin3.png';
      case 4:
        return 'assets/images/spin4.png';
      default:
        return '';
    }
  }

  String _getPromptText(BuildContext context) {
    final idx = _displayCycleIndex;
    if (!isRunning) {
      return S.of(context).getIntoPosition(idx);
    }
    return isExercise
        ? S.of(context).exerciseInProgress(idx)
        : S.of(context).exerciseDone(idx);
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

  Future<void> _startExercisePhase() async {
    await SoundManager().playOnce(SoundType.start);
    setState(() {
      isExercise = true;
      remainingTime = exerciseDuration;
    });
    SoundManager().startLoop(SoundType.tick);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() => remainingTime--);
      } else {
        timer.cancel();
        SoundManager().stopLoop();
        setState(() => isExercise = false);
        _startPausePhase();
      }
    });
  }

  Future<void> _startPausePhase() async {
    setState(() => remainingTime = pauseDuration);
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

  Future<void> _completeCycle() async {
    await SoundManager().playOnce(SoundType.end);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _trainingService.logTrainingSession(
        userId: user.uid,
        trainingType: 'spinalergalant',
      );
    }
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).cycleComplete(currentCycle)),
        content: Text(
          currentCycle < totalCycles
              ? S.of(context).pressStartNextCycle
              : S.of(context).allCyclesCompleted,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (currentCycle >= totalCycles) _resetAll();
            },
            child: Text(S.of(context).ok),
          ),
        ],
      ),
    );
    setState(() => isRunning = false);
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
  Widget build(BuildContext context) {
    double progress = 0;
    if (isRunning) {
      final total = isExercise ? exerciseDuration : pauseDuration;
      progress = (total - remainingTime) / total;
    }

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).spinalergalantTrainerTitle)),
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
                _getPromptText(context),
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              timer_ring.TimerRing(
                progress: progress.clamp(0, 1),
                size: 120,
                backgroundColor: Colors.grey.shade300,
                progressColor: isExercise ? Colors.green : Colors.orangeAccent,
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
                ElevatedButton(
                  onPressed: _startCycle,
                  child: Text('▶️ Start cycle $_displayCycleIndex'),
                ),
              if (!isRunning && currentCycle >= totalCycles)
                ElevatedButton(
                  onPressed: _resetAll,
                  child: Text(S.of(context).resetAll),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
