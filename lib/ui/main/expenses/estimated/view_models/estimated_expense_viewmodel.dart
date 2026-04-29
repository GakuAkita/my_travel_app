import 'package:flutter/material.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/model/estimated_expense/estimated_expense_info.dart';
import 'package:my_travel_app/data/model/itinerary_section/itinerary_section.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/itinerary_store.dart';
import 'package:my_travel_app/ui/core/store/travel_scope_store.dart';

class EstimatedExpenseViewModel extends ChangeNotifier {
  final ShownTravelSession _travelSession;
  final ItineraryStore _itineraryStore;
  final TravelScopeStore _travelScopeStore;

  double _estimatedExpense = 0.0;

  double get estimatedExpense => _estimatedExpense;

  double _estimatedExpenseFromManual = 0.0;

  double get estimatedExpenseFromManual => _estimatedExpenseFromManual;

  double _estimatedExpenseFromItinerary = 0.0;

  double get estimatedExpenseFromItinerary => _estimatedExpenseFromItinerary;

  List<EstimatedExpenseInfo> _estimatedExpenseListFromItinerary = [];

  List<EstimatedExpenseInfo> get estimatedExpenseListFromItinerary => _estimatedExpenseListFromItinerary;

  List<EstimatedExpenseInfo> _estimatedExpenseListFromManual = [];

  EstimatedExpenseViewModel({
    required ShownTravelSession travelSession,
    required ItineraryStore itineraryStore,
    required TravelScopeStore travelScopeStore,
  }) : _itineraryStore = itineraryStore,
       _travelSession = travelSession,
       _travelScopeStore = travelScopeStore {}

  ResultInfo createEstimatedExpensesFromItinerary({isNotify = false}) {
    if (!_itineraryStore.itinerarySections.hasError &&
        !_travelScopeStore.participants.hasError &&
        _itineraryStore.itinerarySections.hasData &&
        _travelScopeStore.participants.hasData) {
      /* エラーが全くなくて、かつデータが取得できたとき */
      final sections = _itineraryStore.itinerarySections.data!;
      final participants = _travelScopeStore.participants.data!;
      final people = participants.length;
      if (people == 0) {
        print("This is inappropriate. no participants");
        /* エラーとして返したい。まあ参加者0は状況としてないと思うが */
        return ResultInfo.failed(error: ErrorInfo(errorMessage: "This is inappropriate. no participants"));
      } else {
        _estimatedExpenseListFromItinerary = [];
        /* Tableの一番右の列で"****円/○人を正規表現で取得する。 */
        final expenseReg = RegExp(r'(\d+)円/(\d+)?人');
        final etcReg = RegExp(r'ETC([^\d]?)(\d+)円', caseSensitive: false);
        sections.forEach((sec) {
          if (sec is TableSection) {
            final tableData = sec.tableData;
            for (final row in tableData.tableCells) {
              final expenseMatches = expenseReg.allMatches(row[2]);
              for (final match in expenseMatches) {
                print("${match.group(0)} | ${match.group(1)} | ${match.group(2)}");

                final amount = double.parse(match.group(1)!);
                final peopleCnt = int.parse(match.group(2) ?? "1");
                String firstLine = row[1].toString().split('\n').first; /* 同じ行の1列目(0スタート)を項目名とする */

                // Markdownのリンク表示 `[text](url)` から text のみを抽出
                // 例: "[Google](https://google.com)" -> "Google"
                String expenseItemStr = firstLine.replaceAllMapped(
                  RegExp(r'\[(.*?)\]\(.*?\)'),
                  (match) => match.group(1)!,
                );

                // Markdownの見出し `# heading` から `#` を削除
                // 例: "## 新宿" -> "新宿"
                expenseItemStr = expenseItemStr.replaceAll(RegExp(r'^[#]+\s*'), '').trim();

                /* expenseStoreと中身検知して逆算するのはありかもな。 */
                final estimated = EstimatedExpenseInfo(
                  id: "",
                  expenseItem: expenseItemStr,
                  amount: amount,
                  reimbursedByCnt: peopleCnt,
                );
                _estimatedExpenseListFromItinerary.add(estimated);
              }
            }
          }
        });
      }

      for (final est in _estimatedExpenseListFromItinerary) {
        _estimatedExpenseFromItinerary += (est.amount / est.reimbursedByCnt);
      }
      if (isNotify) {
        notifyListeners();
      }
      return ResultInfo.success();
    } else {
      if (isNotify) {
        notifyListeners();
      }
      return ResultInfo.failed(error: ErrorInfo(errorMessage: "Something went wrong with the store"));
    }
  }

  /* Repository */

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
