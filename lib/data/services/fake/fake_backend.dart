import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/model/estimated_expense/estimated_expense_info.dart';
import 'package:my_travel_app/data/model/expense/expense_info.dart';
import 'package:my_travel_app/data/model/itinerary_section/itinerary_section.dart';
import 'package:my_travel_app/data/model/itinerary_table/itinerary_table.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';
import 'package:my_travel_app/data/services/fake/fake_auth.dart';
import 'package:my_travel_app/data/services/fake/fake_cloud_functions.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

/// Fakeモードのバックエンド一式(Firebase Auth + Realtime Database の代わり)
/// アプリ起動中はずっと生きているので、サインアウトしてもデータは残る。
class FakeBackend {
  /* デモ用アカウント。パスワードは全員 "password" */
  static const demoPassword = "password";
  static const demoUser = TravelerCore(uid: "demo-user", email: "demo@example.com");
  static const alice = TravelerCore(uid: "alice", email: "alice@example.com");
  static const bob = TravelerCore(uid: "bob", email: "bob@example.com");
  static const demoGroupId = "demo-group";
  static const demoTravelId = "demo-travel";

  final FakeDatabase database;
  final FakeAuth auth;

  FakeBackend({FakeDatabase? database, FakeAuth? auth})
    : database = database ?? FakeDatabase(),
      auth = auth ?? FakeAuth();

  /// デモデータ入り。signedIn=trueならdemo@example.comでサインインした状態で始まる
  factory FakeBackend.seeded({bool signedIn = true}) {
    final backend = FakeBackend();
    backend._seed();
    if (signedIn) {
      backend.auth.signInWithEmail(demoUser.email, demoPassword);
    }
    return backend;
  }

  void _seed() {
    final db = database;
    final members = {for (final t in [demoUser, alice, bob]) t.uid: t};
    final profileNames = {demoUser.uid: "Demo", alice.uid: "Alice", bob.uid: "Bob"};

    /* ユーザー */
    for (final traveler in members.values) {
      auth.createAccount(email: traveler.email, password: demoPassword, uid: traveler.uid);
      FakeCloudFunctions.onUserCreate(db, traveler.uid, traveler.email);
      final settings = FirebaseDatabasePaths.user(traveler.uid).settings;
      db.set(settings.profile_name, profileNames[traveler.uid]);
      db.set(settings.joined_group(demoGroupId), true);
      db.set(
        settings.shown_travel,
        const ShownTravelBasic(groupId: demoGroupId, travelId: demoTravelId).toJson(),
      );
    }

    /* グループ */
    final group = FirebaseDatabasePaths.group(demoGroupId);
    db.set(group.creator, demoUser.toJson());
    db.set(group.members, members.map((k, v) => MapEntry(k, v.toJson())));
    db.set(FirebaseDatabasePaths.groupKey(demoGroupId).travel(demoTravelId), true);

    /* 旅行 */
    final travel = group.travels.travel(demoTravelId);
    db.set(travel.name, "Demo Trip");
    db.set(travel.travelers, members.map((k, v) => MapEntry(k, v.toJson())));
    db.set(travel.planners, {demoUser.uid: demoUser.toJson()});

    /* 支出 */
    final now = DateTime.now().millisecondsSinceEpoch;
    final expenses = [
      ExpenseInfo(id: null, payer: demoUser, reimbursedBy: members, expenseItem: "ホテル", expense: 30000),
      ExpenseInfo(id: null, payer: alice, reimbursedBy: members, expenseItem: "夕食", expense: 9000),
      ExpenseInfo(
        id: null,
        payer: bob,
        reimbursedBy: {alice.uid: alice, bob.uid: bob},
        expenseItem: "タクシー",
        expense: 2400,
      ),
    ];
    for (var i = 0; i < expenses.length; i++) {
      final key = db.pushKey();
      db.set(travel.expenses.singleData(key), expenses[i].copyWith(id: key, createdAt: now + i).toJson());
    }
    FakeCloudFunctions.onExpenseDataChange(db, demoGroupId, demoTravelId);

    db.set(travel.expenses.estimatedData, [
      const EstimatedExpenseInfo(id: "estimated-1", expenseItem: "レンタカー", amount: 12000, reimbursedByCnt: 3),
      const EstimatedExpenseInfo(id: "estimated-2", expenseItem: "入場料", amount: 1500, reimbursedByCnt: 1),
    ].map((e) => e.toJson()).toList());

    /* 旅程 */
    db.set(travel.itinerary.sections, [
      const ItinerarySection.markdown(
        id: "section-1",
        title: "1日目",
        content: "## 集合\n- 9:00 東京駅\n- 新幹線で移動",
      ),
      const ItinerarySection.table(
        id: "section-2",
        tableData: ItineraryTable(
          tableCells: [
            ["10:00", "京都駅", "到着"],
            ["12:00", "錦市場", "昼食"],
          ],
        ),
      ),
      const ItinerarySection.space(id: "section-3"),
    ].map((e) => e.toJson()).toList());
  }
}
