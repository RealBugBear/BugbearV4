import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:bugbear_app/models/user_program.dart';
import 'package:bugbear_app/services/training_service.dart';
import 'package:bugbear_app/services/local_storage_service.dart';


class CalendarModel extends ChangeNotifier {
  final TrainingService trainingService;
  final LocalStorageService localStorage;

  DateTime visibleMonth = DateTime.now();
  String? activeProgramId;
  DateTime? programStartDate;
  int skippedWeekdays = 0;
  Set<DateTime> completedDates = {};

  CalendarModel({
    required this.trainingService,
    required this.localStorage,
  }) {
    _initialize();
  }

  DateTime? get goalDate {
    if (activeProgramId == null || programStartDate == null) return null;
    final prog = trainingService.getProgramById(activeProgramId!);
    final base = programStartDate!.add(Duration(days: prog.plannedSessions));
    final weeksSince = DateTime.now().difference(programStartDate!).inDays ~/ 7;
    final ideal = weeksSince * 3;
    final missed = max(0, ideal - completedDates.length);
    return base.add(Duration(days: missed * 7));
  }

  Future<void> _initialize() async {
    final up = localStorage.loadUserProgram();
    if (up != null) {
      activeProgramId = up.activeProgramId;
      programStartDate = up.programStartDate;
      skippedWeekdays = up.skippedWeekdays;
    }
    completedDates = localStorage.loadCompletedDates();
    await _runChecks();
    notifyListeners();

    trainingService.watchUserProgram(trainingService.currentUid()).listen((u) {
      activeProgramId = u.activeProgramId;
      programStartDate = u.programStartDate;
      skippedWeekdays = u.skippedWeekdays;
      localStorage.saveUserProgram(u);
      notifyListeners();
    });

    trainingService.getAllTrainingSessions(userId: trainingService.currentUid()).listen((list) {
      completedDates = list
          .map((s) => DateTime(s.sessionDate.year, s.sessionDate.month, s.sessionDate.day))
          .toSet();
      localStorage.saveCompletedDates(completedDates);
      notifyListeners();
    });
  }

  Future<void> _runChecks() async {
    final today = DateTime.now();
    final lastD = localStorage.loadLastDaily();
    if (lastD == null || !_sameDay(lastD, today)) {
      if (!completedDates.contains(DateTime(today.year, today.month, today.day))) {
        skippedWeekdays++;
        await trainingService.updateSkipped(trainingService.currentUid(), skippedWeekdays);
      }
      await localStorage.saveLastDaily(today);
    }
    final lastW = localStorage.loadLastWeekly();
    if (lastW == null || today.difference(lastW).inDays >= 7) {
      final cutoff = today.subtract(const Duration(days: 6));
      final cnt = completedDates.where((d) => !d.isBefore(cutoff)).length;
      if (cnt <= 3) {
        skippedWeekdays += 7;
        await trainingService.updateSkipped(trainingService.currentUid(), skippedWeekdays);
      }
      await localStorage.saveLastWeekly(today);
    }
  }

  bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  set setVisibleMonth(DateTime m) {
    visibleMonth = m;
    notifyListeners();
  }

  Future<void> toggleCompleted(DateTime day) async {
    final d = DateTime(day.year, day.month, day.day);
    if (!completedDates.remove(d)) {
      completedDates.add(d);
      await trainingService.logTrainingSession(
        userId: trainingService.currentUid(),
        trainingType: activeProgramId!,
      );
    }
    await localStorage.saveCompletedDates(completedDates);
    notifyListeners();
  }

  Future<void> setActiveProgram(String pid) async {
    final now = DateTime.now();
    activeProgramId = pid;
    programStartDate = now;
    skippedWeekdays = 0;
    completedDates.clear();
    await trainingService.setActiveProgram(trainingService.currentUid(), pid, now);
    localStorage.saveUserProgram(UserProgram(
      activeProgramId: pid,
      programStartDate: now,
      skippedWeekdays: 0,
    ),);
    localStorage.saveCompletedDates(completedDates);
    notifyListeners();
  }
}
