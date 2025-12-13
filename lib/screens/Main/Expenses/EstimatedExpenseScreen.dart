import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_travel_app/CommonClass/ExpenseInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/Services/FirebaseDatabaseService.dart';
import 'package:my_travel_app/Store/ExpenseStore.dart';
import 'package:my_travel_app/Store/ItineraryStore.dart';
import 'package:my_travel_app/components/BasicTextField.dart';
import 'package:my_travel_app/components/CircleIconButton.dart';
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
  List<EstimatedExpenseInfo>? estimatedListFromManual = [];
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
        await FirebaseDatabaseService.getSingleTravelEstimatedExpensesData(
          groupId,
          travelId,
        );
    if (!estRet.isSuccess) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "${estRet.error?.errorMessage}"),
      );
    }

    final lastUpdateRet =
        await FirebaseDatabaseService.getSingleTravelEstimatedUpdateDate(
          groupId,
          travelId,
        );
    if (!lastUpdateRet.isSuccess) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "${lastUpdateRet.error?.errorMessage}"),
      );
    }

    if (lastUpdateRet.data == null) {
      /* まだ一度も保存されていない */
      estimatedListFromManual = null;
    } else if (estRet.data == null) {
      estimatedListFromManual = [];
    } else {
      estimatedListFromManual = estRet.data;
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

    if (estimatedListFromManual == null) {
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

      estimatedListFromManual = [];
      estimatedListFromManual?.add(lunch);
      estimatedListFromManual?.add(dinner);
      estimatedListFromManual?.add(gasoline);
      setState(() {});
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

    if (estimatedListFromManual != null) {
      for (final est in estimatedListFromManual!) {
        estimatedExpenseFromManual += (est.amount / est.reimbursedByCnt);
      }
    }

    setState(() {
      estimatedExpense =
          estimatedExpenseFromItinerary + estimatedExpenseFromManual;
    });
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
    final itineraryStore = context.read<ItineraryStore>();
    final shownTravel = itineraryStore.shownTravelBasic;
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
                  /* onDeleteは必要ない */
                ),
              ),

              Text("行程表合計:${estimatedExpenseFromItinerary.toInt()}"),

              Text("===========手動で入力============"),
              Text("使うもの | 総額 | 人数 | 一人当たりの金額"),
              /* 概算に加えたくない場合は0円で入力 */
              if (estimatedListFromManual != null)
                Column(
                  children: List.generate(estimatedListFromManual!.length, (
                    index,
                  ) {
                    return EstimatedExpenseRow(
                      initialEstimated: estimatedListFromManual![index],
                      isAdjustable: true,
                      onValueChanged: (newEstimated) {
                        print(
                          "$index -> ${newEstimated.id} ${newEstimated.expenseItem} ${newEstimated.reimbursedByCnt}",
                        );
                        // print(
                        //   "if the controller text is empty, onChanged might not be executed..",
                        // );
                        estimatedListFromManual![index] = newEstimated;
                        _sumEstimatedExpenseList();
                      },
                      onDelete: (estimated) {
                        print(
                          "Deleted ${estimated.expenseItem} ${estimated.amount}",
                        );
                        setState(() {
                          estimatedListFromManual!.removeAt(index);
                          _sumEstimatedExpenseList();
                        });
                      },
                    );
                  }),
                ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleIconButton(
                  icon: Icons.add,
                  onPressed: () {
                    final emptyEstimated = EstimatedExpenseInfo(
                      id: "",
                      expenseItem: "",
                      amount: 0,
                      reimbursedByCnt: 1,
                    );

                    if (estimatedListFromManual == null) {
                      estimatedListFromManual = [emptyEstimated];
                    } else {
                      estimatedListFromManual!.add(emptyEstimated);
                    }
                    _sumEstimatedExpenseList();
                    setState(() {});
                  },
                  radius: 40,
                ),
              ),

              Text("手動合計:${estimatedExpenseFromManual.toInt()}"),
              Text("============================="),
              Text("すべての合計=${estimatedExpense}"),
              RoundedButton(
                title: "このデータを記録",
                onPressed: () async {
                  if (estimatedListFromManual == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("estimatedListFromManualがnullです"),
                      ),
                    );
                    return;
                  }
                  /* ここで配列ごとFirebaseに入れてしまう */
                  for (final est in estimatedListFromManual!) {
                    if (est.expenseItem == "") {
                      print("使うものが空になっています");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("使うものが空になっています")),
                      );
                      return;
                    }

                    if (est.amount < 0) {
                      /* ここに来ることはない */
                      print("amountの数値がおかしい");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("総額が負になっています。${est.amount}")),
                      );
                      return;
                    }

                    if (est.reimbursedByCnt < 1 || est.reimbursedByCnt > 99) {
                      print("人数の数値がおかしいです");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("人数が正しくありません。${est.reimbursedByCnt}"),
                        ),
                      );
                      return;
                    }
                  }

                  /* ここまできたら問題ないのでFirebaseに配列ごと保存 */
                  if (!checkIsShownTravelInput(shownTravel).isSuccess) {
                    /* ここに来ることはない */
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("旅行が適切に選択されていません。開発者に連絡してください")),
                    );
                    return;
                  }

                  final groupId = shownTravel!.groupId!;
                  final travelId = shownTravel.travelId!;
                  final ret =
                      await FirebaseDatabaseService.setSingleTravelEstimatedExpensesData(
                        groupId,
                        travelId,
                        estimatedListFromManual!,
                      );
                  if (!ret.isSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("エラーが発生しました。${ret.error?.errorMessage}"),
                      ),
                    );
                    return;
                  }

                  final isoStr = DateTime.now().toIso8601String();
                  await FirebaseDatabaseService.setSingleTravelEstimatedUpdateDate(
                    groupId,
                    travelId,
                    isoStr,
                  );
                  print("保存に成功しました");
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("保存に成功しました")));
                },
              ),
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
  final TextEditingController _reimbursedByCntController =
      TextEditingController();

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
                            _estimatedNotifier.value = _estimatedNotifier.value
                                .copyWith(expenseItem: item);
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
                            _estimatedNotifier.value = _estimatedNotifier.value
                                .copyWith(amount: value);
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
                          initialValue:
                              widget.initialEstimated.reimbursedByCnt
                                  .toDouble(),
                          controller: _reimbursedByCntController,
                          onChanged: (value) {
                            int intVal = value.toInt();

                            final updatedEstimated = _estimatedNotifier.value
                                .copyWith(reimbursedByCnt: intVal);
                            _estimatedNotifier.value = updatedEstimated;
                            if (intVal < 1) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("人数は1〜99人までです。")),
                              );
                              widget.onValueChanged(
                                updatedEstimated.copyWith(reimbursedByCnt: 1),
                              );
                            } else if (intVal > 99) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("人数は1〜99人までです。")),
                              );
                              widget.onValueChanged(
                                updatedEstimated.copyWith(reimbursedByCnt: 99),
                              );
                            } else {
                              widget.onValueChanged(updatedEstimated);
                            }
                            print(
                              "_estimatedNotifier.value: ${_estimatedNotifier.value}",
                            );
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
                          : (_estimatedNotifier.value.amount /
                                  _estimatedNotifier.value.reimbursedByCnt)
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
