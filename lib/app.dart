import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:personal_expense_tracker/pages/expense_list_screen.dart';
import 'package:personal_expense_tracker/states/expense_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseProvider()..openBox(),
      child: Consumer<ExpenseProvider>(builder: (context, provider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Expense Tracker',
          theme: ThemeData(
            primaryColor: const Color(0xFF9C4E97),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF9C4E97), // Light purple for AppBar
              elevation: 4,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Button Theme
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),

            // Scaffold background color
            scaffoldBackgroundColor: const Color(
                0xFFF4E1F1), // Light background color for the scaffold

            // Floating Action Button color
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xFF9C4E97), // Light purple for FAB
            ),

            // InputDecoration Theme (for TextFields, etc.)
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: Color(0xFF9C4E97)), // Light purple border color
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: Color(0xFF9C4E97), width: 2), // Focused border color
              ),
              labelStyle:
                  const TextStyle(color: Color(0xFF9C4E97)), // Label color
            ),

            // Icon Theme
            iconTheme: const IconThemeData(
              color: Color(0xFF9C4E97), // Light purple for icons
            ),

            // Switch Theme
            switchTheme: SwitchThemeData(
              thumbColor: MaterialStateProperty.all(
                  const Color(0xFF9C4E97)), // Thumb color
              trackColor: MaterialStateProperty.all(
                  const Color(0xFFD8A4D8)), // Track color
            ),
          ),
          locale: provider.locale,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('hi', 'IN'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          home: const ExpenseListScreen(),
        );
      }),
    );
  }
}
