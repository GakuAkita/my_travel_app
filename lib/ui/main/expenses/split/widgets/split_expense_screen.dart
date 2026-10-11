import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/components/BasicTextField.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/main/expenses/split/view_models/split_expense_viewmodel.dart';

/// 1人がまとめて払ったときに、メンバーごとの金額を1画面で入力する
class SplitExpenseScreen extends StatefulWidget {
  final SplitExpenseViewModel viewModel;

  const SplitExpenseScreen({super.key, required this.viewModel});

  @override
  State<SplitExpenseScreen> createState() => _SplitExpenseScreenState();
}

class _SplitExpenseScreenState extends State<SplitExpenseScreen> {
  /* 支払者はuidで持つ(メンバーが再読み込みされてもDropdownの値がずれないように) */
  late String? _payerUid;
  final TextEditingController _commonItemController = TextEditingController();

  /* key: uid。メンバーは後から読み込まれることがあるので、必要になったときに作る */
  final Map<String, TextEditingController> _itemControllers = {};
  final Map<String, TextEditingController> _amountControllers = {};

  TextEditingController _itemController(String uid) => _itemControllers.putIfAbsent(uid, TextEditingController.new);

  TextEditingController _amountController(String uid) =>
      _amountControllers.putIfAbsent(uid, TextEditingController.new);

  @override
  void initState() {
    super.initState();
    /* 支払者は自分 */
    _payerUid = widget.viewModel.uid;
  }

  @override
  void dispose() {
    _commonItemController.dispose();
    for (final controller in [..._itemControllers.values, ..._amountControllers.values]) {
      controller.dispose();
    }
    super.dispose();
  }

  double get _total {
    return widget.viewModel.selectedMembers.fold(
      0,
      (sum, member) => sum + (double.tryParse(_amountController(member.core.uid).text) ?? 0),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _save() async {
    final viewModel = widget.viewModel;
    final result = viewModel.createExpensesFromInput(
      payer: viewModel.memberByUid(_payerUid),
      commonItem: _commonItemController.text,
      inputs: viewModel.selectedMembers
          .map(
            (member) => SplitExpenseInput(
              member: member,
              item: _itemController(member.core.uid).text,
              amount: _amountController(member.core.uid).text,
            ),
          )
          .toList(),
    );
    if (!result.isSuccess || result.data == null) {
      _showSnackBar(result.error?.errorMessage ?? "Unknown Error. It seems to be a coding error.");
      return;
    }

    final expenses = result.data!;
    final saveResult = await viewModel.saveExpenses(expenses);
    if (!mounted) return;
    if (saveResult.isSuccess) {
      _showSnackBar("${expenses.length}件の費用を保存しました");
      context.pop();
    } else {
      _showSnackBar(saveResult.error?.errorMessage ?? "Unknown error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: TopAppBar(automaticallyImplyLeading: true, title: "まとめて追加"),
          body: LoadingOverlay(
            isLoading: viewModel.isSaving,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        DropdownButton<String>(
                          /* メンバーがまだ読み込まれていないときはnull */
                          value: viewModel.memberByUid(_payerUid) != null ? _payerUid : null,
                          hint: Text("支払った人"),
                          items: viewModel.groupMembers.map((member) {
                            return DropdownMenuItem<String>(
                              value: member.core.uid,
                              child: Text(member.displayName, maxLines: 1),
                            );
                          }).toList(),
                          onChanged: (String? uid) {
                            setState(() {
                              _payerUid = uid;
                            });
                          },
                        ),
                        Text(" がまとめて払った"),
                      ],
                    ),
                    BasicTextField(
                      controller: _commonItemController,
                      hintText: "何に使ったか(共通)",
                      onChanged: (_) {
                        /* 各行のヒントを更新する */
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 16),
                    Text("誰の分？"),
                    /* チェックした人の入力欄が追加される */
                    Wrap(
                      spacing: 8,
                      children: viewModel.rowMembers.map((member) {
                        final uid = member.core.uid;
                        return FilterChip(
                          key: ValueKey("select-$uid"),
                          label: Text(member.displayName),
                          selected: viewModel.isSelected(uid),
                          onSelected: (_) => viewModel.toggleMember(uid),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 8),
                    if (viewModel.selectedMembers.isEmpty)
                      Text("メンバーを選ぶと入力欄が追加されます", style: TextStyle(fontSize: 12, color: Colors.white54))
                    else
                      Text("個別の品目は空なら共通の品目になります", style: TextStyle(fontSize: 12, color: Colors.white54)),
                    ...viewModel.selectedMembers.map((member) => _buildMemberRow(member)),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "合計 ¥${NumberFormat("#,###").format(_total.round())}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: RoundedButton(title: "まとめて保存", enabled: !viewModel.isSaving, onPressed: _save),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMemberRow(TravelerBasic member) {
    final uid = member.core.uid;
    final commonItem = _commonItemController.text;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(member.displayName, overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            flex: 3,
            child: BasicTextField(
              key: ValueKey("item-$uid"),
              controller: _itemController(uid),
              hintText: commonItem.isNotEmpty ? commonItem : "品目",
              onChanged: (_) {},
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: BasicTextField(
              key: ValueKey("amount-$uid"),
              controller: _amountController(uid),
              keyboardType: TextInputType.number,
              hintText: "金額",
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              onChanged: (_) {
                /* 合計を更新する */
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
