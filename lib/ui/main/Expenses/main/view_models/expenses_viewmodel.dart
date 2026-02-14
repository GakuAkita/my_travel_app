import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/state/shown_travel_session.dart';
import 'package:my_travel_app/utils/CheckShownTravelBasic.dart';

import '../../../../../CommonClass/ExpenseInfo.dart';

class ExpensesViewModel extends ChangeNotifier {
  final ExpenseRepository _expenseRepository;
  final ShownTravelSession _travelSession;

  ShownTravelBasic? _travel;

  ShownTravelBasic? get travel => _travel;

  List<ExpenseInfo> _allExpenses = [];

  List<ExpenseInfo> get allExpenses => _allExpenses;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ExpensesViewModel({
    required ExpenseRepository expenseRepository,
    required ShownTravelSession travelSession,
  }) : _expenseRepository = expenseRepository,
       _travelSession = travelSession {
    print("ExpenseViewModel was created");
    _travelSession.addListener(_onTravelChanged);
  }

  /**
   * あまりないが、_onTravelChangedが何回も呼ばれたときに
   * 新しいリクエストを弾いてしまうと、選択した旅行と実際のExpensesが合っていないみたいな状況になりかねない。
   * したがって、requestIdを用いて最後のリクエストを正とする。
   */
  void _onTravelChanged() async {
    _travel = _travelSession.currentTravel;
    /*_travelがnullの場合は空を返す*/
    /* ロードする */
    getAllExpensesWithNotify();
  }

  int _requestId = 0;

  Future<ResultInfo<void>> getAllExpensesWithNotify() async {
    final currentId = ++_requestId;
    _isLoading = true;
    notifyListeners();

    final result = await getAllExpenses();
    /* 途中で別リクエストが走っていたら無視 */
    if (currentId != _requestId) return ResultInfo.success();

    if (result.isSuccess) {
      /* createdAtを基準に並べる */
      _allExpenses = result.data!.values.toList();
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<ResultInfo<Map<String, ExpenseInfo>>> getAllExpenses() async {
    final result = getAllExpensesForTravel(_travel);
    return result;
  }

  Future<ResultInfo<Map<String, ExpenseInfo>>> getAllExpensesForTravel(
    ShownTravelBasic? argTravel,
  ) async {
    if (argTravel == null) {
      return ResultInfo.success(data: {});
    }

    final isTravelValid = checkIsShownTravelValid(argTravel);
    if (!isTravelValid.isSuccess) {
      /* ここに来るのはそうそうない。 */
      return ResultInfo.failed(error: isTravelValid.error, extraData: {});
    }

    final result = await _expenseRepository.getAllExpenses(
      argTravel.groupId!,
      argTravel.travelId!,
    );

    return result;
  }

  @override
  void dispose() {
    _travelSession.removeListener(_onTravelChanged);

    print("ExpenseViewModel was disposed");
    // TODO: implement dispose
    super.dispose();
  }
}
