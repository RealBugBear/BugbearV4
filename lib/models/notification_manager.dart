import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bugbear_app/models/training_data.dart';
import 'package:bugbear_app/models/notification_timing.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

// Initialize timezone data. You can also call this in your main() function.
void initializeTimezone() {
  tz_data.initializeTimeZones();
}

// Global plugin for local notifications.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Schedules notifications for the given training program.
/// Depending on how much time has elapsed since the last training,
/// it schedules either an initial, repeating, or advanced notification.
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
  // Convert DateTime to TZDateTime in the local timezone.
  final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

  flutterLocalNotificationsPlugin.zonedSchedule(
    0, // Unique ID for this notification.
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
    // Parameters as defined in version 13.0.0:
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    payload: null,
  );
}

/// Schedules repeating notifications at the specified interval.
/// Note: Here, RepeatInterval.everyMinute is used as a placeholder.
/// For a custom interval (e.g., every 4 hours), custom scheduling logic may be necessary.
void scheduleRepeatingNotification(TrainingProgram program, Duration interval) {
  flutterLocalNotificationsPlugin.periodicallyShow(
    2, // Unique ID for repeating notifications.
    'Erinnerung: Training nicht verpasst!',
    'Denken Sie daran, Ihr Training zu absolvieren.',
    RepeatInterval.everyMinute, // Placeholder; adjust as needed.
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'training_repeating_channel',
        'Wiederholende Training Erinnerungen',
        channelDescription: 'Erinnert regelmäßig an das Training',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    payload: null,
  );
}

/// Shows an advanced notification if 72 hours have passed since the last training.
void showAdvancedNotification(TrainingProgram program) {
  flutterLocalNotificationsPlugin.show(
    1, // Unique ID for the advanced notification.
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
