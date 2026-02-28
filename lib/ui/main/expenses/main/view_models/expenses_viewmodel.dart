import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/core/exceptions/app_exception.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/state/loaidng_controller.dart';

import '../../../../../CommonClass/ResultInfo.dart';
import '../../../../../core/utils/CheckShownTravelBasic.dart';
import '../../../../../data/model/expense/expense_info.dart';

class ExpensesViewModel extends ChangeNotifier with LoadableMixin {
  final ExpenseRepository _expenseRepository;
  final GroupMembersRepository _groupMembersRepository;
  final UserSettingsRepository _userSettingsRepository;
  final ShownTravelSession _travelSession;

  ShownTravelBasic? _currentTravel;

  ShownTravelBasic? get currentTravel => _currentTravel;

  bool _travelSessionInitialized = false;

  bool get travelInitialized => _travelSessionInitialized;

  Map<String, ExpenseInfo>? _allExpenses;

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

  /* nullか空か区別 */

  Map<String, TravelerBasic> get allGroupMembers => _allGroupMembers;

  bool _disposed = false;

  void clearData() {
    _allExpenses = null;
    _allGroupMembers = {};
  }

  /**
   * 旅行がスイッチされるたびにViewModelが再生成される。
   */
  ExpensesViewModel({
    required ExpenseRepository expenseRepository,
    required GroupMembersRepository groupMembersRepository,
    required UserSettingsRepository userSettingsRepository,
    required ShownTravelSession travelSession,
  }) : _expenseRepository = expenseRepository,
       _groupMembersRepository = groupMembersRepository,
       _userSettingsRepository = userSettingsRepository,
       _travelSession = travelSession {
    /**
     * UI側でviewModel.travelSession.currentTravelと書いてしまうと、
     * UIがTravelSessionに直接依存することになる。それはよくない。
     * コピーして、addListenersでsyncする。
     *  */
    _currentTravel = travelSession.currentTravel;
    _travelSessionInitialized = travelSession.initialized;
    print(
      "ExpenseViewModel was created code=${hashCode} groupId=${currentTravel?.groupId} travelId=${currentTravel?.travelId} travelInitialized=${travelSession.initialized}",
    );

    travelSession.addListener(_sync);
  }

  void _sync() {
    /// travelが切り替わるのはそこまで頻繁ではないので、
    /// 現在持っているtravelと同じであっても、更新してしまって良い。
    final newTravel = _travelSession.currentTravel;
    final initialized = _travelSession.initialized;
    _currentTravel = newTravel;
    _travelSessionInitialized = initialized;

    try {
      if (!_travelSessionInitialized) {
        return;
      }

      if (_currentTravel == null) {
        clearData();
        return;
      }
      runWithLoading(() async {
        ///ExpensesとMembersは同じタイミングで走り出して良い。
        ///ただ、Membersが終わった後、すぐ各メンバーのプロフィール名を取りに行く。
        await Future.wait([
          getAllExpensesWithNotify(isStateNotify: false),
          getAllGroupMembersWithNotify(isStateNotify: false),
        ]);
      });
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  /* 最初はロードする必要がある */
  void initialize() async {
    if (_currentTravel == null) {
      return;
    }

    try {
      runWithLoading(() async {
        await Future.wait([
          getAllExpensesWithNotify(isStateNotify: false),
          getAllGroupMembersWithNotify(isStateNotify: false),
        ]);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  /**
   * あまりないが、_onTravelChangedが何回も呼ばれたときに
   * 新しいリクエストを弾いてしまうと、選択した旅行と実際のExpensesが合っていないみたいな状況になりかねない。
   * したがって、requestIdを用いて最後のリクエストを正とする。
   */
  Future<ResultInfo<void>> getAllExpensesWithNotify({
    bool isStateNotify = true,
  }) async {
    try {
      final result = await getAllExpenses();

      if (_disposed) {
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
      } else {
        print("ExpensesViewModel: ${result.error?.errorMessage}");
        return result.toVoid();
      }

      return ResultInfo.success();
    } finally {
      if (!_disposed && isStateNotify) {
        notifyListeners();
      }
    }
  }

  Future<ResultInfo<Map<String, ExpenseInfo>>> getAllExpenses() async {
    return getAllExpensesForTravel(currentTravel);
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
      _allExpenses = data;
      return ResultInfo.success(data: data);
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  Future<ResultInfo<void>> getAllGroupMembersWithNotify({
    bool isStateNotify = true,
    bool isGetProfileName = true,
  }) async {
    try {
      final result = await getAllGroupMembers();
      if (_disposed) {
        return ResultInfo.success();
      }
      if (result.isSuccess) {
        /* エラーハンドルしていないけど、いいか、 */
        Future.wait([
          for (final uid in result.data!.keys)
            if (isGetProfileName) getPutMembersProfileNames(uid),
        ]);

        return ResultInfo.success();
      } else {
        print("ExpensesViewModel: ${result.error?.errorMessage}");
        return result.toVoid();
      }
    } finally {
      if (!_disposed && isStateNotify) {
        notifyListeners();
      }
    }
  }

  Future<ResultInfo<Map<String, TravelerBasic>>> getAllGroupMembers() async {
    return getAllGroupMembersForGroup(currentTravel);
  }

  Future<ResultInfo<Map<String, TravelerBasic>>> getAllGroupMembersForGroup(
    ShownTravelBasic? travel,
  ) async {
    if (travel == null) {
      return ResultInfo.success(data: {});
    }

    if (!checkIsShownTravelValid(travel).isSuccess) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "Invalid shown travel"),
      );
    }
    final groupId = travel.groupId!;

    try {
      final data = await _groupMembersRepository.getAllGroupMembers(groupId);
      _allGroupMembers = data.toTravelerBasicMap();
      return ResultInfo.success(data: data.toTravelerBasicMap());
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  /* 引数にMap<String,TravelerBasic>をもったほうがいい気がするが、、今は必要ないからこれでいいや。 */
  Future<ResultInfo> getPutMembersProfileNames(String uid) async {
    if (_allGroupMembers.isEmpty) {
      return ResultInfo.success();
    }
    try {
      final profileName = await _userSettingsRepository.getProfileName(uid);
      if (_disposed) {
        return ResultInfo.success();
      }
      if (_allGroupMembers[uid] != null) {
        _allGroupMembers[uid] = _allGroupMembers[uid]!.copyWith(
          profile_name: profileName,
        );
      } else {
        throw AppException(
          "uid:${uid} doesn't exist in group members. This is probably coding error.",
        );
      }

      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _travelSession.removeListener(_sync);
    print("ExpenseViewModel was disposed. code=${hashCode}");
    // TODO: implement dispose
    super.dispose();
  }
}
