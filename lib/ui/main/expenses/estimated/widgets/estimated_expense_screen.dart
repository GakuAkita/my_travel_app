import 'package:flutter/material.dart';
import 'package:my_travel_app/ui/main/expenses/estimated/view_models/estimated_expense_viewmodel.dart';

import '../../../../../components/BasicTextField.dart';
import '../../../../../components/NumberField.dart';
import '../../../../../core/utils/currency_format.dart';
import '../../../../../data/model/estimated_expense/estimated_expense_info.dart';
import '../../../../core/ui/bottom_action_bar.dart';
import '../../../../core/ui/section_header.dart';
import '../../../../core/ui/top_app_bar.dart';

class EstimatedExpenseScreen extends StatefulWidget {
  final EstimatedExpenseViewModel viewModel;

  const EstimatedExpenseScreen({super.key, required this.viewModel});

  @override
  State<EstimatedExpenseScreen> createState() => _EstimatedExpenseScreenState();
}

class _EstimatedExpenseScreenState extends State<EstimatedExpenseScreen> {
  @override
  void initState() {
    super.initState();

    /* 計算する */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = widget.viewModel;
      viewModel.createEstimatedExpensesFromItinerary(isNotify: true);
      viewModel.createEstimatedExpenseListFromManual();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _save() async {
    final viewModel = widget.viewModel;
    final precheck = viewModel.saveEstimatedExpensesListFromManualPreCheck();
    if (!precheck.isSuccess) {
      _showSnackBar(precheck.error?.errorMessage ?? "");
      return;
    }
    print("precheck OK");

    final ret = await viewModel.saveEstimatedExpensesListFromManual();
    if (!mounted) return;
    _showSnackBar(ret.isSuccess ? "保存に成功しました" : "${ret.error?.errorMessage}");
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final colorScheme = Theme.of(context).colorScheme;
        final hintStyle = TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant);
        final fromItinerary = viewModel.estimatedExpenseListFromItinerary;
        final fromManual = viewModel.estimatedExpenseListFromManual;

        return Scaffold(
          appBar: TopAppBar(title: "費用概算", automaticallyImplyLeading: true),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _EstimateSummaryCard(
                total: viewModel.sumFromItinerary() + viewModel.sumFromManual(),
                fromItinerary: viewModel.sumFromItinerary(),
                fromManual: viewModel.sumFromManual(),
              ),
              const SizedBox(height: 16),
              SectionHeader(
                icon: Icons.menu_book_outlined,
                title: "しおりから",
                trailing: "1人 ${formatYen(viewModel.sumFromItinerary())}",
              ),
              Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                child: fromItinerary.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text("しおりから計算できる項目はありません", style: hintStyle),
                      )
                    : Column(
                        children: [
                          for (int i = 0; i < fromItinerary.length; i++) ...[
                            if (i > 0) const Divider(height: 1, indent: 16, endIndent: 16),
                            EstimatedExpenseRow(
                              initialEstimated: fromItinerary[i],
                              isAdjustable: false,
                              onValueChanged: (estimated) {},
                            ),
                          ],
                        ],
                      ),
              ),
              const SizedBox(height: 20),
              SectionHeader(
                icon: Icons.edit_outlined,
                title: "手動で入力",
                trailing: "1人 ${formatYen(viewModel.sumFromManual())}",
              ),
              if (viewModel.isLoading)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                  child: Text("総額を人数で割った金額が1人あたりの概算になります", style: hintStyle),
                ),
                ...fromManual.asMap().entries.map((entry) {
                  final index = entry.key;
                  final estimated = entry.value;
                  return EstimatedExpenseRow(
                    /* 削除したときに別の行の入力が残らないようにidで区別する */
                    key: ValueKey(estimated.id),
                    initialEstimated: estimated,
                    isAdjustable: true,
                    onValueChanged: (val) {
                      viewModel.updateEstimatedExpense(index: index, estimated: val);
                    },
                    onDelete: (val) {
                      viewModel.removeEstimatedExpenseFromManualAt(index);
                    },
                  );
                }),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: () {
                    viewModel.addEStimatedExpenseFromManual();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("項目を追加"),
                ),
              ],
            ],
          ),
          bottomNavigationBar: BottomActionBar(
            label: viewModel.isSavingLoading ? "保存中…" : "保存",
            onPressed: viewModel.isLoading || viewModel.isSavingLoading ? null : _save,
          ),
        );
      },
    );
  }
}

/// 1人あたりの概算の合計
class _EstimateSummaryCard extends StatelessWidget {
  final double total;
  final double fromItinerary;
  final double fromManual;

  const _EstimateSummaryCard({required this.total, required this.fromItinerary, required this.fromManual});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final labelStyle = TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("1人あたりの概算", style: labelStyle),
            const SizedBox(height: 2),
            Text(
              formatYen(total),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Text("しおりから ${formatYen(fromItinerary)} + 手動 ${formatYen(fromManual)}", style: labelStyle),
          ],
        ),
      ),
    );
  }
}

class EstimatedExpenseRow extends StatefulWidget {
  final EstimatedExpenseInfo initialEstimated;
  final bool isAdjustable;
  final Function(EstimatedExpenseInfo) onValueChanged;
  final Function(EstimatedExpenseInfo)? onDelete;

  const EstimatedExpenseRow({
    required this.initialEstimated,
    required this.isAdjustable,
    required this.onValueChanged,
    this.onDelete,
    super.key,
  });

  @override
  State<EstimatedExpenseRow> createState() => _EstimatedExpenseRowState();
}

class _EstimatedExpenseRowState extends State<EstimatedExpenseRow> {
  late final ValueNotifier<EstimatedExpenseInfo> _estimatedNotifier;
  final TextEditingController _expenseItemController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reimbursedByCntController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _estimatedNotifier = ValueNotifier(widget.initialEstimated);

    /* expenseItemだけはControllerを渡すだけではだめで、初期値を入れておかないといけない */
    /* NumberFieldを使っていないから */
    _expenseItemController.text = widget.initialEstimated.expenseItem;
  }

  @override
  void dispose() {
    _estimatedNotifier.dispose();
    _expenseItemController.dispose();
    _amountController.dispose();
    _reimbursedByCntController.dispose();
    super.dispose();
  }

  String _perPerson(EstimatedExpenseInfo value) {
    return value.reimbursedByCnt == 0 ? "-" : formatYen(value.amount / value.reimbursedByCnt);
  }

  void _onCountChanged(double value) {
    int intVal = value.toInt();

    final updatedEstimated = _estimatedNotifier.value.copyWith(reimbursedByCnt: intVal);
    _estimatedNotifier.value = updatedEstimated;
    if (intVal < 1) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("人数は1〜99人までです。")));
      widget.onValueChanged(updatedEstimated.copyWith(reimbursedByCnt: 1));
    } else if (intVal > 99) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("人数は1〜99人までです。")));
      widget.onValueChanged(updatedEstimated.copyWith(reimbursedByCnt: 99));
    } else {
      widget.onValueChanged(updatedEstimated);
    }
    print("_estimatedNotifier.value: ${_estimatedNotifier.value}");
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final estimated = widget.initialEstimated;

    if (!widget.isAdjustable) {
      /* しおりから計算した行は表示だけ */
      return ListTile(
        title: Text(estimated.expenseItem),
        subtitle: Text(
          "${formatYen(estimated.amount)} ÷ ${estimated.reimbursedByCnt}人",
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        trailing: Text(_perPerson(estimated), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: BasicTextField(
                    labelText: "使うもの",
                    hintText: "",
                    initialValue: estimated.expenseItem,
                    controller: _expenseItemController,
                    onChanged: (item) {
                      _estimatedNotifier.value = _estimatedNotifier.value.copyWith(expenseItem: item);
                      widget.onValueChanged(_estimatedNotifier.value);
                    },
                  ),
                ),
                if (widget.onDelete != null)
                  IconButton(
                    tooltip: "削除",
                    icon: Icon(Icons.delete_outline, color: colorScheme.error),
                    onPressed: () {
                      widget.onDelete!(_estimatedNotifier.value);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: NumberField(
                      labelText: "総額",
                      prefixText: "¥ ",
                      initialValue: estimated.amount,
                      controller: _amountController,
                      onChanged: (value) {
                        _estimatedNotifier.value = _estimatedNotifier.value.copyWith(amount: value);
                        widget.onValueChanged(_estimatedNotifier.value);
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text("÷")),
                  Expanded(
                    flex: 3,
                    child: NumberField(
                      labelText: "人数",
                      suffixText: "人",
                      initialValue: estimated.reimbursedByCnt.toDouble(),
                      controller: _reimbursedByCntController,
                      onChanged: _onCountChanged,
                      minValue: 1,
                      maxValue: 99,
                      intOnly: true,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text("=")),
                  Expanded(
                    flex: 3,
                    child: ValueListenableBuilder(
                      //総額や人数が変わったときだけ表示更新
                      valueListenable: _estimatedNotifier,
                      builder: (context, value, child) {
                        return Text(
                          _perPerson(value),
                          textAlign: TextAlign.end,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
