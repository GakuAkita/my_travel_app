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

  bool _initialized = false;

  bool get initialized => _initialized;

  ExpenseStore({
    required ExpenseRepository expenseRepository,
    required ShownTravelSession travelSession,
  }) : _expenseRepository = expenseRepository,
       _travelSession = travelSession {
    print("ExpenseStore was created. hashCode=${hashCode}");

    _travelSession.addListener(_refresh);
  }

  int _refreshId = 0;

  void _refresh() async {
    final id = ++_refreshId;
    print("ExpenseStore: travel switched detected. id=${_refreshId}");
    try {
      print(
        "travel value=${_travelSession.currentTravel.toString()} init=${_travelSession.initialized}",
      );
      final init = _travelSession.initialized;
      if (!init) {
        /**
         * travelSessionはログアウトしない限りは作り直されることはないので、
         * 一度trueになればそれ以降ずっとtrue
         */
        print("travelSession not initialized!! id=${_refreshId}");
        return;
      }
      /* travelSessionは初期化されている */
      await refreshExpenses(isLastNotify: false, isLoadingNotify: true);
    } finally {
      if (!_initialized) {
        _initialized = true;
      }
      print("expenseStore _refresh has ended.");
      notifyListeners();
    }
  }

  Future<void> refreshExpenses({
    bool isLastNotify = true,
    bool isLoadingNotify = true,
  }) async {
    if (!_initialized) {
      print("Not initalized!!");
      notifyListeners();
      return;
    }

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
