import 'package:flutter/foundation.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/core/utils/CheckShownTravelBasic.dart';
import 'package:my_travel_app/data/model/expense/expense_info.dart';
import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/travel_scope_store.dart';

/// 1人分の入力。itemが空なら共通の品目を使う。amountは必須
class SplitExpenseInput {
  final TravelerBasic member;
  final String item;
  final String amount;

  const SplitExpenseInput({required this.member, required this.item, required this.amount});
}

/// 1人が全員分をまとめて払ったとき、メンバーごとに金額(と品目)を入力して
/// 「支払者=payer, 負担者=そのメンバーだけ」の通常の費用として1人1件ずつ保存する。
/// データ構造は変えない。
class SplitExpenseViewModel extends ChangeNotifier {
  static const maxItemLength = 100;

  final ExpenseRepository _expenseRepository;
  final TravelScopeStore _travelScopeStore;
  final ShownTravelSession _travelSession;
  final AppSession _appSession;

  /* 支払者の選択肢。Storeの読み込みが終わる前は空なので、毎回Storeから取る */
  List<TravelerBasic> get groupMembers => _travelScopeStore.allGroupMembers.data?.values.toList() ?? [];

  /* 選択できるメンバー。旅行の参加者(いなければグループメンバー全員) */
  List<TravelerBasic> get rowMembers {
    final members = groupMembers;
    final participantUids = _travelScopeStore.participants.data?.keys.toSet() ?? {};
    final participants = members.where((m) => participantUids.contains(m.core.uid)).toList();
    return participants.isNotEmpty ? participants : members;
  }

  /* チェックされたメンバーのuid。最初は自分だけ選ばれている */
  final Set<String> _selectedUids = {};

  bool isSelected(String uid) => _selectedUids.contains(uid);

  /* 入力欄を表示するメンバー(rowMembersの順) */
  List<TravelerBasic> get selectedMembers => rowMembers.where((m) => isSelected(m.core.uid)).toList();

  void toggleMember(String uid) {
    if (!_selectedUids.remove(uid)) {
      _selectedUids.add(uid);
    }
    notifyListeners();
  }

  TravelerBasic? memberByUid(String? uid) {
    for (final member in groupMembers) {
      if (member.core.uid == uid) {
        return member;
      }
    }
    return null;
  }

  String get uid => _appSession.currentUser!.uid;

  bool _isSaving = false;

  bool get isSaving => _isSaving;

  SplitExpenseViewModel({
    required ExpenseRepository expenseRepository,
    required TravelScopeStore travelScopeStore,
    required ShownTravelSession travelSession,
    required AppSession appSession,
  }) : _expenseRepository = expenseRepository,
       _travelScopeStore = travelScopeStore,
       _travelSession = travelSession,
       _appSession = appSession {
    /* 自分の分は大抵あるので最初からチェックしておく(メンバーの読み込み前でもuidだけ入れておけばよい) */
    final myUid = appSession.currentUser?.uid;
    if (myUid != null) {
      _selectedUids.add(myUid);
    }
    /* メンバーや参加者が更新されたら画面も更新する */
    _travelScopeStore.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _travelScopeStore.removeListener(notifyListeners);
    super.dispose();
  }

  /// 入力をチェックして、保存する費用のリストを作る(まだ保存しない)
  ResultInfo<List<ExpenseInfo>> createExpensesFromInput({
    required TravelerBasic? payer,
    required String commonItem,
    required List<SplitExpenseInput> inputs,
  }) {
    if (payer == null) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: "支払った人が選択されていません"));
    }

    /* 共通の品目は、全員が個別の品目を入力していれば空でもよい(下の各行でチェック) */
    final common = commonItem.trim();
    if (common.length > maxItemLength) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: "何に使ったかが$maxItemLength文字を超えています"));
    }

    if (inputs.isEmpty) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: "メンバーが選択されていません"));
    }

    final List<ExpenseInfo> expenses = [];
    for (final input in inputs) {
      final name = input.member.displayName;
      final amountText = input.amount.trim();
      if (amountText.isEmpty) {
        /* 選んだ人は金額が必須 */
        return ResultInfo.failed(error: ErrorInfo(errorMessage: "$nameの金額が入力されていません"));
      }

      final amount = double.tryParse(amountText);
      if (amount == null) {
        return ResultInfo.failed(error: ErrorInfo(errorMessage: "$nameの金額の入力が不適切です"));
      }
      if (amount <= 0) {
        return ResultInfo.failed(error: ErrorInfo(errorMessage: "$nameの金額が0以下になっています"));
      }

      /* 個別の品目が入力されていればそちらを優先 */
      final ownItem = input.item.trim();
      final item = ownItem.isNotEmpty ? ownItem : common;
      if (item.isEmpty) {
        return ResultInfo.failed(error: ErrorInfo(errorMessage: "$nameの品目が入力されていません"));
      }
      if (item.length > maxItemLength) {
        return ResultInfo.failed(error: ErrorInfo(errorMessage: "$nameの品目が$maxItemLength文字を超えています"));
      }

      expenses.add(
        ExpenseInfo(
          id: null,
          payer: payer.core,
          reimbursedBy: {input.member.core.uid: input.member.core},
          expenseItem: item,
          expense: amount,
        ),
      );
    }

    return ResultInfo.success(data: expenses);
  }

  /// 1件ずつ追加する。途中で失敗したら、それまでに保存できた件数をエラーに含める
  Future<ResultInfo> saveExpenses(List<ExpenseInfo> expenses) async {
    final travel = _travelSession.currentTravel;
    if (travel == null || !checkIsShownTravelValid(travel).isSuccess) {
      /* ここに来るのはおかしい */
      return ResultInfo.failed(error: ErrorInfo(errorMessage: "Invalid Travel. Coding error"));
    }
    final groupId = travel.groupId!;
    final travelId = travel.travelId!;

    _isSaving = true;
    notifyListeners();
    var saved = 0;
    try {
      for (final expense in expenses) {
        await _expenseRepository.addExpense(groupId, travelId, expense);
        saved++;
      }
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "${expenses.length}件中$saved件を保存した後に失敗しました: $e"),
      );
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
