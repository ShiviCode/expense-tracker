import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/models/expense_model.dart';
import 'package:personal_expense_tracker/states/expense_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddEditExpenseScreen extends StatefulWidget {
  const AddEditExpenseScreen({super.key, this.expenseModel});
  final ExpenseModel? expenseModel;

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    // If expenseModel is not null, populate the fields with its data
    if (widget.expenseModel != null) {
      _descriptionController.text = widget.expenseModel!.description;
      _amountController.text = widget.expenseModel!.amount.toString();
      _selectedDate = widget.expenseModel!.date;
    }
  }

  // Function to show the date picker and set the selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.expenseModel != null
              ? AppLocalizations.of(context)!.editExpense
              : AppLocalizations.of(context)!.addExpense,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Description TextField
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.description,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.descriptionError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Amount TextField
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.amount,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.amountError;
                  }
                  if (double.tryParse(value) == null) {
                    return AppLocalizations.of(context)!.amountError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Read-only Date TextField that shows the selected date
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.date,
                ),
                controller: TextEditingController(
                    text: DateFormat('dd-MM-yyyy').format(_selectedDate)),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 40),

              // Add Expense Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final expense = ExpenseModel(
                      amount: double.parse(_amountController.text),
                      description: _descriptionController.text,
                      date: _selectedDate,
                      id: widget.expenseModel != null
                          ? widget.expenseModel!.id
                          : DateTime.now().millisecondsSinceEpoch, // Unique ID
                    );

                    // Add the expense using the ExpenseProvider
                    if (widget.expenseModel == null) {
                      context.read<ExpenseProvider>().addExpense(expense);
                    } else {
                      context.read<ExpenseProvider>().editExpense(expense);
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(
                  widget.expenseModel != null
                      ? AppLocalizations.of(context)!.saveExpense
                      : AppLocalizations.of(context)!.addExpense,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
