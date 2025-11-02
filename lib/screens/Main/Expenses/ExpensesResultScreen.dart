import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/CommonClass/BalanceInfo.dart';
import 'package:my_travel_app/CommonClass/ExchangeData.dart';
import 'package:my_travel_app/CommonClass/ShownTravelBasic.dart';
import 'package:my_travel_app/Services/FirebaseDatabaseService.dart';
import 'package:my_travel_app/Store/ExpenseStore.dart';
import 'package:my_travel_app/components/Expenses/BalancesTable.dart';
import 'package:provider/provider.dart';

import '../../../components/BasicText.dart';
import '../../../components/Expenses/ExchangeTileList.dart';
import '../../../components/TopAppBar.dart';

/***
 * 計算自体はクラウドfunctionでやってもらう。
 * 基本的にはそれを上から取ってくるだけ。
 */

class ExpensesResultScreen extends StatefulWidget {
  static const String id = "expenses_result_screen";

  ExpensesResultScreen({super.key});

  @override
  State<ExpensesResultScreen> createState() => _ExpensesResultScreenState();
}

class _ExpensesResultScreenState extends State<ExpensesResultScreen> {
  bool _isLoading = true;
  ExchangeData? _exchangeData;
  DateTime? _parsedLastUpdated;
  Map<String, BalancesInfo>? _balances;

  @override
  void initState() {
    super.initState();

    final expenseStore = context.read<ExpenseStore>();
    /**
     * ExpenseStoreが更新されたときに
     * スナックバーを出せるようにしておく
     */
    expenseStore.addListener(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("費用が更新されました。一度ページを閉じて再度開いてください。"),
          duration: Duration(seconds: 5),
        ),
      );
    });
    Future.microtask(() async {
      try {
        _isLoading = true;
        final ShownTravelBasic? shownTravelBasic =
            expenseStore.shownTravelBasic;
        if (shownTravelBasic == null) {
          print("shown Travelが取れなかった。まあこんなことはほぼないけど。");
          return;
        } else if (shownTravelBasic.groupId == null ||
            shownTravelBasic.travelId == null) {
          print("shownTravelBasicがnullではないけど、idとか入っていない");
          return;
        } else {
          /* Do nothing */
        }

        _exchangeData =
            await FirebaseDatabaseService.getSingleTravelExpensesExchanges(
              shownTravelBasic.groupId!,
              shownTravelBasic.travelId!,
            );
        if (_exchangeData == null) {
          /* まずexpensesがないと、そもそもここに来れないようになっている(webの場合は複数タブを開けばいけるが,,,,) */
          /* まあ表示するだけだからいいか。 */
          print("exchange is null!!!there was probably error");
          return;
        }

        if (_exchangeData!.lastUpdated == null) {
          print("lastUpdated is null!!!");
        } else {
          _parsedLastUpdated = DateTime.parse(_exchangeData!.lastUpdated!);
        }

        /* 精算をDBから取ってくる */
        _balances =
            await FirebaseDatabaseService.getSingleTravelExpensesBalances(
              shownTravelBasic.groupId!,
              shownTravelBasic.travelId!,
            );
        if (_balances == null) {
          print("balances are null!!");
        } else if (_balances == {}) {
          print("balances are empty");
        }
      } catch (e) {
        print("Something went wrong!!$e");
      } finally {
        _isLoading = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /* ここでwatchしておくと、もう一度再描画される？？->されてないな。 */
    final expenseStore = context.watch<ExpenseStore>();
    return Scaffold(
      appBar: TopAppBar(automaticallyImplyLeading: true, title: "割り勘"),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child:
              _exchangeData != null && _balances != null
                  ? Column(
                    children: [
                      BasicText(
                        text:
                            _parsedLastUpdated != null
                                ? "最終更新日時: ${_parsedLastUpdated!.add(const Duration(hours: 9)).toString().split(".").first}\nUTC:${_parsedLastUpdated}" //ミリ秒の部分はいらないからカット。
                                : "最終更新日時: 不明",
                      ),
                      ExchangeTileList(
                        exgData: _exchangeData!.result,
                        participants: expenseStore.allParticipants,
                      ),
                      SizedBox(height: 20),
                      Divider(),
                      SizedBox(height: 20),
                      /* 精算もここに表示する。 */
                      BalancesTable(
                        balances: _balances!,
                        participants: expenseStore.allParticipants,
                      ),
                    ],
                  )
                  : _isLoading //else ifのイメージ
                  ? Text("loading...")
                  : Text(
                    "精算データがありません。\n 費用を追加しているにもかかわらずこの表示が出ているときは、エラーの可能性があります。",
                  ),
        ),
      ),
    );
  }
}
