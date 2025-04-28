import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bugbear_app/main.dart' show notificationsPlugin;

Future<void> showTrainingNotification() async {
  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'training_channel',
        'Training Erinnerungen',
        channelDescription: 'Erinnert den Nutzer ans Training',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );

  const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);

  await notificationsPlugin.show(
    0,
    'Trainingszeit Erinnerung',
    'Hey, hast du mal 11 Min Zeit für dein Training?',
    platformDetails,
    payload: 'train_payload',
  );
}
