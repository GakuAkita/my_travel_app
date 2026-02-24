import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/ui/main/Expenses/main/view_models/expenses_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../../components/BasicText.dart';
import '../../../../../components/Expenses/ExpenseTile.dart';
import '../../../../../components/RoundedButton.dart';
import '../../estimated/EstimatedExpenseScreen.dart';
import '../../result/ExpensesResultScreen.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExpensesViewModel>();
    return LoadingOverlay(
      isLoading: viewModel.isLoading(),
      child:
          viewModel.isLoading()
              ? Center(child: Text("loading..."))
              : viewModel.travel != null
              ? RefreshIndicator(
                onRefresh: () async {
                  print("^^^^^ExpensesScreen: onRefresh called^^^^^^^");
                  final result = await viewModel.getAllExpensesWithNotify(
                    isStateNotify: false,
                  );
                  /* 失敗したらSnackBarを出す */
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedButton(
                            title: "割り勘確認",
                            enabled: viewModel.allExpensesList().isNotEmpty,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                ExpensesResultScreen.id,
                              );
                            },
                          ),
                          /* 総監督とAdminだけは見れる */
                          ...[
                            SizedBox(width: 10),
                            RoundedButton(
                              title: "費用概算",
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  EstimatedExpenseScreen.id,
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    viewModel.allExpensesList().isNotEmpty
                        ? Expanded(
                          child: ListView.builder(
                            itemCount: viewModel.allExpensesList().length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ExpenseTile(
                                expense: viewModel.allExpensesList()[index],
                                members:
                                    viewModel
                                        .allGroupMembers /* viewModel内でStateを監視して取る */,
                              );
                            },
                          ),
                        )
                        : BasicText(text: "費用が何も記録されていません"),
                  ],
                ),
              )
              : Center(
                child: BasicText(text: "Settings画面より表示旅行を選択してください。"),
              ) /* travelが選択されていない */,
    );
  }
}
