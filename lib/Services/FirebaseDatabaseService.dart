import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/CommonClass/BalanceInfo.dart';
import 'package:my_travel_app/CommonClass/ExchangeData.dart';
import 'package:my_travel_app/CommonClass/ExpenseInfo.dart';
import 'package:my_travel_app/CommonClass/OnItineraryEdit.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/CommonClass/ShownTravelBasic.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';

import '../CommonClass/ErrorInfo.dart';

class FirebaseDatabaseService {
  static final FirebaseDatabase database = FirebaseDatabase.instance;

  static DatabaseReference get usersRef => database.ref("users");

  static DatabaseReference get groupsRef => database.ref("groups");

  static DatabaseReference get groupKeysRef => database.ref("group_keys");

  static Future<Map<String, dynamic>?> getGroupKeys() async {
    final ref = groupKeysRef;
    final snap = await ref.get();
    if (!snap.exists) {
      print("No groupKeys added....");
      return null;
    }

    final rawMap = snap.value as Map;
    final convertedMap = rawMap.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    return convertedMap;
  }

  static DatabaseReference groupIdInGroupKeysRef(String groupId) {
    return groupKeysRef.child(groupId);
  }

  static DatabaseReference travelIdInGroupKeysRef(
    String groupId,
    String travelId,
  ) {
    return groupIdInGroupKeysRef(groupId).child(travelId);
  }

  static DatabaseReference singleUserRef(String uid) => usersRef.child(uid);

  static String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  static DatabaseReference? get currentUserRef {
    final uid = currentUserId;
    if (uid == null) return null;
    return singleUserRef(uid);
  }

  static DatabaseReference? get currentUserRoleRef {
    return currentUserRef?.child("role");
  }

  static DatabaseReference? get currentUserEmailRef {
    return currentUserRef?.child("email");
  }

  /***********************{uid}/Settings配下************************************/
  static DatabaseReference? get currentUserSettingsRef {
    return currentUserRef?.child("settings");
  }

  static DatabaseReference? get currentUserJoinedGroupRef {
    return currentUserSettingsRef?.child("joined_groups");
  }

  static DatabaseReference? get currentUserShownTravel {
    return currentUserSettingsRef?.child("shown_travel");
  }

  static DatabaseReference? get currentUserProfileRef {
    return currentUserSettingsRef?.child("profile_name");
  }

  static Future<ShownTravelBasic?> getCurrentShownTravel() async {
    final ret = getSingleUserShownTravel(currentUserId!);
    return ret;
  }

  static DatabaseReference singleUserLastLoginRef(String uid) {
    return singleUserSettingsRef(uid).child("last_login_at");
  }

  /***********************************************************/

  //=====================================
  // groups配下系
  //=====================================
  static DatabaseReference singleGroupRef(String groupId) =>
      groupsRef.child(groupId);

  static DatabaseReference groupMembersRef(String groupId) =>
      singleGroupRef(groupId).child("members");

  static Future<Map<String, TravelerBasic>?> getGroupMembers(
    String groupId,
  ) async {
    final ref = groupMembersRef(groupId);
    final snap = await ref.get();
    if (!snap.exists) {
      print("Group member doesn't exist..");
      return null;
    }
    Map<String, TravelerBasic> members = {};
    final map = snap.value as Map<dynamic, dynamic>;
    for (final node in map.entries) {
      members[node.key] = TravelerBasic.convFromMap(node.value);
    }
    return members;
  }

  static DatabaseReference travelsRef(String groupId) =>
      singleGroupRef(groupId).child("travels");

  static DatabaseReference singleTravelRef(String groupId, String travelId) =>
      travelsRef(groupId).child(travelId); //travelsのすぐ下にidがある

  static DatabaseReference singleTravelNameRef(
    String groupId,
    String travelId,
  ) => singleTravelRef(groupId, travelId).child("name");

  static DatabaseReference singleTravelParticipantsRef(
    String groupId,
    String travelId,
  ) => singleTravelRef(groupId, travelId).child("travelers");

  static DatabaseReference singleTravelGManagerRef(
    String groupId,
    String travelId,
  ) => singleTravelRef(groupId, travelId).child("general_manager");

  static DatabaseReference singleTravelExpensesRef(
    String groupId,
    String travelId,
  ) => singleTravelRef(groupId, travelId).child("expenses");

  static DatabaseReference singleTravelExpensesDataRef(
    String groupId,
    String travelId,
  ) => singleTravelExpensesRef(groupId, travelId).child("data");

  /* こっちはあるId配下のものを取ってくる */
  static DatabaseReference singleTravelExpenseIdRef(
    String groupId,
    String travelId,
    String expenseId,
  ) => singleTravelExpensesDataRef(groupId, travelId).child(expenseId);

  static DatabaseReference singleTravelExpensesBalancesRef(
    String groupId,
    String travelId,
  ) => singleTravelExpensesRef(groupId, travelId).child("balances");

  static DatabaseReference singleTravelExpensesExchangesRef(
    String groupId,
    String travelId,
  ) => singleTravelExpensesRef(groupId, travelId).child("exchanges");

  static DatabaseReference singleTravelEstimatedRef(
    String groupId,
    String travbelId,
  ) => singleTravelExpensesRef(groupId, travbelId).child("estimated");

  static DatabaseReference singleTravelItineraryRef(
    String groupId,
    String travelId,
  ) => singleTravelRef(groupId, travelId).child("itinerary");

  static DatabaseReference singleTravelItinerarySectionsRef(
    String groupId,
    String travelId,
  ) => singleTravelItineraryRef(groupId, travelId).child("sections");

  static DatabaseReference singleTravelItineraryOnEditRef(
    String groupId,
    String travelId,
  ) => singleTravelItineraryRef(groupId, travelId).child("on_edit");

  /***
   * 他人のuid配下を使ってデータ操作
   */

  static DatabaseReference singleUserEmailRef(String uid) =>
      singleUserRef(uid).child("email");

  static DatabaseReference singleUserSettingsRef(String uid) =>
      singleUserRef(uid).child("settings");

  static DatabaseReference singleUserJoinedGroupRef(String uid) =>
      singleUserSettingsRef(uid).child("joined_groups");

  static DatabaseReference singleUserProfileNameRef(String uid) =>
      singleUserSettingsRef(uid).child("profile_name");

  static DatabaseReference singleUserShownTravelRef(String uid) =>
      singleUserSettingsRef(uid).child("shown_travel");

  static Future<ResultInfo<String>> getCurrentUserRole() async {
    final userRoleSnap =
        await FirebaseDatabaseService.currentUserRoleRef?.get();
    final snapVal = userRoleSnap?.value;
    if (snapVal == null) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "User role not found"),
      );
    }
    final roleStr = userRoleSnap?.value as String;
    return ResultInfo.success(data: roleStr);
  }

  static Future<ResultInfo<TravelerBasic?>> getSingleTravelGManager(
    String groupId,
    String travelId,
  ) async {
    try {
      final ref = singleTravelGManagerRef(groupId, travelId);
      final snap = await ref.get();
      if (!snap.exists) {
        print("No general manager assigned yet.");
        return ResultInfo.success(data: null);
      }
      final gManagerMap = snap.value as Map<dynamic, dynamic>;
      final travelBasic = TravelerBasic.convFromMap(gManagerMap);
      return ResultInfo.success(data: travelBasic);
    } catch (e) {
      print("Error in getSingleTravelGManager:$e");
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  static Future<ShownTravelBasic?> getSingleUserShownTravel(String uid) async {
    //shown_travelを見つけてくる
    final ref = singleUserShownTravelRef(uid);
    final shownTravelSnap = await ref.get();
    if (!shownTravelSnap.exists) {
      print("shownTravelSnap was null!!");
      return null;
    }

    //shown_travelが取れた。
    if (shownTravelSnap.value is! Map) {
      print("shownTravel is not a Map");
      return null;
    }
    final map = shownTravelSnap.value as Map<dynamic, dynamic>;
    if (map.keys.every((key) => key is String) &&
        map.values.every((value) => value is String)) {
      final shownTravel = Map<String, String>.from(map);
      print("Got shown travel: $shownTravel");

      if (!shownTravel.containsKey("groupId") ||
          !shownTravel.containsKey("travelId")) {
        print("groupId or travelId is missing!");
        return null;
      }

      final String? groupId = shownTravel["groupId"];
      final String? travelId = shownTravel["travelId"];
      if (groupId == null || travelId == null) {
        print("groupId or travelId is null even though it exists!");
      }

      //ここまできたら成功!
      return ShownTravelBasic(travelId: travelId, groupId: groupId);
    } else {
      print("shownTravel is not Map<String, String>");
      return null;
    }
  }

  static Future<ResultInfo> setCurrentUserShownTravel(
    ShownTravelBasic? travelBasic,
  ) async {
    final uid = currentUserId;
    if (uid == null) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "User not logged in"),
      );
    }
    return setSingleUserShownTravel(uid, travelBasic);
  }

  static Future<ResultInfo> setSingleUserShownTravel(
    String uid,
    ShownTravelBasic? travelBasic,
  ) async {
    try {
      final shown_travel_ref = singleUserShownTravelRef(uid);

      if (travelBasic == null) {
        await shown_travel_ref.set(null);
        return ResultInfo.success();
      } else if (travelBasic.groupId == null || travelBasic.travelId == null) {
        print(
          "groupId or travelId should not be empty if travelBasic is not null",
        );
        return ResultInfo.failed(
          error: ErrorInfo(
            errorMessage:
                "groupId or travelId should not be empty if travelBasic is not null",
          ),
        );
      } else {
        /* Do Nothing */
      }
      final groupId = travelBasic.groupId!;
      final travelId = travelBasic.travelId!;
      await shown_travel_ref.set({"groupId": groupId, "travelId": travelId});
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  static Future<ResultInfo> setCurrentUserLastLoginToNow() async {
    final isoStr = DateTime.now().toIso8601String();
    return setCurrentUserLastLogin(isoStr);
  }

  static Future<ResultInfo> setSingleUserLastLoginToNow(String uid) async {
    final isoStr = DateTime.now().toIso8601String();
    return setSingleUserLastLogin(uid, isoStr);
  }

  static Future<ResultInfo> setCurrentUserLastLogin(String isoStr) async {
    final uid = currentUserId;
    if (uid == null) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "User not logged in"),
      );
    }
    return setSingleUserLastLogin(uid, isoStr);
  }

  static Future<ResultInfo> setSingleUserLastLogin(
    String uid,
    String isoStr,
  ) async {
    try {
      final last_login_ref = singleUserLastLoginRef;
      await last_login_ref(uid).set(isoStr);
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  /**
   * あるuidのid、email、userNameを取ってきてTravelerBasicとして返す。
   */
  static Future<TravelerBasic?> getSingleUserTravelerBasic(String uid) async {
    final emailSnap = await singleUserEmailRef(uid).get();
    if (!emailSnap.exists) {
      print("emailSnap is null!!!");
      return null;
    }
    final email = emailSnap.value as String;

    final userNameSnap = await singleUserProfileNameRef(uid).get();
    String? userName;
    if (userNameSnap.exists) {
      userName = userNameSnap.value as String;
    } else {
      /* userNameはnullのまま追加 */
    }

    return TravelerBasic(uid: uid, email: email, profile_name: userName);
  }

  static Future<ExpenseInfo?> getSingleExpenseDataById(
    String groupId,
    String travelId,
    String expenseId,
  ) async {
    final snap =
        await singleTravelExpenseIdRef(groupId, travelId, expenseId).get();
    if (!snap.exists) {
      print("Unable to get Expense:$expenseId");
      return null;
    }

    final map = snap.value as Map<dynamic, dynamic>;
    final expenseInfo = ExpenseInfo.convFromMapToExpenseInfo(map);
    /**
     * 注意!!: profile_nameは入っていないので別で取ってこないとだめ
     * */
    return expenseInfo;
  }

  static Future<ExchangeData?> getSingleTravelExpensesExchanges(
    String groupId,
    String travelId,
  ) async {
    try {
      final snap =
          await singleTravelExpensesExchangesRef(groupId, travelId).get();
      if (!snap.exists) {
        print("Unable to get Exchanges!!!:");
        return null;
      }

      final map = snap.value as Map;
      final exchangeInfo = ExchangeData.convFromMap(map);
      return exchangeInfo;
    } catch (e) {
      print("Error in getSingleTravelExpensesExchanges:$e");
      return null;
    }
  }

  static Future<Map<String, BalancesInfo>?> getSingleTravelExpensesBalances(
    String groupId,
    String travelId,
  ) async {
    try {
      final snap =
          await singleTravelExpensesBalancesRef(groupId, travelId).get();
      if (!snap.exists) {
        print("Unable to get Balances!!");
        return null;
      }
      final map = snap.value as Map;
      final Map<String, BalancesInfo> balancesMap = {};
      map.forEach((key, value) {
        balancesMap[key] = BalancesInfo.convFromMap(value);
      });
      return balancesMap;
    } catch (e) {
      print("Error in getSingleTravelExpensesBalances:$e");
      return null;
    }
  }

  static Future<ResultInfo<Map<String, EstimatedExpenseInfo>?>>
  getSingleTravelEstimatedExpenses(String groupId, String travelId) async {
    try {
      final snap = await singleTravelEstimatedRef(groupId, travelId).get();
      if (!snap.exists) {
        /* データがそもそもない */
        return ResultInfo.success(data: null);
      }
      final map = snap.value as Map;
      final Map<String, EstimatedExpenseInfo> estimatedMap = {};
      map.forEach((key, value) {
        estimatedMap[key] = EstimatedExpenseInfo.convFromMap(value);
      });
      return ResultInfo.success(data: estimatedMap);
    } catch (e) {
      print("Error in getSingleTravelEstimatedExpenses:$e");
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  static Future<ResultInfo<List<Map<String, dynamic>>>>
  getSingleTravelItinerarySections(String groupId, String travelId) async {
    try {
      final snap =
          await singleTravelItinerarySectionsRef(groupId, travelId).get();
      if (!snap.exists) {
        print("Probably there is no itinerary sections...");
        return ResultInfo.success(
          message: "Probably there is no itinerary sections...",
        ); /**/
      }

      final rawList = snap.value as List?;
      if (rawList == null) return ResultInfo.success(data: []);

      // List<Map<String, dynamic>> へ変換（null や Map 以外は除外）
      final List<Map<String, dynamic>> convertedList =
          rawList
              .where((item) => item is Map)
              .map(
                (item) => (item as Map).map(
                  (key, value) => MapEntry(key.toString(), value),
                ),
              )
              .toList();

      return ResultInfo.success(data: convertedList);
    } catch (e) {
      print("Error in getSingleTravelItinerary:$e");
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  /**
   * 結構非効率っぽい処理だけど案外速く終わる
   */
  static Future<ResultInfo<Map<String, TravelerBasic>>> getTravelParticipants(
    String groupId,
    String travelId,
  ) async {
    try {
      final snap = await singleTravelParticipantsRef(groupId, travelId).get();
      if (!snap.exists) {
        print("Participants are empty!!");
        return ResultInfo.success(
          data: {},
          message: "Participants are empty. Ask the admin to add participants.",
        );
      }

      final participantsMap = snap.value as Map<dynamic, dynamic>;
      final travelerUids =
          participantsMap.keys
              .where((e) => e != null)
              .map((e) => e.toString())
              .toList();

      int errorCount = 0;
      Map<String, TravelerBasic> participants = {};
      for (final String userId in travelerUids) {
        final travelerBasic = await getSingleUserTravelerBasic(userId);
        if (travelerBasic != null) {
          participants[userId] = travelerBasic;
        } else {
          print("Failed to get TravelerBasic for uid: $userId");
          errorCount++;
        }
      }

      if (errorCount > 0) {
        return ResultInfo.success(
          data: participants,
          message: "$errorCount participants failed to load",
        );
      }

      return ResultInfo.success(data: participants);
    } catch (e) {
      print("Error in getTravelParticipants:$e");
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  static Future<ResultInfo<List<ExpenseInfo>>> getTravelExpenses(
    String groupId,
    String travelId,
    Map<String, TravelerBasic> participants /* 参加者も渡したい */,
  ) async {
    try {
      final expensesRef = singleTravelExpensesDataRef(groupId, travelId);
      final expensesSnap = await expensesRef.get();
      if (!expensesSnap.exists) {
        print("No expenses found for travelId: $travelId");
        return ResultInfo.success(data: []);
      }

      final expensesMap = expensesSnap.value as Map;
      List<ExpenseInfo> allExpenses = [];

      // for (final t in participants.entries) {
      //   //print("--participant: ${t.key}, ${t.value}--");
      // }
      for (final entry in expensesMap.entries) {
        final val = entry.value;
        final ExpenseInfo bufExpense = ExpenseInfo.convFromMapToExpenseInfo(
          val,
        );
        // participants から payerBasic を取得
        final TravelerBasic? payerBasic = participants[bufExpense.payer.uid];

        if (payerBasic == null) {
          print(
            "payerBasic not found in participants for uid=${bufExpense.payer.uid}",
          );
          return ResultInfo.failed(
            error: ErrorInfo(errorMessage: "Failed to fetch payer information"),
          );
        }

        final addedExpense = bufExpense.copyWith(payer: payerBasic);
        allExpenses.add(addedExpense);
      }

      // Sort expenses
      allExpenses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      print("Fetched and sorted allExpenses!!");
      return ResultInfo.success(data: allExpenses);
    } catch (e) {
      print("Error in getTravelExpenses:$e");
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  static Future<ResultInfo<OnItineraryEdit>> getSingleTravelItineraryOnEdit(
    String groupId,
    String travelId,
  ) async {
    try {
      final snap =
          await singleTravelItineraryOnEditRef(groupId, travelId).get();
      if (!snap.exists) {
        print("Probably there is no itinerary on edit...");
        return ResultInfo.success(data: OnItineraryEdit(on_edit: false));
      }
      final rawMap = snap.value as Map?;
      if (rawMap == null) {
        return ResultInfo.success(data: OnItineraryEdit(on_edit: false));
      }

      // Map形式のデータをOnItineraryEditに変換
      final onEdit = OnItineraryEdit.convFromMap(rawMap);
      return ResultInfo.success(data: onEdit);
    } catch (e) {
      print("Error in getSingleTravelItineraryOnEdit:$e");
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  static Future<ResultInfo> setSingleTravelItineraryOnEdit(
    String groupId,
    String travelId,
    OnItineraryEdit onEdit,
  ) async {
    try {
      final onEditRef = singleTravelItineraryOnEditRef(groupId, travelId);
      // uidをキーとして、そのユーザーの編集状態を更新
      await onEditRef.set(onEdit.toMap());
      return ResultInfo.success();
    } catch (e) {
      print("Error in setSingleTravelItineraryOnEdit:$e");
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  static Future<ResultInfo> setOnDisconnectForItineraryOnEdit(
    String groupId,
    String travelId,
    OnItineraryEdit onEdit,
  ) async {
    try {
      final onEditRef = singleTravelItineraryOnEditRef(groupId, travelId);
      await onEditRef.onDisconnect().set(onEdit.toMap());
      return ResultInfo.success();
    } catch (e) {
      print("Error in setOnDisconnectForItineraryOnEdit:$e");
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  static Future<ResultInfo> cancelOnDisconnectForItineraryOnEdit(
    String groupId,
    String travelId,
  ) async {
    try {
      final onEditRef = singleTravelItineraryOnEditRef(groupId, travelId);
      await onEditRef.onDisconnect().cancel();
      return ResultInfo.success();
    } catch (e) {
      print("Error in cancelOnDisconnectForItineraryOnEdit:$e");
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }
}
