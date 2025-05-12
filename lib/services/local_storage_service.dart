import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bugbear_app/models/user_program.dart';

class LocalStorageService {
  static const _boxName = 'encryptedCalendarBox';
  static const _keyStorage = 'hive_encryption_key';
  final _secure = const FlutterSecureStorage();
  late final Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    final encoded = await _secure.read(key: _keyStorage);
    late final List<int> key;
    if (encoded == null) {
      key = Hive.generateSecureKey();
      await _secure.write(key: _keyStorage, value: base64UrlEncode(key));
    } else {
      key = base64Url.decode(encoded);
    }
    _box = await Hive.openBox(_boxName, encryptionCipher: HiveAesCipher(key));
  }

  // -- UserProgram --
  Future<void> saveUserProgram(UserProgram up) async {
    await _box.put('activeProgramId', up.activeProgramId);
    await _box.put('programStartDate', up.programStartDate);
    await _box.put('skippedWeekdays', up.skippedWeekdays);
  }
  UserProgram? loadUserProgram() {
    final id = _box.get('activeProgramId') as String?;
    final dt = _box.get('programStartDate') as DateTime?;
    final sk = _box.get('skippedWeekdays') as int?;
    if (id == null || dt == null || sk == null) return null;
    return UserProgram(activeProgramId: id, programStartDate: dt, skippedWeekdays: sk);
  }

  // -- Completed Dates --
  Future<void> saveCompletedDates(Set<DateTime> dates) async =>
      await _box.put('completedDates', dates.toList());
  Set<DateTime> loadCompletedDates() {
    final list = _box.get('completedDates') as List<dynamic>? ?? [];
    return list.whereType<DateTime>().toSet();
  }

  // -- Quiz Results --
  Future<void> saveQuizResults(List<Map<String, dynamic>> res) async =>
      await _box.put('quizResults', res);
  List<Map<String, dynamic>> loadQuizResults() =>
      (_box.get('quizResults') as List<dynamic>? ?? []).cast();

  // -- Date-Checks --
  Future<void> saveLastDaily(DateTime d) async => await _box.put('lastDaily', d);
  DateTime? loadLastDaily() => _box.get('lastDaily') as DateTime?;
  Future<void> saveLastWeekly(DateTime d) async => await _box.put('lastWeekly', d);
  DateTime? loadLastWeekly() => _box.get('lastWeekly') as DateTime?;

  // -- Clear --
  Future<void> clearCompletedDates() async => await _box.delete('completedDates');
  Future<void> clearAll() async => await _box.clear();
}
