import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Store/ExpenseStore.dart';

class EstimatedExpenseScreen extends StatefulWidget {
  static const String id ="estimated_expense_screen";
  const EstimatedExpenseScreen({super.key});

  @override
  State<EstimatedExpenseScreen> createState() => _EstimatedExpenseScreenState();
}

class _EstimatedExpenseScreenState extends State<EstimatedExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    final expenseStore = Provider.of<ExpenseStore>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estimated Expenses'),
      ),
      body: const Center(
        child: Text('Estimated Expense Screen'),
      ),
    );
  }
}
