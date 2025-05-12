import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  NotificationManager._();
  static final NotificationManager _instance = NotificationManager._();
  factory NotificationManager() => _instance;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize time zones
    tz_data.initializeTimeZones();
    final String localName = tz.local.name;
    tz.setLocalLocation(tz.getLocation(localName));

    // Android initialization settings
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      const InitializationSettings(android: android),
    );
  }

  tz.TZDateTime _nextInstance(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var dt = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (dt.isBefore(now)) dt = dt.add(const Duration(days: 1));
    return dt;
  }

  /// Schedule a daily notification at the given [hour]:[minute].
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) =>
      _plugin.zonedSchedule(
        id,
        title,
        body,
        _nextInstance(hour, minute),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel',
            'Tägliche Erinnerung',
            channelDescription: 'Erinnert dich täglich ans Training',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        // required in latest API:
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // repeat at the same time each day
        matchDateTimeComponents: DateTimeComponents.time,
      );

  /// Cancel all scheduled notifications.
  Future<void> cancelAll() => _plugin.cancelAll();
}
