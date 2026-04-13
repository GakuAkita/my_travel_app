import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/routing/routes.dart';
import 'package:my_travel_app/ui/main/Expenses/main/view_models/expenses_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../../components/BasicText.dart';
import '../../../../../components/RoundedButton.dart';
import 'expense_tile.dart';

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
      isLoading:
          viewModel.isExpensesLoading ||
          !viewModel.expenseStoreInitialized ||
          !viewModel.travelScopeStoreInitialized,
      child: Scaffold(
        floatingActionButton:
            viewModel.isExpensesLoading ||
                    !viewModel.expenseStoreInitialized ||
                    !viewModel.travelScopeStoreInitialized ||
                    viewModel.isGroupMembersLoading ||
                    viewModel.isParticipantsLoading
                ? null
                : FloatingActionButton(
                  onPressed: () {
                    /* 新規作成 */
                    context.push(Routes.expenses_add_edit);
                  },
                ),
        body:
            viewModel.isExpensesLoading
                ? Center(child: Text("loading..."))
                : viewModel.currentTravel != null
                ? RefreshIndicator(
                  onRefresh: () async {
                    print("^^^^^ExpensesScreen: onRefresh called^^^^^^^");
                    viewModel.refreshExpenses(isLoadingNotify: false);
                    viewModel.refreshParticipants(isLoadingNotify: false);
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
                                context.push(Routes.expenses_result);
                              },
                            ),
                            /* プランナーとAdminだけは見れる */
                            ...[
                              SizedBox(width: 10),
                              RoundedButton(
                                title: "費用概算",
                                onPressed: () {
                                  print("まだ実装されていません");
                                  // for (final i
                                  //     in viewModel.allGroupMembers.entries) {
                                  //   print("${i.value.profile_name}");
                                  // }
                                  // Navigator.pushNamed(
                                  //   context,
                                  //   EstimatedExpenseScreen.id,
                                  // );
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
                                final expense =
                                    viewModel.allExpensesList()[index];
                                return ExpenseTile(
                                  expense: expense,
                                  members:
                                      viewModel.allGroupMembers ??
                                      {} /* viewModel内でStateを監視して取る */,
                                  onTap: () {
                                    print(
                                      "onTap called. Expense Id = ${expense.id}",
                                    );
                                    context.push(
                                      Routes.expenses_add_edit,
                                      extra: expense.id,
                                    );
                                  },
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
      ),
    );
  }
}
