// lib/models/notification_manager.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bugbear_app/models/training_data.dart';
import 'package:bugbear_app/models/notification_timing.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

///
/// Muss einmalig beim App-Start aufgerufen werden, bevor Notifications geplant werden.
///
void initializeTimezone() {
  tz_data.initializeTimeZones();
}

/// Globale Plugin-Instanz für lokale Notifications.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

///
/// Plant Notifications basierend auf dem Zeitpunkt der letzten Trainingseinheit.
///
/// [program] liefert Kontext (Name, ID) für die Nachricht;
/// [lastTraining] ist das Datum/Uhrzeit der letzten belegten Session.
///
void scheduleNotificationsForProgram({
  required TrainingProgram program,
  required DateTime lastTraining,
}) {
  final now = DateTime.now();
  final sinceLast = now.difference(lastTraining);

  if (sinceLast >= advancedDelay) {
    _showAdvancedNotification(program);
  } else if (sinceLast >= initialDelay) {
    _scheduleInitialNotification(program, lastTraining);
    _scheduleRepeatingNotification(program);
  }
}

/// Einmalige Erinnerung nach [initialDelay] seit der letzten Session.
void _scheduleInitialNotification(
  TrainingProgram program,
  DateTime lastTraining,
) {
  final scheduledDate = lastTraining.add(initialDelay);
  final tz.TZDateTime when = tz.TZDateTime.from(scheduledDate, tz.local);

  flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Erinnerung: Zeit für ${program.name}!',
    'Es sind seit Ihrer letzten ${program.name}-Einheit '
        '${initialDelay.inHours} Stunden vergangen.',
    when,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'training_channel',
        'Training Erinnerungen',
        channelDescription: 'Erinnert an das Training',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    payload: program.id,
  );
}

/// Tägliche Wiederholungserinnerung.
void _scheduleRepeatingNotification(TrainingProgram program) {
  flutterLocalNotificationsPlugin.periodicallyShow(
    1,
    'Erinnerung: ${program.name} nicht vergessen!',
    'Denken Sie daran, Ihre ${program.name}-Einheit heute zu absolvieren.',
    RepeatInterval.daily,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'training_repeating_channel',
        'Wiederholende Training Erinnerungen',
        channelDescription: 'Tägliche Erinnerung an das Training',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    payload: program.id,
  );
}

/// Sofortige Warnung, wenn [advancedDelay] seit der letzten Session vergangen ist.
void _showAdvancedNotification(TrainingProgram program) {
  flutterLocalNotificationsPlugin.show(
    2,
    'Achtung: Lange Pause bei ${program.name}!',
    'Es sind ${advancedDelay.inHours} Stunden seit Ihrem letzten '
        '${program.name}-Training vergangen. Zeit, loszulegen!',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'advanced_training_channel',
        'Erweiterte Training Erinnerungen',
        channelDescription: 'Warnung bei langer Trainingspause',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    payload: program.id,
  );
}
