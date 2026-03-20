import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/core/utils/CheckShownTravelBasic.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';

import '../../../data/model/expense/expense_info.dart';
import 'data_state.dart';

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

  bool _subscriptionFirst = false;

  bool get subscriptionFirst => _subscriptionFirst;

  StreamSubscription<Map<String, ExpenseInfo>>? _subscription;

  ExpenseStore({
    required ExpenseRepository expenseRepository,
    required ShownTravelSession travelSession,
  }) : _expenseRepository = expenseRepository,
       _travelSession = travelSession {
    print("ExpenseStore was created. hashCode=${hashCode}");

    _travelSession.addListener(_refresh);
  }

  void _refresh() {
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
      print("refreshExpenses called in _refresh ExpenseStore");
      refreshExpenses(isLoadingNotify: true);
    } finally {
      if (!_storeInitialized) {
        print("ExpenseStore was initialized.");
        _storeInitialized = true;
      }
      print("expenseStore _refresh has ended.");
      //notifyListeners();
    }
  }

  void refreshExpenses({
    bool isLastNotify = true,
    bool isLoadingNotify = true,
  }) {
    /// 画面起動後、すぐ呼ばれたらまずいと思って、initializedを設けてたが、UI側でブロックすればいいや。
    // if (!_storeInitialized) {
    /* 初回のときにここでブロックしてしまう。 */
    //   print("ExpenseStore not initialized!!");
    //   notifyListeners();
    //   return;
    // }

    if (_travelSession.currentTravel == null) {
      _allExpenses = const DataState(data: {}, isLoading: false, error: null);
      notifyListeners();
      return;
    }

    _refreshExpenses(
      _travelSession.currentTravel!,
      isLoadingNotify: isLoadingNotify,
    );
  }

  /* subscriptionを貼り直すだけ。 */
  void _refreshExpenses(
    ShownTravelBasic travel, {
    bool isLoadingNotify = true,
  }) {
    if (!checkIsShownTravelValid(travel).isSuccess) {
      _allExpenses = DataState(
        isLoading: false,
        error: ErrorInfo(errorMessage: "Invalid shown travel"),
      );
      return;
    }

    if (!_subscriptionFirst && _storeInitialized) {
      /// 前回リスナーを貼り直してからまだ届いていないので、待機する
      print(
        "Store is already initialized and First subscription doesn't arrive yet.",
      );
      return;
    }

    // 前のsubscriptionを破棄
    _subscription?.cancel();
    _subscriptionFirst = false;

    _allExpenses = const DataState(isLoading: true, error: null);
    if (isLoadingNotify) {
      notifyListeners();
    }

    print("Add subscription to ExpenseRepository");
    _subscription = _expenseRepository
        .watchExpenses(travel.groupId!, travel.travelId!)
        .listen(
          (data) {
            _allExpenses = DataState(data: data, isLoading: false);
            _subscriptionFirst = true;
            notifyListeners();
          },
          onError: (e) {
            print("Error in ExpenseRepository: ${e.toString()}");
            _allExpenses = DataState(
              isLoading: false,
              error: ErrorInfo(errorMessage: e.toString()),
            );
            _subscriptionFirst = true;
            notifyListeners();
          },
        );
  }

  @override
  void dispose() {
    print("ExpenseStore was disposed. hashCode=${hashCode}");
    // TODO: implement dispose
    _travelSession.removeListener(_refresh);
    super.dispose();
  }
}
