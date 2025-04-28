// File: lib/models/notification_manager.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bugbear_app/models/training_data.dart';
import 'package:bugbear_app/models/notification_timing.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Must be called once (e.g. at app startup) before scheduling anything.
void initializeTimezone() {
  tz_data.initializeTimeZones();
}

/// Global plugin instance.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Entry point: decides which notifications to fire or schedule.
void scheduleNotificationsForProgram(TrainingProgram program) {
  final now = DateTime.now();
  final since = now.difference(program.lastTraining);

  if (since >= advancedDelay) {
    _showAdvancedNotification();
  } else if (since >= initialDelay) {
    _scheduleInitialNotification(program);
    _scheduleRepeatingNotification();
  }
}

/// One-off 18 h reminder.
void _scheduleInitialNotification(TrainingProgram program) {
  final scheduled = program.lastTraining.add(initialDelay);
  final tz.TZDateTime when = tz.TZDateTime.from(scheduled, tz.local);

  flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Erinnerung: Zeit für Training!',
    'Hey, es sind jetzt 18 h seit Ihrem letzten Training vergangen.',
    when,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'training_channel',
        'Training Erinnerungen',
        channelDescription: 'Erinnert den Nutzer an das Training',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    // 🔑 Required for exact delivery even while idle
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    payload: null,
  );
}

/// Periodic “don’t forget” reminder.
void _scheduleRepeatingNotification() {
  flutterLocalNotificationsPlugin.periodicallyShow(
    1,
    'Erinnerung: Training nicht verpasst!',
    'Denken Sie daran, Ihr Training zu absolvieren.',
    RepeatInterval.daily,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'training_repeating_channel',
        'Wiederholende Training Erinnerungen',
        channelDescription: 'Erinnert regelmäßig an das Training',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    // 🔑 Required for exact delivery even while idle
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    payload: null,
  );
}

/// Immediate “72 h passed” alert.
void _showAdvancedNotification() {
  flutterLocalNotificationsPlugin.show(
    2,
    'Erinnerung: Sehr lange Pause!',
    'Es sind 72 h seit Ihrem letzten Training vergangen. Zeit, loszulegen!',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'advanced_training_channel',
        'Erweiterte Training Erinnerungen',
        channelDescription:
            'Sende Benachrichtigung, wenn 72 h seit dem letzten Training vergangen sind.',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    payload: null,
  );
}
