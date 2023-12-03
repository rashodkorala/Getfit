import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class gymReminderService {

  Future<void> scheduleNotification(TimeOfDay time) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('reminder_hour', time.hour);
  await prefs.setInt('reminder_minute', time.minute);

  var scheduledNotificationDateTime =
      DateTime.now().add(Duration(hours: time.hour, minutes: time.minute));

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'your_channel_id', 'your_channel_name', 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false);

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.schedule(
      0,
      'Gym Time',
      'Don\'t forget to go to the gym!',
      scheduledNotificationDateTime,
      platformChannelSpecifics);
}

}

