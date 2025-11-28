import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/Store/ExpenseStore.dart';
import 'package:my_travel_app/screens/Main/Expenses/EstimatedExpenseScreen.dart';
import 'package:provider/provider.dart';

import '../../../Store/UserStore.dart';
import '../../../components/BasicText.dart';
import '../../../components/Expenses/ExpenseTile.dart';
import '../../../components/RoundedButton.dart';
import '../../../constants.dart';
import 'ExpensesResultScreen.dart';

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
    final userStore = Provider.of<UserStore>(context);
    final expenseStore = Provider.of<ExpenseStore>(context);
    return LoadingOverlay(
      isLoading: expenseStore.expenseState.isLoading,
      child:
          expenseStore.expenseState.isLoading
              ? Center(child: Text("loading..."))
              : expenseStore.shownTravelBasic != null &&
                  expenseStore.shownTravelBasic?.travelId != null
              ? RefreshIndicator(
                onRefresh: () async {
                  print("^^^^^ExpensesScreen: onRefresh called^^^^^^^");
                  await expenseStore.loadAllExpenseDataWithNotify(
                    expenseStore.shownTravelBasic,
                    isStateNotify: false,
                  );
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
                            enabled: expenseStore.allExpenses.isNotEmpty,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                ExpensesResultScreen.id,
                              );
                            },
                          ),
                          if (userStore.isGManager ||
                              userStore.userRole == UserRole.admin) ...[
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
                    expenseStore.allExpenses.isNotEmpty
                        ? Expanded(
                          child: ListView.builder(
                            itemCount: expenseStore.allExpenses.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ExpenseTile(
                                expense: expenseStore.allExpenses[index],
                                members: expenseStore.allParticipants,
                              );
                            },
                          ),
                        )
                        : BasicText(text: "費用が何も記録されていません"),
                  ],
                ),
              )
              : Center(child: BasicText(text: "Settings画面より表示旅行を選択してください。")),
    );
  }
}
