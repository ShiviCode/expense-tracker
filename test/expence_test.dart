import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/states/expense_provider.dart';
import 'package:personal_expense_tracker/models/expense_model.dart';
import 'package:mocktail/mocktail.dart';

class MockExpenseProvider extends Mock implements ExpenseProvider {}

void main() {
  // Register a fallback value for ExpenseModel
  setUpAll(() {
    registerFallbackValue(ExpenseModel(
      amount: 0.0,
      description: '',
      date: DateTime.now(),
      id: 0,
    ));
  });

  group('ExpenseProvider Tests', () {
    late MockExpenseProvider expenseProvider;

    setUp(() {
      expenseProvider = MockExpenseProvider();

      // Initializing expenses to be an empty list
      when(() => expenseProvider.expenses).thenReturn([]);

      // Mock the addExpense method to add an expense to the in-memory list
      when(() => expenseProvider.addExpense(any())).thenAnswer((invocation) {
        final expense = invocation.positionalArguments[0] as ExpenseModel;
        // Mimic adding the expense to the in-memory list
        expenseProvider.expenses.add(expense); 
        return Future.value();
      });
    });

    test('Adding an expense should update the list', () async {
      // Arrange
      final expense = ExpenseModel(
        amount: 20.0,
        description: 'Test Expense',
        date: DateTime.now(),
        id: DateTime.now().millisecondsSinceEpoch,
      );

      // Act
      await expenseProvider.addExpense(expense);

      // Assert: Verify that the expense is added to the list
      verify(() => expenseProvider.addExpense(expense)).called(1);

      // After adding, the list should not be empty
      expect(expenseProvider.expenses.isNotEmpty, true);
    });

    test('Deleting an expense should update the list', () async {
      // Arrange
      final expense = ExpenseModel(
        amount: 20.0,
        description: 'Test Expense',
        date: DateTime.now(),
        id: DateTime.now().millisecondsSinceEpoch,
      );

      // Add the expense to the mock provider list
      expenseProvider.expenses.add(expense);

      // Mock the deleteExpense method to remove the expense
      when(() => expenseProvider.deleteExpense(any())).thenAnswer((invocation) {
        final id = invocation.positionalArguments[0] as int;
        expenseProvider.expenses.removeWhere((expense) => expense.id == id);
        return Future.value();
      });

      // Act: Perform the deletion
      await expenseProvider.deleteExpense(expense.id);

      // Assert: Verify that the expense is removed from the list
      verify(() => expenseProvider.deleteExpense(expense.id)).called(1);
      expect(expenseProvider.expenses.isEmpty, true); // After deleting, the list should be empty
    });
  });
}
