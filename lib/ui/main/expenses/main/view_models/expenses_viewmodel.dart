import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/state/state/expenses_state.dart';
import 'package:my_travel_app/utils/CheckShownTravelBasic.dart';

import '../../../../../CommonClass/ExpenseInfo.dart';

class ExpensesViewModel extends ChangeNotifier {
  final ExpenseRepository _expenseRepository;
  final ShownTravelSession _travelSession;
  final ExpensesState _expensesState;

  ShownTravelBasic? _travel;

  ShownTravelBasic? get travel => _travel;

  List<ExpenseInfo> _allExpenses = [];

  List<ExpenseInfo> get allExpenses => _allExpenses;

  Map<String, TravelerBasic> _allGroupMembers = {};

  /* nullか空か区別 */

  Map<String, TravelerBasic> get allGroupMembers => _allGroupMembers;

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  bool _disposed = false;

  ExpensesViewModel({
    required ExpenseRepository expenseRepository,
    required ShownTravelSession travelSession,
    required ExpensesState expensesState,
  }) : _expenseRepository = expenseRepository,
       _travelSession = travelSession,
       _expensesState = expensesState {
    print("ExpenseViewModel was created");

    /* sessionでnotifyListenersをするたび意_onTravelChangedが走ってしまう */
    _travelSession.addListener(_onTravelChanged);
    /**
     * ExpensesViewModelは画面を開かないとViewModelが作られないから、
     * そのときにはすでにinitializedが終わっているかもしれない。
     * だからinitializedが終わっていたらここでトリガーする必要がある。
     */
  }

  /**
   * あまりないが、_onTravelChangedが何回も呼ばれたときに
   * 新しいリクエストを弾いてしまうと、選択した旅行と実際のExpensesが合っていないみたいな状況になりかねない。
   * したがって、requestIdを用いて最後のリクエストを正とする。
   */
  void _onTravelChanged() async {
    if (_travel == _travelSession.currentTravel) return;

    _travel = _travelSession.currentTravel;

    /*_travelがnullの場合は空を返す*/
    /* ロードする */
    await getAllExpensesWithNotify();
  }

  int _requestId = 0;

  Future<ResultInfo<void>> getAllExpensesWithNotify({
    bool isStateNotify = true,
  }) async {
    final currentId = ++_requestId;

    if (isStateNotify) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final result = await getAllExpenses();

      if (_disposed || currentId != _requestId) {
        /**
         * disposedされたあとにFutureが返ってくるとクラッシュ？
         * getAllExpensesWithNotifyが何度も呼ばれたときにおかしくなる可能性。
         * その対処。一番最近のリクエストじゃない限りはUIを更新しない
         * */
        return ResultInfo.success();
      }

      if (result.isSuccess) {
        /* @TODO createdAtで並び替える */
        _allExpenses = result.data!.values.toList();
      }

      return ResultInfo.success();
    } finally {
      if (isStateNotify) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<ResultInfo<Map<String, ExpenseInfo>>> getAllExpenses() async {
    return getAllExpensesForTravel(_travel);
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
    _disposed = true;
    _travelSession.removeListener(_onTravelChanged);

    print("ExpenseViewModel was disposed");
    // TODO: implement dispose
    super.dispose();
  }
}
