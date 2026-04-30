import 'package:flutter/material.dart';
import 'package:my_travel_app/ui/main/expenses/estimated/view_models/estimated_expense_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../../components/BasicTextField.dart';
import '../../../../../components/NumberField.dart';
import '../../../../../data/model/estimated_expense/estimated_expense_info.dart';
import '../../../../core/ui/top_app_bar.dart';

class EstimatedExpenseScreen extends StatefulWidget {
  const EstimatedExpenseScreen({super.key});

  @override
  State<EstimatedExpenseScreen> createState() => _EstimatedExpenseScreenState();
}

class _EstimatedExpenseScreenState extends State<EstimatedExpenseScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /* 計算する */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<EstimatedExpenseViewModel>();
      viewModel.createEstimatedExpensesFromItinerary(isNotify: true);
      viewModel.createEstimatedExpenseListFromManual();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EstimatedExpenseViewModel>();
    return Scaffold(
      appBar: TopAppBar(automaticallyImplyLeading: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...viewModel.estimatedExpenseListFromItinerary.map((estimated) {
              return EstimatedExpenseRow(
                initialEstimated: estimated,
                isAdjustable: false,
                onValueChanged: (estimated) {},
              );
            }),
            Text("合計:${viewModel.estimatedExpenseFromItinerary}"),

            SizedBox(height: 20),
            viewModel.isLoading
                ? CircularProgressIndicator()
                : Column(
                  children: [
                    Text("===========手動で入力============"),
                    Text("使うもの | 総額 | 人数 | 一人当たりの金額"),
                    Column(
                      children: [
                        ...viewModel.estimatedExpenseListFromManual.asMap().entries.map((entry) {
                          final index = entry.key;
                          final estimated = entry.value;
                          return EstimatedExpenseRow(
                            initialEstimated: estimated,
                            isAdjustable: true,
                            onValueChanged: (val) {},
                            onDelete: (val) {},
                          );
                        }),
                      ],
                    ),
                  ],
                ),
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
    // TODO: implement initState
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child:
                    widget.isAdjustable
                        ? BasicTextField(
                          hintText: "",
                          initialValue: widget.initialEstimated.expenseItem,
                          controller: _expenseItemController,
                          onChanged: (item) {
                            _estimatedNotifier.value = _estimatedNotifier.value.copyWith(expenseItem: item);
                            widget.onValueChanged(_estimatedNotifier.value);
                          },
                        )
                        : Text("${widget.initialEstimated.expenseItem}"),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child:
                    widget.isAdjustable
                        ? NumberField(
                          initialValue: widget.initialEstimated.amount,
                          controller: _amountController,
                          onChanged: (value) {
                            _estimatedNotifier.value = _estimatedNotifier.value.copyWith(amount: value);
                            widget.onValueChanged(_estimatedNotifier.value);
                          },
                        )
                        : Text("${widget.initialEstimated.amount}"),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 2,
                child:
                    widget.isAdjustable
                        ? NumberField(
                          initialValue: widget.initialEstimated.reimbursedByCnt.toDouble(),
                          controller: _reimbursedByCntController,
                          onChanged: (value) {
                            int intVal = value.toInt();

                            final updatedEstimated = _estimatedNotifier.value.copyWith(
                              reimbursedByCnt: intVal,
                            );
                            _estimatedNotifier.value = updatedEstimated;
                            if (intVal < 1) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(const SnackBar(content: Text("人数は1〜99人までです。")));
                              widget.onValueChanged(updatedEstimated.copyWith(reimbursedByCnt: 1));
                            } else if (intVal > 99) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(const SnackBar(content: Text("人数は1〜99人までです。")));
                              widget.onValueChanged(updatedEstimated.copyWith(reimbursedByCnt: 99));
                            } else {
                              widget.onValueChanged(updatedEstimated);
                            }
                            print("_estimatedNotifier.value: ${_estimatedNotifier.value}");
                          },
                          minValue: 1,
                          maxValue: 99,
                          intOnly: true,
                        )
                        : Text("${widget.initialEstimated.reimbursedByCnt}"),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 2,
                child: ValueListenableBuilder(
                  //総額や人数が変わったときだけ表示更新
                  valueListenable: _estimatedNotifier,
                  builder: (context, value, child) {
                    return Text(
                      _estimatedNotifier.value.reimbursedByCnt == 0
                          ? "-"
                          : (_estimatedNotifier.value.amount / _estimatedNotifier.value.reimbursedByCnt)
                              .toStringAsFixed(1),
                    );
                  },
                ),
              ),
              if (widget.onDelete != null)
                Flexible(
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: () {
                      widget.onDelete!(_estimatedNotifier.value);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Icon(Icons.delete),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
