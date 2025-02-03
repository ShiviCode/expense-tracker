import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:personal_expense_tracker/models/expense_model.dart';

class ExpenseProvider with ChangeNotifier {
  static const String _expenseBox = 'expenses';
  List<ExpenseModel> _expenses = [];
  List<ExpenseModel> get expenses => _expenses;

  // Open the Hive box for expenses
  Future<void> openBox() async {
    var box = await Hive.openBox<ExpenseModel>(_expenseBox);
    _expenses = box.values.toList();
    notifyListeners();
  }

  // Add an expense to the Hive box
  Future<void> addExpense(ExpenseModel expense) async {
    var box = await Hive.openBox<ExpenseModel>(_expenseBox);
    await box.add(expense);
    _expenses.add(expense);
    notifyListeners();
  }

  // Delete an expense from the Hive box by ID
  Future<void> deleteExpense(int id) async {
    var box = await Hive.openBox<ExpenseModel>(_expenseBox);
    final index = _expenses.indexWhere((expense) => expense.id == id);

    if (index != -1) {
      await box.deleteAt(index);
      _expenses.removeAt(index);
      notifyListeners();
    }
  }

  // Fetch all expenses from the Hive box
  Future<void> fetchExpenses() async {
    var box = await Hive.openBox<ExpenseModel>(_expenseBox);
    _expenses = box.values.toList();
    notifyListeners();
  }

  // Edit an expense to the Hive box
  Future<void> editExpense(ExpenseModel updatedExpense) async {
    var box = await Hive.openBox<ExpenseModel>(_expenseBox);
    int index =
        _expenses.indexWhere((expense) => expense.id == updatedExpense.id);
    await box.putAt(index, updatedExpense);
    _expenses[index] = updatedExpense;
    notifyListeners();
  }

  Locale _locale = const Locale('en', 'US');

  Locale get locale => _locale;

  // Change the language (English or Hindi)
  void switchLanguage(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
