import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';

import '../../../../../CommonClass/ExpenseInfo.dart';
import '../../../../../CommonClass/ResultInfo.dart';
import '../../../../../core/utils/CheckShownTravelBasic.dart';

class ExpensesViewModel extends ChangeNotifier {
  final ExpenseRepository _expenseRepository;

  ShownTravelBasic? _travel;

  ShownTravelBasic? get travel => _travel;

  Map<String, ExpenseInfo>? _allExpenses;

  List<ExpenseInfo> allExpensesList({bool sort = true}) {
    if (_allExpenses == null) {
      return [];
    }

    /* createdAtで並べる。引数で */
    final listedExpenses = _allExpenses!.values.toList();
    if (sort) {
      listedExpenses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return listedExpenses;
  }

  Map<String, TravelerBasic> _allGroupMembers = {};

  /* nullか空か区別 */

  Map<String, TravelerBasic> get allGroupMembers => _allGroupMembers;

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  bool _disposed = false;

  /**
   * 旅行がスイッチされるたびにViewModelが再生成される。
   */
  ExpensesViewModel({
    required ExpenseRepository expenseRepository,
    required ShownTravelBasic? travel,
  }) : _expenseRepository = expenseRepository,
       _travel = travel {
    print("ExpenseViewModel was created code=${hashCode}");

    /**
     * Expensesをロードする
     */
  }

  /**
   * あまりないが、_onTravelChangedが何回も呼ばれたときに
   * 新しいリクエストを弾いてしまうと、選択した旅行と実際のExpensesが合っていないみたいな状況になりかねない。
   * したがって、requestIdを用いて最後のリクエストを正とする。
   */

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
        _allExpenses = result.data!;
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

    try {
      final data = await _expenseRepository.getAllExpenses(
        argTravel.groupId!,
        argTravel.travelId!,
      );
      return ResultInfo.success(data: data);
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  @override
  void dispose() {
    _disposed = true;
    print("ExpenseViewModel was disposed. code=${hashCode}");
    // TODO: implement dispose
    super.dispose();
  }
}
