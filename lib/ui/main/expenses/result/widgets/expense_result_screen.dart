import 'package:flutter/material.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/main/expenses/result/view_models/expense_result_viewmodel.dart';
import 'package:provider/provider.dart';

class ExpenseResultScreen extends StatefulWidget {
  const ExpenseResultScreen({super.key});

  @override
  State<ExpenseResultScreen> createState() => _ExpenseResultScreenState();
}

class _ExpenseResultScreenState extends State<ExpenseResultScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExpenseResultViewModel>();
    return Scaffold(
      appBar: TopAppBar(automaticallyImplyLeading: true, title: "結果"),
      body: SingleChildScrollView(
        child: Column(
          children:
              viewModel.allExpensesList().isEmpty ? "費用が追加されていません" : "データあり",
        ),
      ),
    );
    ;
  }
}
