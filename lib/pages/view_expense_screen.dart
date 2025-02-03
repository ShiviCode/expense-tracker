import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/models/expense_model.dart';
import 'package:personal_expense_tracker/pages/add_edit_expense_screen.dart';
import 'package:personal_expense_tracker/states/expense_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewExpenseScreen extends StatefulWidget {
  const ViewExpenseScreen({super.key});

  @override
  State<ViewExpenseScreen> createState() => _ViewExpenseScreenState();
}

class _ViewExpenseScreenState extends State<ViewExpenseScreen> {
  DateTime? _selectedDate;
  String _selectedFilter = 'All';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final expenses = expenseProvider.expenses;

    List<ExpenseModel> filteredExpenses = _filterExpenses(expenses);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.view),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer(); // Open right drawer
            },
          ),
        ],
      ),
      endDrawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: filteredExpenses.isEmpty
            ? Center(
                child: Text(AppLocalizations.of(context)!.noExpensesAvailable),
              )
            : ListView.builder(
                itemCount: filteredExpenses.length,
                itemBuilder: (context, index) {
                  final expense = filteredExpenses[index];

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        expense.description,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat.yMMMd().format(expense.date),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '₹${expense.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              bool? shouldDelete =
                                  await _showDeleteDialog(context);
                              if (shouldDelete == true) {
                                expenseProvider.deleteExpense(expense.id);
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddEditExpenseScreen(expenseModel: expense),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddEditExpenseScreen()),
          );
        },
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }

  /// Builds the right-side drawer with filter options
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              AppLocalizations.of(context)!.filterExpenses,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          _buildDrawerItem(AppLocalizations.of(context)!.all),
          _buildDrawerItem(AppLocalizations.of(context)!.today),
          _buildDrawerItem(AppLocalizations.of(context)!.oneWeek),
          _buildDrawerItem(AppLocalizations.of(context)!.oneMonth),
          ListTile(
            leading: Icon(
              Icons.date_range,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              AppLocalizations.of(context)!.pickCustomDate,
              style: TextStyle(
                  fontSize: 16, color: Theme.of(context).primaryColor),
            ),
            onTap: () async {
              await _selectDate(context);
            },
          ),
        ],
      ),
    );
  }

  /// Builds drawer list items
  Widget _buildDrawerItem(String title) {
    return ListTile(
      leading: Icon(
        Icons.add,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
      ),
      onTap: () {
        setState(() {
          _selectedFilter = title;
          _selectedDate = null;
        });
        Navigator.pop(context);
      },
    );
  }

  /// Filters expenses based on selected criteria
  List<ExpenseModel> _filterExpenses(List<ExpenseModel> expenses) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime oneWeekAgo = today.subtract(const Duration(days: 7));
    DateTime oneMonthAgo = today.subtract(const Duration(days: 30));

    if (_selectedDate != null) {
      return expenses.where((e) => isSameDate(e.date, _selectedDate!)).toList();
    }

    switch (_selectedFilter) {
      case 'Today':
        return expenses.where((e) => isSameDate(e.date, today)).toList();
      case 'One Week':
        return expenses.where((e) => e.date.isAfter(oneWeekAgo)).toList();
      case 'One Month':
        return expenses.where((e) => e.date.isAfter(oneMonthAgo)).toList();
      default:
        return expenses;
    }
  }

  /// Selects a single date and updates the filter
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedFilter = 'Pick a Custom Date';
        _selectedDate = pickedDate;
      });
    }
    Navigator.pop(context);
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Shows a confirmation dialog before deleting an expense
  Future<bool?> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmDelete),
          // content: Text(AppLocalizations.of(context)!.confirmDelete),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );
  }
}
