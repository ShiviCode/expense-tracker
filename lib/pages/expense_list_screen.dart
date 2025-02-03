import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/models/expense_model.dart';
import 'package:personal_expense_tracker/pages/add_edit_expense_screen.dart';
import 'package:personal_expense_tracker/pages/view_expense_screen.dart';
import 'package:personal_expense_tracker/states/expense_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Text(
            AppLocalizations.of(context)!.expenceTracker,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              // Switch between English and Hindi
              Locale newLocale =
                  context.read<ExpenseProvider>().locale.languageCode == 'en'
                      ? const Locale('hi', 'IN')
                      : const Locale('en', 'US');
              context.read<ExpenseProvider>().switchLanguage(newLocale);
            },
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ExpenseProvider>(
          builder: (context, expenseProvider, child) {
            final expenses = expenseProvider.expenses;
            final today = DateTime.now();
            final startOfDay = DateTime(today.year, today.month, today.day);
            List<ExpenseModel> todayExpenses = expenses.where((expense) {
              return expense.date.isAfter(startOfDay) &&
                  expense.date.isBefore(today.add(const Duration(days: 1)));
            }).toList();
            double totalExpense =
                todayExpenses.fold(0, (sum, item) => sum + item.amount);

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 245, 254),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.totalExpense,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 153, 97, 140)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          totalExpense.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.todayExpense,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ViewExpenseScreen()),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.viewAll,
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: todayExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = todayExpenses[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 245, 254),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            expense.description,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            expense.date.toLocal().toString().split(" ")[0],
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          trailing: Text(
                            expense.amount.toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          //onTap: () {},
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditExpenseScreen()),
          );
        },
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
