import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/routing/routes.dart';
import 'package:my_travel_app/ui/main/expenses/main/view_models/expenses_viewmodel.dart';

import '../../../../../core/utils/currency_format.dart';
import '../../../../../data/model/expense/expense_info.dart';
import '../../../../core/ui/empty_state.dart';
import 'add_expense_speed_dial.dart';
import 'expense_tile.dart';

class ExpensesScreen extends StatefulWidget {
  final ExpensesViewModel viewModel;

  const ExpensesScreen({super.key, required this.viewModel});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final isStoreLoading =
            viewModel.isExpensesLoading || !viewModel.expenseStoreInitialized || !viewModel.travelScopeStoreInitialized;
        return LoadingOverlay(
          isLoading: isStoreLoading,
          child: Scaffold(
            floatingActionButton: isStoreLoading || viewModel.isGroupMembersLoading || viewModel.isParticipantsLoading
                ? null
                : AddExpenseSpeedDial(
                    onAddPressed: () {
                      /* 新規作成 */
                      context.push(Routes.expenses_add_edit);
                    },
                    onSplitAddPressed: () {
                      /* 1人がまとめて払ったときにメンバーごとに入力 */
                      context.push(Routes.expenses_split_add);
                    },
                  ),
            body: viewModel.isExpensesLoading
                ? const SizedBox.expand()
                : viewModel.currentTravel != null
                ? _buildExpenseList(context, viewModel)
                : const EmptyState(
                    /* travelが選択されていない */
                    icon: Icons.luggage_outlined,
                    message: "表示する旅行が選択されていません",
                    hint: "Settings画面より表示旅行を選択してください",
                  ),
          ),
        );
      },
    );
  }

  Widget _buildExpenseList(BuildContext context, ExpensesViewModel viewModel) {
    final expenses = viewModel.allExpensesList();
    return RefreshIndicator(
      onRefresh: () async {
        print("^^^^^ExpensesScreen: onRefresh called^^^^^^^");
        viewModel.refreshExpenses(isLoadingNotify: false);
        viewModel.refreshParticipants(isLoadingNotify: false);
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _ExpenseSummaryCard(
              expenses: expenses,
              onResultPressed: () => context.push(Routes.expenses_result),
              onEstimatePressed: viewModel.canViewEstimatedExpense()
                  ? () => context.push(Routes.estimated_expense)
                  : null,
            ),
          ),
          if (expenses.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(icon: Icons.receipt_long_outlined, message: "費用が何も記録されていません", hint: "右下の＋ボタンから追加できます"),
            )
          else
            SliverPadding(
              /* FABに最後の項目が隠れないようにする */
              padding: const EdgeInsets.only(top: 4, bottom: 96),
              sliver: SliverList.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return ExpenseTile(
                    expense: expense,
                    members: viewModel.allGroupMembers ?? {} /* viewModel内でStateを監視して取る */,
                    onTap: () {
                      print("onTap called. Expense Id = ${expense.id}");
                      context.push(Routes.expenses_add_edit, extra: expense.id);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// 支出の合計と、割り勘確認・費用概算への導線
class _ExpenseSummaryCard extends StatelessWidget {
  final List<ExpenseInfo> expenses;
  final VoidCallback onResultPressed;
  /* nullのときは費用概算ボタンを出さない(プランナーとAdminだけは見れる) */
  final VoidCallback? onEstimatePressed;

  const _ExpenseSummaryCard({required this.expenses, required this.onResultPressed, this.onEstimatePressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final total = expenses.fold<double>(0, (sum, e) => sum + e.expense);
    final labelStyle = TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant);

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("支出合計", style: labelStyle),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          formatYen(total),
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("件数", style: labelStyle),
                    const SizedBox(height: 2),
                    Text("${expenses.length}件", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: expenses.isNotEmpty ? onResultPressed : null,
                    icon: const Icon(Icons.balance),
                    label: const Text("割り勘確認"),
                  ),
                ),
                if (onEstimatePressed != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEstimatePressed,
                      icon: const Icon(Icons.calculate_outlined),
                      label: const Text("費用概算"),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
