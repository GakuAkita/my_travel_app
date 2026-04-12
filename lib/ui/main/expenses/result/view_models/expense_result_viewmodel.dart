import 'package:flutter/widgets.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/model/balance/balance_info.dart';
import 'package:my_travel_app/data/model/expense/expense_info.dart';
import 'package:my_travel_app/data/model/money_exchange/money_exchange.dart';
import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';
import 'package:my_travel_app/data/repositories/balance_info/balance_info_repository.dart';
import 'package:my_travel_app/data/repositories/money_exchange/money_exchange_repository.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/expense_store.dart';
import 'package:my_travel_app/ui/core/store/travel_scope_store.dart';
import 'package:my_travel_app/ui/main/expenses/expense_detail.dart';

class ExpenseResultViewModel extends ChangeNotifier {
  final ShownTravelSession _session;
  final ExpenseStore _expenseStore;
  final TravelScopeStore _travelScopeStore;
  final MoneyExchangeRepository _moneyExchangeRepository;
  final BalanceInfoRepository _balanceInfoRepository;

  late final String _groupId;
  late final String _travelId;

  bool _isExpensesUpdated = false;

  bool get isExpensesUpdated => _isExpensesUpdated;

  List<MoneyExchange> _exchangeList = [];

  List<MoneyExchange> get exchangeList => _exchangeList;

  String? _lastUpdated;

  String? get lastUpdated => _lastUpdated;

  Map<String, List<ExpenseDetail>> _allDetails = {};

  Map<String, List<ExpenseDetail>> get allDetails => _allDetails;

  Map<String, BalanceInfo> _balanceInfo = {};

  Map<String, BalanceInfo> get balanceInfo => _balanceInfo;

  ExpenseResultViewModel({
    required ExpenseStore expenseStore,
    required TravelScopeStore travelScopeStore,
    required ShownTravelSession session,
    required MoneyExchangeRepository moneyExchangeRepository,
    required BalanceInfoRepository balanceInfoRepository,
  }) : _expenseStore = expenseStore,
       _travelScopeStore = travelScopeStore,
       _moneyExchangeRepository = moneyExchangeRepository,
       _session = session,
       _balanceInfoRepository = balanceInfoRepository {
    print("ExpenseResultViewModel Created. $hashCode");

    _expenseStore.addListener(_onExpensesUpdated);

    _groupId = _session.currentTravel!.groupId!;
    _travelId = _session.currentTravel!.travelId!;
  }

  void _onExpensesUpdated() {
    print("ExpenseResultViewModel _onExpensesUpdated called");
    _isExpensesUpdated = true;
    notifyListeners();
  }

  List<ExpenseInfo> allExpensesList() {
    if (_expenseStore.allExpenses.hasData) {
      return _expenseStore.allExpenses.data!.entries
          .map((entry) => entry.value)
          .toList();
    } else {
      return [];
    }
  }

  Map<String, TravelerBasic> groupMembers() {
    if (_travelScopeStore.allGroupMembers.hasData) {
      return _travelScopeStore.allGroupMembers.data!;
    } else {
      return {};
    }
  }

  Future<ResultInfo<void>> fetchMoneyExchanges() async {
    try {
      final exchangesData = await _moneyExchangeRepository.getMoneyExchangeData(
        groupId: _groupId,
        travelId: _travelId,
      );
      _exchangeList = exchangesData;
      print("$_exchangeList");
      calcExpenseDetails(); /* 取得できたら計算する */
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    } finally {
      notifyListeners();
    }
  }

  Future<ResultInfo<void>> fetchMoneyExchangesLastUpdated() async {
    try {
      final lastUpdatedStr = await _moneyExchangeRepository
          .getMoneyExchangeLastUpdated(groupId: _groupId, travelId: _travelId);
      if (lastUpdatedStr != null) {
        /* 日本時間に変換する */
        final utcDate = DateTime.parse(lastUpdatedStr!);
        final localDate = utcDate.toLocal();
        _lastUpdated = localDate.toString();
        print("$_lastUpdated in local");
      }

      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    } finally {
      notifyListeners();
    }
  }

  Future<ResultInfo<void>> fetchBalanceInfo() async {
    try {
      final balance = await _balanceInfoRepository.getBalanceInfo(
        groupId: _groupId,
        travelId: _travelId,
      );
      _balanceInfo = balance;
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    } finally {
      notifyListeners();
    }
  }

  void calcExpenseDetails() {
    if (_expenseStore.allExpenses.hasData) {
      final expenses = _expenseStore.allExpenses.data!;
      _allDetails = expenses.toAllDetails();
      notifyListeners();
    } else {
      print("ExpenseStore has no data. This might be a coding error.");
    }
  }

  /// Expenseの中には自分が関与していないものもある。
  /// 自分が支払いではないやつもあるので、そうでないやつだけまとめる
  List<ExpenseDetail> buildPaidDetails(String uid) {
    final details = _allDetails[uid];
    if (details == null || details.isEmpty) {
      return [];
    }

    final List<ExpenseDetail> paidList = [];
    for (var detail in details) {
      if (detail.paidAmount != 0) {
        paidList.add(detail);
      }
    }
    return paidList;
  }

  List<ExpenseDetail> buildReimbursedDetails(String uid) {
    final details = _allDetails[uid];
    if (details == null || details.isEmpty) {
      return [];
    }

    final List<ExpenseDetail> reimbursedList = [];
    for (var detail in details) {
      if (detail.owedAmount != 0) {
        reimbursedList.add(detail);
      }
    }
    return reimbursedList;
  }

  @override
  void dispose() {
    print("dispose ExpenseResultViewModel $hashCode");
    // TODO: implement dispose
    _expenseStore.removeListener(_onExpensesUpdated);
    super.dispose();
  }
}

//ResultInfo<Map<String,List<>>>
