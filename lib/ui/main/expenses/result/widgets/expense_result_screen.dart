import 'package:flutter/material.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/main/expenses/result/view_models/expense_result_viewmodel.dart';
import 'package:provider/provider.dart';

class ExpenseResultScreen extends StatelessWidget {
  const ExpenseResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExpenseResultViewModel>();
    return Scaffold(appBar: TopAppBar(), body: Column());
  }
}
