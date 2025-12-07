import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_travel_app/CommonClass/ExpenseInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/Services/FirebaseDatabaseService.dart';
import 'package:my_travel_app/Store/ExpenseStore.dart';
import 'package:my_travel_app/Store/ItineraryStore.dart';
import 'package:my_travel_app/components/BasicTextField.dart';
import 'package:my_travel_app/components/NumberField.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/components/TopAppBar.dart';
import 'package:my_travel_app/constants.dart';
import 'package:my_travel_app/utils/CheckShownTravelBasic.dart';
import 'package:provider/provider.dart';

import '../../../CommonClass/ErrorInfo.dart';

class EstimatedExpenseScreen extends StatefulWidget {
  static const String id = "estimated_expense_screen";

  const EstimatedExpenseScreen({super.key});

  @override
  State<EstimatedExpenseScreen> createState() => _EstimatedExpenseScreenState();
}

class _EstimatedExpenseScreenState extends State<EstimatedExpenseScreen> {
  final List<EstimatedExpenseInfo> estimatedListFromItinerary = [];
  List<EstimatedExpenseInfo> estimatedListFromManual = [];
  Map<String, EstimatedExpenseInfo>? estimatedMapFromManual = null;
  final List<EstimatedExpenseInfo> estimatedExpenseList = [];

  double estimatedExpense = 0.0;
  double estimatedExpenseFromManual = 0.0;
  double estimatedExpenseFromItinerary = 0.0;

  ResultInfo _createEstimatedListFromItinerary() {
    final itineraryStore = context.read<ItineraryStore>();
    final tables =
        itineraryStore
            .getData()
            .where((s) => s.type == ItinerarySectionType.defaultTable)
            .toList();

    final expenseStore = context.read<ExpenseStore>();
    final people = expenseStore.allParticipants.length;

    /* 一番右の列で"****円/○人を正規表現で取得する */
    final expenseReg = RegExp(r'(\d+)円/(\d+)?人');
    final etcReg = RegExp(r'ETC([^\d]?)(\d+)円', caseSensitive: false);

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

          final etcMatches = etcReg.allMatches(row[1]);
          for (final match in etcMatches) {
            final amount = double.parse(match.group(2)!);
            final etcEstimated = EstimatedExpenseInfo(
              expenseItem: "ETC",
              amount: amount,
              reimbursedByCnt: people,
            );
            estimatedListFromItinerary.add(etcEstimated);
          }
        }
      }
    }

    /* 真ん中の列からETC料金を抽出 */

    setState(() {});

    Future.microtask(() async {
      final createListRet = await _loadEstimatedExpenseFromManual();
      _createEstimatedListFromManual();
      _sumEstimatedExpenseList();
      setState(() {});
    });

    _sumEstimatedExpenseList();

    return ResultInfo.success();
  }

  Future<ResultInfo> _loadEstimatedExpenseFromManual() async {
    final itineraryStore = context.read<ItineraryStore>();
    final shownTravel = itineraryStore.shownTravelBasic;

    if (!checkIsShownTravelInput(shownTravel).isSuccess) {
      return ResultInfo.failed(
        error: ErrorInfo(
          errorCode: "invalid-travel-basic",
          errorMessage:
              "Invalid travel basic data. This is the bug. Let the developer know.",
        ),
      );
    }

    final groupId = shownTravel!.groupId!;
    final travelId = shownTravel.travelId!;

    final estRet =
        await FirebaseDatabaseService.getSingleTravelEstimatedExpenses(
          groupId,
          travelId,
        );
    if (!estRet.isSuccess) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "${estRet.error?.errorMessage}"),
      );
    }

    if (estRet.data == null) {
      estimatedMapFromManual = null;
    } else {
      estimatedMapFromManual = estRet.data;
    }
    return ResultInfo.success();
  }

  ResultInfo _createEstimatedListFromManual() {
    final itineraryStore = context.read<ItineraryStore>();
    final tables =
        itineraryStore
            .getData()
            .where((s) => s.type == ItinerarySectionType.defaultTable)
            .toList();

    final expenseStore = context.read<ExpenseStore>();
    final people = expenseStore.allParticipants.length;

    /* デーブルの数を日数として仮定して計算。かつ、昼食夕食がホテルについてないとする */
    final days = tables.length.toDouble();

    if (estimatedMapFromManual == null) {
      /* まだ何もなかったら、夕食と昼食をリストに加えておく */
      DateTime now = DateTime.now();
      final formatForId = DateFormat('yyyyMMdd-HHmmSS');
      final nowStr = formatForId.format(now);

      final lunch = EstimatedExpenseInfo(
        id: "default_lunch_${nowStr}",
        amount: 2000 * days,
        expenseItem: "昼食",
        reimbursedByCnt: 1,
      );

      final dinner = EstimatedExpenseInfo(
        id: "default_dinner_${nowStr}",
        expenseItem: "夕食",
        amount: 3000 * days,
        reimbursedByCnt: 1,
      );

      final gasoline = EstimatedExpenseInfo(
        id: "default_gasoline_${nowStr}",
        expenseItem: "ガソリン",
        amount: 3000,
        reimbursedByCnt: people,
      );

      estimatedListFromManual.add(lunch);
      estimatedListFromManual.add(dinner);
      estimatedListFromManual.add(gasoline);
    } else {
      /* すでに保存されている場合はMapをListにすればよいだけ */
      for (final entry in estimatedMapFromManual!.entries) {
        estimatedListFromManual.add(entry.value);
      }
    }
    return ResultInfo.success();
  }

  void _sumEstimatedExpenseList() {
    estimatedExpense = 0;
    estimatedExpenseFromManual = 0.0;
    estimatedExpenseFromItinerary = 0;
    for (final est in estimatedListFromItinerary) {
      //print(est.amount);
      estimatedExpenseFromItinerary += (est.amount / est.reimbursedByCnt);
    }

    for (final est in estimatedListFromManual) {
      estimatedExpenseFromManual += (est.amount / est.reimbursedByCnt);
    }

    estimatedExpense =
        estimatedExpenseFromItinerary + estimatedExpenseFromManual;
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
                (estimated) => EstimatedExpenseRow(
                  initialEstimated: estimated,
                  isAdjustable: false,
                  onValueChanged: (estimated) {
                    /* Do nothing */
                  },
                ),
              ),

              Text("行程表合計:${estimatedExpenseFromItinerary.toInt()}"),

              Text("===========手動で入力============"),
              Text("使うもの | 総額 | 人数 | 一人当たりの金額"),
              /* 概算に加えたくない場合は0円で入力 */
              ...estimatedListFromManual.map(
                (estimated) => EstimatedExpenseRow(
                  initialEstimated: estimated,
                  isAdjustable: true,
                  onValueChanged: (newEstimated) {
                    print("${newEstimated.id} ${newEstimated.expenseItem}");
                  },
                ),
              ),

              Text("手動合計:${estimatedExpenseFromManual.toInt()}"),
              Text("============================="),
              Text("すべての合計=${estimatedExpense}"),
              RoundedButton(title: "このデータを記録", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class EstimatedExpenseRow extends StatefulWidget {
  final EstimatedExpenseInfo initialEstimated;
  final bool isAdjustable;
  final Function(EstimatedExpenseInfo) onValueChanged;

  const EstimatedExpenseRow({
    required this.initialEstimated,
    required this.isAdjustable,
    required this.onValueChanged,
    super.key,
  });

  @override
  State<EstimatedExpenseRow> createState() => _EstimatedExpenseRowState();
}

class _EstimatedExpenseRowState extends State<EstimatedExpenseRow> {
  EstimatedExpenseInfo estimated = EstimatedExpenseInfo(
    expenseItem: "not initialized!!!",
    amount: 0,
    reimbursedByCnt: 1,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("ExpenseRowState initialized!!");
    estimated = widget.initialEstimated;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        onChanged: (item) {
                          estimated = estimated.copyWith(expenseItem: item);
                          widget.onValueChanged(estimated);
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
                        onChanged: (value) {
                          estimated = estimated.copyWith(amount: value);
                          widget.onValueChanged(estimated);
                        },
                      )
                      : Text("${widget.initialEstimated.amount}"),
            ),
            Flexible(
              fit: FlexFit.tight,
              child:
                  widget.isAdjustable
                      ? NumberField(
                        initialValue:
                            widget.initialEstimated.reimbursedByCnt.toDouble(),
                        onChanged: (value) {
                          int intVal = value.toInt();
                          estimated = estimated.copyWith(
                            reimbursedByCnt: intVal,
                          );
                          widget.onValueChanged(estimated);
                        },
                        intOnly: true,
                      )
                      : Text("${widget.initialEstimated.reimbursedByCnt}"),
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
