import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the plugin
  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_bell');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Request notification permissions for iOS
  Future<void> requestPermissions() async {
    final bool? granted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions();
    if (granted == true) {
      print("Notification permissions granted");
    } else {
      print("Notification permissions denied");
    }
  }

  // Function to schedule daily reminder notification
  Future<void> scheduleDailyReminderNotification() async {
    final now = DateTime.now();

    // Time at which the notification should be triggered (e.g., 8 PM)
    final scheduledNotificationDateTime =
        DateTime(now.year, now.month, now.day, 20, 0, 0); // 8 PM

    if (scheduledNotificationDateTime.isBefore(now)) {
      // If the scheduled time is in the past, set it for the next day
      scheduledNotificationDateTime.add(const Duration(days: 1));
    }

    // Android notification details
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'expense_tracker_channel', // ID
      'Expense Tracker Reminders', // Name
      channelDescription: 'Reminder to add your daily expense.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Use the 'show' method to show a simple notification immediately.
    await flutterLocalNotificationsPlugin.show(
      0,
      'Reminder',
      'Please add your daily expense',
      platformChannelSpecifics,
    );
  }
}
