import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bugbear_app/main.dart'; // Falls Sie hier auf den globalen Plugin zugreifen wollen

Future<void> showTrainingNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'training_channel',               // Kanal-ID
    'Training Erinnerungen',          // Kanalname
    channelDescription: 'Erinnert den Nutzer an das Training', // Kanalbeschreibung
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  // Hier nutzen wir den global definierten `flutterLocalNotificationsPlugin`
  await flutterLocalNotificationsPlugin.show(
    0,  // Eindeutige ID der Benachrichtigung
    'Trainingszeit Erinnerung',       // Titel
    'Hey, hast du mal 11 Min Zeit für dein Training?', // Nachrichtentext
    platformChannelSpecifics,
    payload: 'train_payload',
  );
}
