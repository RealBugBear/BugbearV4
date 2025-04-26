import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bugbear_app/models/training_data.dart';
import 'package:bugbear_app/models/notification_timing.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Initialisiert das Zeitzonen-Modul.
/// Sie können das auch in main() aufrufen.
void initializeTimezone() {
  tz_data.initializeTimeZones();
}

/// Globales Plugin-Objekt für lokale Benachrichtigungen.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Schedules notifications for the given training program.
void scheduleNotificationsForProgram(TrainingProgram program) {
  final now = DateTime.now();
  final timeSinceLastTraining = now.difference(program.lastTraining);

  if (timeSinceLastTraining >= advancedDelay) {
    showAdvancedNotification(program);
  } else if (timeSinceLastTraining >= initialDelay) {
    scheduleInitialNotification(program);
    scheduleRepeatingNotification(program, repeatInterval);
  }
}

/// Schedules the initial notification to be delivered 18 hours after the last training.
void scheduleInitialNotification(TrainingProgram program) {
  final scheduledTime = program.lastTraining.add(initialDelay);
  final tz.TZDateTime tzScheduledTime =
      tz.TZDateTime.from(scheduledTime, tz.local);

  flutterLocalNotificationsPlugin.zonedSchedule(
    0, // Unique ID
    'Erinnerung: Zeit für Training!',
    'Hey, es sind jetzt 18h seit Ihrem letzten Training vergangen.',
    tzScheduledTime,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'training_channel',
        'Training Erinnerungen',
        channelDescription: 'Erinnert den Nutzer an das Training',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    // Neuer, in Version 19 required Parameter:
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    payload: null,
  );
}

/// Schedules repeating notifications at the specified interval.
void scheduleRepeatingNotification(TrainingProgram program, Duration interval) {
  flutterLocalNotificationsPlugin.periodicallyShow(
    2, // Unique ID
    'Erinnerung: Training nicht verpasst!',
    'Denken Sie daran, Ihr Training zu absolvieren.',
    RepeatInterval.everyMinute, // Platzhalter; hier auch an androidScheduleMode denken
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'training_repeating_channel',
        'Wiederholende Training Erinnerungen',
        channelDescription: 'Erinnert regelmäßig an das Training',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    // Ebenfalls erforderlich:
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    payload: null,
  );
}

/// Shows an advanced notification if 72 hours have passed since the last training.
void showAdvancedNotification(TrainingProgram program) {
  flutterLocalNotificationsPlugin.show(
    1, // Unique ID
    'Erinnerung: Sehr lange Pause!',
    'Es sind 72h seit Ihrem letzten Training vergangen. Zeit, loszulegen!',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'advanced_training_channel',
        'Erweiterte Training Erinnerungen',
        channelDescription:
            'Sende Benachrichtigung, wenn 72h seit dem letzten Training vergangen sind.',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    payload: null,
  );
}
