import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';
import 'package:my_travel_app/ui/core/store/expense_store.dart';

import '../../../../../data/model/expense/expense_info.dart';
import '../../../../../state/session/shown_travel_session.dart';

class ExpensesViewModel extends ChangeNotifier {
  final ExpenseStore _expenseStore;
  final ShownTravelSession _travelSession;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Map<String, ExpenseInfo>? _allExpenses;

  bool get storeInitialized => _expenseStore.storeInitialized;

  List<ExpenseInfo> allExpensesList({bool sort = true}) {
    if (_allExpenses == null) {
      return [];
    }

    /* createdAtで並べる。引数で */
    final listedExpenses = _allExpenses!.values.toList();
    if (sort) {
      listedExpenses.sort((a, b) {
        final aTime = a.createdAt;
        final bTime = b.createdAt;

        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1; // aを後ろへ
        if (bTime == null) return -1; // bを後ろへ

        return bTime.compareTo(aTime);
      });
    }
    return listedExpenses;
  }

  Map<String, TravelerBasic> _allGroupMembers = {};

  Map<String, TravelerBasic> get allGroupMembers => _allGroupMembers;

  ShownTravelBasic? get currentTravel => _travelSession.currentTravel;

  /**
   * 旅行がスイッチされるたびにViewModelが再生成される。
   */
  ExpensesViewModel({
    required ExpenseStore expenseStore,
    required ShownTravelSession travelSession,
  }) : _expenseStore = expenseStore,
       _travelSession = travelSession {
    /**
     * UI側でviewModel.travelSession.currentTravelと書いてしまうと、
     * UIがTravelSessionに直接依存することになる。それはよくない。
     * コピーして、addListenersでsyncする。
     *  */
    print("ExpenseViewModel was created code=${hashCode}");

    _expenseStore.addListener(_sync);
  }

  void _sync() {
    try {
      final expensesDataState = _expenseStore.allExpenses;
      if (expensesDataState.isLoading) {
        /* ずっとローディング状態になるのはちょっと怖いな。どこかでタイムアウトできないかな */
        _isLoading = true;
      } else if (expensesDataState.hasError) {
        _isLoading = false;
        /* エラー内容をUI側に伝えたい。 */
        print("expenseStore error=${expensesDataState.error?.errorMessage}");
      } else if (expensesDataState.hasData) {
        print("There are expenses");
        _isLoading = false;
        _allExpenses = _expenseStore.allExpenses.data;
      } else {
        /* エラーでもないけどdataがnull?? */
        _isLoading = false;
        print("this might be the coding error???");
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> refreshExpenses({bool isLoadingNotify = true}) async {
    await _expenseStore.refreshExpenses(
      isLoadingNotify: isLoadingNotify,
      isLastNotify: true,
    );
  }

  // Future<ResultInfo<void>> getAllGroupMembersWithNotify({
  //   bool isStateNotify = true,
  //   bool isGetProfileName = true,
  // }) async {
  //   print("getAllGroupMembersWithNotify called");
  //   try {
  //     final result = await getAllGroupMembers();
  //     if (_disposed) {
  //       return ResultInfo.success();
  //     }
  //     if (result.isSuccess) {
  //       /* エラーハンドルしていないけど、いいか、 */
  //       if (isGetProfileName) {
  //         Future.wait([
  //           for (final uid in result.data!.keys) getPutMembersProfileNames(uid),
  //         ]);
  //       }
  //
  //       return ResultInfo.success();
  //     } else {
  //       print("ExpensesViewModel: ${result.error?.errorMessage}");
  //       return result.toVoid();
  //     }
  //   } finally {
  //     if (!_disposed && isStateNotify) {
  //       notifyListeners();
  //     }
  //   }
  // }
  //
  // Future<ResultInfo<Map<String, TravelerBasic>>> getAllGroupMembersForGroup(
  //   ShownTravelBasic? travel,
  // ) async {
  //   if (travel == null) {
  //     return ResultInfo.success(data: {});
  //   }
  //
  //   if (!checkIsShownTravelValid(travel).isSuccess) {
  //     return ResultInfo.failed(
  //       error: ErrorInfo(errorMessage: "Invalid shown travel"),
  //     );
  //   }
  //   final groupId = travel.groupId!;
  //
  //   try {
  //     final data = await _groupMembersRepository.getAllGroupMembers(groupId);
  //     _allGroupMembers = data.toTravelerBasicMap();
  //     return ResultInfo.success(data: data.toTravelerBasicMap());
  //   } catch (e) {
  //     return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
  //   }
  // }
  //
  // /* 引数にMap<String,TravelerBasic>をもったほうがいい気がするが、、今は必要ないからこれでいいや。 */
  // Future<ResultInfo> getPutMembersProfileNames(String uid) async {
  //   if (_allGroupMembers.isEmpty) {
  //     return ResultInfo.success();
  //   }
  //   try {
  //     final profileName = await _userSettingsRepository.getProfileName(uid);
  //     if (_disposed) {
  //       return ResultInfo.success();
  //     }
  //     if (_allGroupMembers[uid] != null) {
  //       _allGroupMembers[uid] = _allGroupMembers[uid]!.copyWith(
  //         profile_name: profileName,
  //       );
  //     } else {
  //       throw AppException(
  //         "uid:${uid} doesn't exist in group members. This is probably coding error.",
  //       );
  //     }
  //
  //     return ResultInfo.success();
  //   } catch (e) {
  //     return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
  //   }
  // }

  @override
  void dispose() {
    _expenseStore.removeListener(_sync);
    print("ExpenseViewModel was disposed. code=${hashCode}");
    // TODO: implement dispose
    super.dispose();
  }
}
