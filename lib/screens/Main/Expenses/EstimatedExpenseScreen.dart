import 'package:flutter/material.dart';
import 'package:my_travel_app/CommonClass/ExpenseInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/Store/ItineraryStore.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/components/TopAppBar.dart';
import 'package:my_travel_app/constants.dart';
import 'package:provider/provider.dart';

import '../../../components/NumberField.dart';

class EstimatedExpenseScreen extends StatefulWidget {
  static const String id = "estimated_expense_screen";

  const EstimatedExpenseScreen({super.key});

  @override
  State<EstimatedExpenseScreen> createState() => _EstimatedExpenseScreenState();
}

class _EstimatedExpenseScreenState extends State<EstimatedExpenseScreen> {
  final List<EstimatedExpenseInfo> estimatedListFromItinerary = [];
  final List<EstimatedExpenseInfo> estimatedListFromManual = [];
  final List<EstimatedExpenseInfo> estimatedExpenseList = [];

  double estimatedExpense = 0.0;

  ResultInfo _createEstimatedListFromItinerary() {
    final itineraryStore = context.read<ItineraryStore>();
    final tables =
        itineraryStore
            .getData()
            .where((s) => s.type == ItinerarySectionType.defaultTable)
            .toList();

    /* 一番右の列で"****円/○人を正規表現で取得する */
    final expenseReg = RegExp(r'(\d+)円/(\d+)?人');

    /* 一番右の列から***円/○人を抽出 */
    for (final table in tables) {
      final tableData = table.tableData;
      if (tableData != null) {
        for (final row in tableData.tableCells) {
          final expenseMatches = expenseReg.allMatches(row[2]);
          for (final match in expenseMatches) {
            print("${match.group(0)} | ${match.group(1)} | ${match.group(2)}");
            final amount = double.parse(match.group(1)!);
            final peopleCnt = int.parse(match.group(2) ?? "1");
            String firstLine = row[1].toString().split('\n').first;

            // Markdownのリンク表示 `[text](url)` から text のみを抽出
            // 例: "[Google](https://google.com)" -> "Google"
            String expenseItemStr = firstLine.replaceAllMapped(
              RegExp(r'\[(.*?)\]\(.*?\)'),
              (match) => match.group(1)!,
            );

            // Markdownの見出し `# heading` から `#` を削除
            // 例: "## 新宿" -> "新宿"
            expenseItemStr =
                expenseItemStr.replaceAll(RegExp(r'^[#]+\s*'), '').trim();

            /* expenseStoreと中身検知して逆算するのはありかもな。 */
            final estimated = EstimatedExpenseInfo(
              id: "",
              expenseItem: expenseItemStr,
              amount: amount,
              reimbursedByCnt: peopleCnt,
            );

            estimatedListFromItinerary.add(estimated);
          }
        }
      }
    }

    /* 真ん中の列からETC料金を抽出 */

    setState(() {});

    return ResultInfo.success();
  }

  Future<ResultInfo> _loadEstimatedExpenseFromManual() async {
    return ResultInfo.success();
  }

  Future<ResultInfo> _createEstimatedListFromManual() async {
    return ResultInfo.success();
  }

  void _sumEstimatedExpenseList() {
    final itineraryStore = context.read<ItineraryStore>();
    final tables =
        itineraryStore
            .getData()
            .where((s) => s.type == ItinerarySectionType.defaultTable)
            .toList();

    estimatedExpense = 0;

    for (final est in estimatedListFromItinerary) {
      //print(est.amount);
      estimatedExpense += (est.amount / est.reimbursedByCnt);
    }

    /* 昼ご飯と夕食をそれぞれ2000円,3000円で計算 */
    //print("テーブルの数(=工程の数) = ${tables.length}");
    final lunchTotal = 2000 * tables.length;
    estimatedExpense += lunchTotal;

    final dinnerTotal = 3000 * tables.length;
    estimatedExpense += dinnerTotal;

    setState(() {});
  }

  /* 費用概算は工程表を元に計算してく */
  @override
  void initState() {
    super.initState();
    _createEstimatedListFromItinerary();

    /* 非同期で待ってから最後にsumをする */
    _sumEstimatedExpenseList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(title: "費用概算(作成中)", automaticallyImplyLeading: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("---------行程表から抽出-----------"),
              //...tables.map((table) => TableDataShown(table: table.tableData)),
              ...estimatedListFromItinerary.map(
                (estimated) => EstimatedExpenseRow(estimated: estimated),
              ),

              Text("===========手動で入力============"),
              /* 概算に加えたくない場合は0円で入力 */

              /* 昼食の値段(予想平均) * 回数(デフォルトは既存データがなければテーブル数) */
              NumberField(
                hintText: "昼食",
                initialValue: 2000,
                onChanged: (value) {
                  print(value);
                },
              ),
              NumberField(
                hintText: "夕食",
                initialValue: 3000,
                onChanged: (value) {},
              ),
              NumberField(
                hintText: "ガソリン代",
                initialValue: 3000,
                onChanged: (value) {},
              ),
              /* 夕食の値段(予想平均) * 回数(デフォルトは基礎データがなければテーブル数) */

              /* ガソリン代 (デフォルトは既存データがなければ参加人数) */
              /* ETC代 */
              Text("============================="),
              Text("予想合計=${estimatedExpense}"),
              RoundedButton(title: "このデータを記録", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class EstimatedExpenseRow extends StatelessWidget {
  final EstimatedExpenseInfo estimated;

  const EstimatedExpenseRow({required this.estimated, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Text(estimated.expenseItem),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Text("${estimated.amount}"),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Text("${estimated.reimbursedByCnt}"),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Text("${estimated.amount / estimated.reimbursedByCnt}"),
            ),
          ],
        ),
      ],
    );
  }
}
