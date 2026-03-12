import 'package:flutter/foundation.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/core/utils/CheckShownTravelBasic.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';

import '../../../data/model/expense/expense_info.dart';
import 'date_state.dart';

/**
 * Travelをswitchしたらインスタンスごと捨てようかと思ったが、
 * ProxyProviderのupdateが思った通り走らないので、中身をまるごとrefreshするスタイルにする
 */
class ExpenseStore extends ChangeNotifier {
  final ShownTravelSession _travelSession;
  final ExpenseRepository _expenseRepository;

  DataState<Map<String, ExpenseInfo>> _allExpenses = const DataState();

  DataState<Map<String, ExpenseInfo>> get allExpenses => _allExpenses;

  bool _storeInitialized = false;

  bool get storeInitialized => _storeInitialized;

  ExpenseStore({
    required ExpenseRepository expenseRepository,
    required ShownTravelSession travelSession,
  }) : _expenseRepository = expenseRepository,
       _travelSession = travelSession {
    print("ExpenseStore was created. hashCode=${hashCode}");

    _travelSession.addListener(_refresh);
  }

  void _refresh() async {
    try {
      if (!_travelSession.initialized) {
        /**
         * travelSessionはログアウトしない限りは作り直されることはないので、
         * 一度trueになればそれ以降ずっとtrue
         */
        print("travelSession not initialized!!");
        return;
      }
      /* travelSessionは初期化されている */
      /* finallyでnotifyListenersをするのでこの関数内では必要ない */
      await refreshExpenses(isLastNotify: false, isLoadingNotify: true);
    } finally {
      if (!_storeInitialized) {
        print("ExpenseStore was initialized.");
        _storeInitialized = true;
      }
      print("expenseStore _refresh has ended.");
      notifyListeners();
    }
  }

  Future<void> refreshExpenses({
    bool isLastNotify = true,
    bool isLoadingNotify = true,
  }) async {
    /// 画面起動後、すぐ呼ばれたらまずいと思って、initializedを設けてたが、UI側でブロックすればいいや。
    // if (!_storeInitialized) {
    //   print("store ot initialized!!");
    //   notifyListeners();
    //   return;
    // }

    if (_travelSession.currentTravel == null) {
      _allExpenses = const DataState(data: {}, isLoading: false, error: null);
      notifyListeners();
      return;
    }
    await _refreshExpenses(
      _travelSession.currentTravel!,
      isLastNotify: isLastNotify,
      isLoadingNotify: isLoadingNotify,
    );
  }

  Future<void> _refreshExpenses(
    ShownTravelBasic travel, {
    bool isLoadingNotify = true,
    bool isLastNotify = true,
  }) async {
    try {
      if (!checkIsShownTravelValid(travel).isSuccess) {
        _allExpenses = DataState(
          isLoading: false,
          error: ErrorInfo(errorMessage: "Invalid shown travel"),
        );
        return;
      }

      _allExpenses = const DataState(isLoading: true, error: null);
      if (isLoadingNotify) {
        notifyListeners();
      }

      final data = await _expenseRepository.getAllExpenses(
        _travelSession.currentTravel!.groupId!,
        _travelSession.currentTravel!.travelId!,
      );
      _allExpenses = DataState(data: data, isLoading: false, error: null);
      return;
    } catch (e) {
      _allExpenses = DataState(
        data: null,
        isLoading: false,
        error: ErrorInfo(errorMessage: e.toString()),
      );
    } finally {
      if (isLastNotify) {
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    print("ExpenseStore was disposed. hashCode=${hashCode}");
    // TODO: implement dispose
    _travelSession.removeListener(_refresh);
    super.dispose();
  }
}
