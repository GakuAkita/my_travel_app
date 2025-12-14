import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ExpenseInfo.dart';
import 'package:my_travel_app/CommonClass/ShownTravelBasic.dart';

import '../CommonClass/ErrorInfo.dart';
import '../CommonClass/ResultInfo.dart';
import '../CommonClass/TravelerBasic.dart';
import '../Services/FirebaseDatabaseService.dart';
import '../utils/CheckShownTravelBasic.dart';

class ExpenseStore extends ChangeNotifier {
  ShownTravelBasic? _shownTravelBasic;

  ShownTravelBasic? get shownTravelBasic => _shownTravelBasic;
  String? _currentUserId;

  String? get currentUserId => _currentUserId;

  ResultInfo _expenseState = ResultInfo.success();

  ResultInfo get expenseState => _expenseState;

  Map<String, TravelerBasic> _allParticipants = {};

  Map<String, TravelerBasic> get allParticipants => _allParticipants;

  Map<String, TravelerBasic> _allGroupMembers = {};

  Map<String, TravelerBasic> get allGroupMembers => _allGroupMembers;

  List<ExpenseInfo> _allExpenses = [];

  List<ExpenseInfo> get allExpenses => _allExpenses;

  DatabaseReference? _expensesRef;
  StreamSubscription<DatabaseEvent>? _expensesSubscription;

  bool _initialized = false;

  Map<String, List<ExpensePersonalDetail>> get eachPersonalDetails {
    final ret = calcEachPersonalDetails();
    if (ret.isSuccess && ret.data != null) {
      return ret.data!;
    } else {
      print(
        "ExpenseStore: Failed to calculate eachPersonalDetails: ${ret.error?.errorMessage}",
      );
      return {};
    }
  }

  void clearAllData() {
    print("ExpenseStore: clearAllData called.");
    _allParticipants = {};
    _allGroupMembers = {};
    _allExpenses = [];
    _expenseState = ResultInfo.success();
    notifyListeners();
  }

  void updateWithUser(ShownTravelBasic? travelBasic, String? userId) async {
    _shownTravelBasic = travelBasic;
    _currentUserId = userId;
    notifyListeners();
  }

  /**
   * これが非同期asyncになっていると
   */
  void compareAndUpdateWithUser(ShownTravelBasic? travelBasic, String? userId) {
    if (_shownTravelBasic == null ||
        travelBasic == null ||
        _shownTravelBasic!.groupId != travelBasic.groupId ||
        _shownTravelBasic!.travelId != travelBasic.travelId ||
        _currentUserId != userId ||
        _initialized == false) {
      _initialized = true;
      // どれか一つでも違ったら更新する
      print("!!! ExpenseStore: Travel or User changed. Update data. !!!");
      updateWithUser(travelBasic, userId); /* ここでローカルを更新 */

      if (travelBasic == null || userId == null) {
        // 旅行がnullならデータをクリアする
        clearAllData();
      } else {
        // 旅行が変わったのでデータをロードする
        loadAllExpenseDataWithNotify(travelBasic, isStateNotify: true);
        // リスナーを更新する
        _removeListener();
        _addListeners(travelBasic);
      }
    } else {
      print("ExpenseStore: Travel and User are same. Do nothing.");
    }
  }

  /**
   * すべてのデータをロードする。ParticipantもExpenseも。
   */
  Future<ResultInfo> loadAllExpenseDataWithNotify(
    ShownTravelBasic? travelBasic, {
    bool isStateNotify =
        true /* _stateのnotifyをするか。pull to refreshのときとかデフォルトでindicatorがあるからオフしておきたい */,
  }) async {
    print(
      "----------ExpenseStore: loadExpenseDataWithNotify called.---------------",
    );
    _expenseState = ResultInfo.loading();
    /* _expenseStateがどこかで更新されてしまっているな */
    if (isStateNotify) {
      //print("ExpenseStore: Notifying listeners for loading state.");
      notifyListeners();
    } else {
      //print("state is not notified");
    }
    // for (int i = 0; i < 20; i++) {
    //   await Future.delayed(Duration(milliseconds: 1000));
    //   print("Waiting... ${i + 1} seconds");
    //   print("Is this Loading after delay?? ${_expenseState.isLoading}");
    // }

    final ret = await loadAllExpenseData(travelBasic);
    _expenseState = ret;
    notifyListeners();
    return ret;
  }

  Future<ResultInfo> loadAllExpenseData(ShownTravelBasic? travelBasic) async {
    if (travelBasic == null) {
      return ResultInfo.success(message: "Travel is not selected.");
    } else if (travelBasic.groupId == null || travelBasic.travelId == null) {
      return ResultInfo.failed(
        error: ErrorInfo(
          errorMessage:
              "groupId or travelId is null. This is a bug. Let developer know.",
        ),
      );
    }

    final retPart = await _loadAllParticipants(
      travelBasic.groupId!,
      travelBasic.travelId!,
    );
    if (!retPart.isSuccess) {
      print("Failed in loadAllParticipants: ${retPart.error?.errorMessage}");
      return retPart;
    }
    print(
      "ExpenseStore: Participants loaded successfully. Count: ${_allParticipants.length}",
    );

    final retMembers = await _loadAllGroupMember(
      travelBasic.groupId!,
      travelBasic.travelId!,
    );
    if (!retMembers.isSuccess) {
      print("Failed in loadGroupMembers: ${retMembers.error?.errorMessage}");
      return retMembers;
    }
    print(
      "ExpenseStore: GroupMembers loaded successfully. Count:${_allGroupMembers.length}",
    );

    final retEx = await _loadExpenses(
      travelBasic.groupId!,
      travelBasic.travelId!,
      _allGroupMembers,
    );
    if (!retEx.isSuccess) {
      print("Failed in loadExpenses: ${retEx.error?.errorMessage}");
      return retEx;
    }

    return ResultInfo.success(message: "All expense data loaded successfully.");
  }

  /*************************************************
   * 現在ログイン中のユーザーが表示している旅行のグループのメンバー情報
   *********************************************/
  Future<ResultInfo> loadAllParticipants() async {
    final ret = checkIsShownTravelInput(_shownTravelBasic);
    if (!ret.isSuccess) {
      return ret;
    }
    final groupId = _shownTravelBasic!.groupId!;
    final travelId = _shownTravelBasic!.travelId!;
    return _loadAllParticipants(groupId, travelId);
  }

  Future<ResultInfo> _loadAllParticipants(
    String groupId,
    String travelId,
  ) async {
    /**
     * 中で割と無駄なことをやっているので、
     * 将来的にFirestoreに移行するのもあり。この部分だけでも。
     */
    final fetchResult = await FirebaseDatabaseService.getTravelParticipants(
      groupId,
      travelId,
      isGetProfileName: false,
    );

    /**
     * 失敗した場合値は更新しないことにする。
     */
    if (fetchResult.isSuccess && fetchResult.data != null) {
      _allParticipants = fetchResult.data!;
      return ResultInfo.success();
    } else {
      /* 何もしない */
      return fetchResult;
    }
  }

  Future<ResultInfo> _loadAllGroupMember(
    String groupId,
    String travelId,
  ) async {
    final fetchResult = await FirebaseDatabaseService.getGroupMembers(groupId);
    if (fetchResult.isSuccess) {
      _allGroupMembers = fetchResult.data == null ? {} : fetchResult.data!;
    } else {
      print("Failed to load group members: ${fetchResult.error?.errorMessage}");
    }
    return fetchResult;
  }

  /**
   * Expenseのデータだけロードする。
   */
  Future<ResultInfo> _loadExpenseDataWithNotify(
    String groupId,
    String travelId,
    Map<String, TravelerBasic> members,
  ) async {
    print("_____ExpenseStore: _loadExpenseDataWithNotify called._____");
    _expenseState = ResultInfo.loading();
    notifyListeners();
    final ret = await _loadExpenses(groupId, travelId, members);
    _expenseState = ret;
    notifyListeners();
    return ret;
  }

  Future<ResultInfo> _loadExpenses(
    String groupId,
    String travelId,
    Map<String, TravelerBasic> members,
  ) async {
    final fetchResult = await FirebaseDatabaseService.getTravelExpenses(
      groupId,
      travelId,
      members,
    );

    /**
     * 失敗した場合値は更新しないことにする。
     */
    if (fetchResult.isSuccess && fetchResult.data != null) {
      _allExpenses = fetchResult.data!;
      return ResultInfo.success();
    } else {
      /* 何もしない */
      return fetchResult;
    }
  }

  /********* リスナー管理 ************/
  void _removeListener() {
    if (_expensesSubscription != null) {
      _expensesSubscription!.cancel();
      _expensesSubscription = null;
    }
    _isFirstAddListener = true; /* trueに戻しておく */
    _expensesRef = null;
  }

  bool _isFirstAddListener = true;

  ResultInfo _addListeners(ShownTravelBasic? travelBasic) {
    if (travelBasic == null) {
      return ResultInfo.failed(
        error: ErrorInfo(
          errorMessage: "_addListeners called with null ShownTravel.",
        ),
      );
    } else if (travelBasic.groupId == null || travelBasic.travelId == null) {
      return ResultInfo.failed(
        error: ErrorInfo(
          errorMessage: "_addListeners called with null groupId or travelId.",
        ),
      );
    }

    final String groupId = travelBasic.groupId!;
    final String travelId = travelBasic.travelId!;

    /* リスナーを追加していく */
    _expensesRef = FirebaseDatabaseService.singleTravelExpensesDataRef(
      groupId,
      travelId,
    );

    _expensesSubscription = _expensesRef!.onValue.listen((event) {
      /** これがaddされた時点で必ず一回走ってしまう。
       * そうすると_expenseStateがloadingから変わってしまう？
       *  */
      /* フラグで制御する */
      if (_isFirstAddListener) {
        _isFirstAddListener = false;
        print(
          "ExpenseStore: First onValue event received, skipping initial load.",
        );
        return;
      }
      print("ExpenseStore: Expense data changed in Firebase.");
      _loadExpenseDataWithNotify(groupId, travelId, _allParticipants);
    });
    return ResultInfo.success();
  }

  void dispose() {
    print("ExpenseStore: dispose called.");
    _removeListener();
    super.dispose();
  }

  ResultInfo checkStoredDataEmpty() {
    if (_currentUserId == null) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "User is not logged in."),
      );
    }
    if (_shownTravelBasic == null) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "No travel is selected."),
      );
    }
    if (_allParticipants.isEmpty) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "No participants data."),
      );
    }
    if (_allExpenses.isEmpty) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "No expenses data."),
      );
    }

    return ResultInfo.success();
  }

  /**
   * 大和田さんがほしいと行っていた
   * 各個人の明細を計算する。
   * 基本的にはただExpenseDataを個々人単位に読み替えれば良いだけ。
   * だから難しくはない。
   */
  ResultInfo<Map<String, List<ExpensePersonalDetail>>>
  calcEachPersonalDetails() {
    final checkRet = checkStoredDataEmpty();
    if (checkRet.isFailed) {
      return ResultInfo.failed(error: checkRet.error);
    } else {
      /** 問題ないのでスルー */
    }

    Map<String, List<ExpensePersonalDetail>> result = {};
    // 参加者全員分の空のリストを作成
    for (var participant in _allParticipants.values) {
      result[participant.uid] = [];
    }

    for (final expense in _allExpenses) {
      // このexpenseに関わる人全員に対して処理を行う
      // reimbursedBy
      final reimbursedNum = expense.reimbursedBy.keys.length;
      final double amount = expense.expense / reimbursedNum;

      expense.reimbursedBy.forEach((uid, _) {
        if (result.containsKey(uid)) {
          result[uid]!.add(
            ExpensePersonalDetail(
              expenseId: expense.id,
              expenseItem: expense.expenseItem,
              amountPerPerson: amount,
            ),
          );
        } else {
          // 参加者リストに存在しないユーザーIDがある場合の処理
          print(
            "Warning: User ID $uid in expense ${expense.id} not found in participants.",
          );
        }
      });
    }

    return ResultInfo.success(data: result);
  }

  ResultInfo<Map<String, List<ExpensePaidDetail>>> createExpensePaidLists() {
    final checkRet = checkStoredDataEmpty();
    if (checkRet.isFailed) {
      return ResultInfo.failed(error: checkRet.error);
    } else {
      /** 問題ないのでスルー */
    }

    Map<String, List<ExpensePaidDetail>> result = {};
    // 参加者全員分の空のリストを作成
    for (var participant in _allParticipants.values) {
      result[participant.uid] = [];
    }

    for (final expense in _allExpenses) {
      final payerId = expense.payer.uid;
      if (result.containsKey(payerId)) {
        result[payerId]!.add(
          ExpensePaidDetail(
            expenseId: expense.id,
            expenseItem: expense.expenseItem,
            paidAmount: expense.expense.toDouble(),
          ),
        );
      } else {
        /* ここに入ることはない */
        print("${payerId} is not included. This is a bug");
      }
    }

    return ResultInfo.success(data: result);
  }
}
