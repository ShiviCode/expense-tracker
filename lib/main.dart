import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_expense_tracker/models/expense_model.dart';
import 'package:personal_expense_tracker/app.dart';
import 'package:personal_expense_tracker/services/notification_service.dart';

void main() async {
  // Ensure all Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive with Flutter adapter
  await Hive.initFlutter();

  // Register the Hive type adapter for the Expense model
  Hive.registerAdapter(ExpenseModelAdapter());
  final notificationService = NotificationService();
  await notificationService.init();

  await notificationService.requestPermissions();

  // Schedule the daily reminder notification
  await notificationService.scheduleDailyReminderNotification();

  // await Hive.deleteBoxFromDisk("expenses");

  runApp(const App());
}
