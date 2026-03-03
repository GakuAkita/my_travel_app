import 'package:flutter/foundation.dart';
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

  void _refresh() async {
    print("ExpenseStore: travel switched detected.");
    if (!_travelSession.initialized) {
      /**
       * travelSessionはログアウトしない限りは作り直されることはないので、
       * 一度trueになればそれ以降ずっとtrue
       */
      print("travelSession not initialized!!");
      return;
    }

    try {
      /* travelSessionは初期化されている */
      if (_travelSession.currentTravel == null) {
        _allExpenses = const DataState(data: {}, isLoading: false, error: null);
        return;
      }
    } finally {
      if (!_initialized) {
        _initialized = true;
      }
      notifyListeners();
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
