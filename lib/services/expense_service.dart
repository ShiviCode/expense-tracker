import 'package:hive/hive.dart';
import 'package:personal_expense_tracker/models/expense_model.dart';

class ExpenseService {
  static const String _expenseBox = 'expenses';

  // Open the Hive box for expenses
  Future<void> openBox() async {
    await Hive.openBox<ExpenseModel>(_expenseBox);
  }

  // Add an expense to the Hive box
  Future<void> addExpense(ExpenseModel expense) async {
    var box = await Hive.openBox<ExpenseModel>(_expenseBox);
    await box.add(expense);
  }

  // Get all expenses from the Hive box
  Future<List<ExpenseModel>> getExpenses() async {
    var box = await Hive.openBox<ExpenseModel>(_expenseBox);
    return box.values.toList();
  }

  // Delete an expense by its index in the Hive box
  Future<void> deleteExpense(int index) async {
    var box = await Hive.openBox<ExpenseModel>(_expenseBox);
    await box.deleteAt(index);
  }
}
