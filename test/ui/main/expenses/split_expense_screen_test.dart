import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/model/expense/expense_info.dart';
import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';
import 'package:my_travel_app/data/services/fake/fake_backend.dart';
import 'package:my_travel_app/ui/main/expenses/split/view_models/split_expense_viewmodel.dart';
import 'package:my_travel_app/ui/main/expenses/split/widgets/split_expense_screen.dart';
import 'package:provider/provider.dart';

import '../../../helpers/fake_app.dart';

void main() {
  late SplitExpenseViewModel viewModel;

  Future<FakeBackend> pumpSplit(WidgetTester tester, {bool pushed = false}) {
    return pumpFakeApp(
      tester,
      email: FakeBackend.demoUser.email,
      pushed: pushed,
      /* ルーターと同じく、ViewModelのライフサイクルはProviderに持たせる */
      screen: (context) => ChangeNotifierProvider(
        create: (c) => SplitExpenseViewModel(
          expenseRepository: c.read(),
          travelScopeStore: c.read(),
          travelSession: c.read(),
          appSession: c.read(),
        ),
        builder: (c, _) {
          viewModel = c.read();
          return SplitExpenseScreen(viewModel: viewModel);
        },
      ),
    );
  }

  TravelerBasic member(String uid) => viewModel.rowMembers.firstWhere((m) => m.core.uid == uid);

  List<ExpenseInfo> savedExpenses(FakeBackend backend) {
    final path = FirebaseDatabasePaths.group(
      FakeBackend.demoGroupId,
    ).travels.travel(FakeBackend.demoTravelId).expenses.data;
    return backend.database.getChildren(path).values.map(ExpenseInfo.fromJson).toList();
  }

  Finder field(String key) => find.descendant(of: find.byKey(ValueKey(key)), matching: find.byType(TextField));

  Future<void> select(WidgetTester tester, String uid) async {
    await tester.tap(find.byKey(ValueKey("select-$uid")));
    await tester.pump();
  }

  group('メンバー選択', () {
    testWidgets('最初は自分(サインインしているユーザー)だけ選ばれている', (tester) async {
      await pumpSplit(tester);

      expect(viewModel.selectedMembers.map((m) => m.core.uid), [FakeBackend.demoUser.uid]);
    });

    testWidgets('toggleMemberで選択/解除でき、並び順は参加者の順になる', (tester) async {
      await pumpSplit(tester);
      viewModel.toggleMember(FakeBackend.demoUser.uid); /* 自分を外して空にする */
      expect(viewModel.selectedMembers, isEmpty);
      final order = viewModel.rowMembers.map((m) => m.core.uid).toList();

      viewModel.toggleMember(order[2]);
      viewModel.toggleMember(order[0]);
      expect(viewModel.selectedMembers.map((m) => m.core.uid), [order[0], order[2]]);

      viewModel.toggleMember(order[2]);
      expect(viewModel.selectedMembers.map((m) => m.core.uid), [order[0]]);
    });
  });

  group('createExpensesFromInput', () {
    testWidgets('個別の品目が空なら共通の品目、入力されていれば個別の品目を使う', (tester) async {
      await pumpSplit(tester);

      final result = viewModel.createExpensesFromInput(
        payer: member(FakeBackend.demoUser.uid),
        commonItem: "ランチ",
        inputs: [
          SplitExpenseInput(member: member(FakeBackend.demoUser.uid), item: "", amount: "1000"),
          SplitExpenseInput(member: member(FakeBackend.alice.uid), item: "パスタ", amount: "1200"),
          SplitExpenseInput(member: member(FakeBackend.bob.uid), item: "  ", amount: "900"),
        ],
      );

      expect(result.isSuccess, isTrue);
      final expenses = result.data!;
      expect(expenses.map((e) => e.expenseItem), ["ランチ", "パスタ", "ランチ"]);
      expect(expenses.map((e) => e.expense), [1000, 1200, 900]);
    });

    testWidgets('全員が個別の品目を入力していれば共通の品目は空でもよい', (tester) async {
      await pumpSplit(tester);

      final result = viewModel.createExpensesFromInput(
        payer: member(FakeBackend.demoUser.uid),
        commonItem: "",
        inputs: [
          SplitExpenseInput(member: member(FakeBackend.alice.uid), item: "パスタ", amount: "1200"),
          SplitExpenseInput(member: member(FakeBackend.bob.uid), item: "ピザ", amount: "900"),
        ],
      );

      expect(result.isSuccess, isTrue);
      expect(result.data!.map((e) => e.expenseItem), ["パスタ", "ピザ"]);
    });

    testWidgets('共通の品目が空で、個別の品目も空の人がいるとエラー', (tester) async {
      await pumpSplit(tester);

      final result = viewModel.createExpensesFromInput(
        payer: member(FakeBackend.demoUser.uid),
        commonItem: "",
        inputs: [
          SplitExpenseInput(member: member(FakeBackend.alice.uid), item: "パスタ", amount: "1200"),
          SplitExpenseInput(member: member(FakeBackend.bob.uid), item: "", amount: "900"),
        ],
      );

      expect(result.error?.errorMessage, "Bobの品目が入力されていません");
    });

    testWidgets('支払者は全件同じで、負担者はその行の人だけ', (tester) async {
      await pumpSplit(tester);

      final result = viewModel.createExpensesFromInput(
        payer: member(FakeBackend.demoUser.uid),
        commonItem: "ランチ",
        inputs: [
          SplitExpenseInput(member: member(FakeBackend.alice.uid), item: "", amount: "1200"),
          SplitExpenseInput(member: member(FakeBackend.bob.uid), item: "", amount: "900"),
        ],
      );

      final expenses = result.data!;
      for (final e in expenses) {
        expect(e.payer.uid, FakeBackend.demoUser.uid);
        expect(e.id, isNull);
      }
      expect(expenses[0].reimbursedBy.keys, [FakeBackend.alice.uid]);
      expect(expenses[1].reimbursedBy.keys, [FakeBackend.bob.uid]);
    });

    testWidgets('入力が不正ならエラーになる', (tester) async {
      await pumpSplit(tester);
      final payer = member(FakeBackend.demoUser.uid);
      final bob = member(FakeBackend.bob.uid);

      String? error({
        TravelerBasic? payer,
        String commonItem = "ランチ",
        String amount = "900",
        String item = "",
        bool noInputs = false,
      }) {
        return viewModel
            .createExpensesFromInput(
              payer: payer,
              commonItem: commonItem,
              inputs: noInputs ? [] : [SplitExpenseInput(member: bob, item: item, amount: amount)],
            )
            .error
            ?.errorMessage;
      }

      expect(error(payer: null), "支払った人が選択されていません");
      /* 共通も個別も品目が空 */
      expect(error(payer: payer, commonItem: " "), "Bobの品目が入力されていません");
      expect(error(payer: payer, commonItem: "あ" * 101), contains("100文字"));
      expect(error(payer: payer, noInputs: true), "メンバーが選択されていません");
      expect(error(payer: payer, amount: ""), "Bobの金額が入力されていません");
      expect(error(payer: payer, amount: "0"), "Bobの金額が0以下になっています");
      expect(error(payer: payer, amount: "abc"), "Bobの金額の入力が不適切です");
      expect(error(payer: payer, item: "あ" * 101), contains("Bobの品目"));
    });
  });

  group('SplitExpenseScreen', () {
    testWidgets('最初は自分の入力欄だけがあり、チェックした人の入力欄が追加される', (tester) async {
      await pumpSplit(tester);
      final alice = FakeBackend.alice.uid;

      expect(find.byKey(ValueKey("amount-${FakeBackend.demoUser.uid}")), findsOneWidget);
      expect(find.byKey(ValueKey("amount-$alice")), findsNothing);

      await select(tester, alice);
      expect(find.byKey(ValueKey("amount-$alice")), findsOneWidget);
      expect(find.byKey(ValueKey("amount-${FakeBackend.bob.uid}")), findsNothing);

      await select(tester, alice);
      expect(find.byKey(ValueKey("amount-$alice")), findsNothing);

      /* 自分も外すと案内が出る */
      await select(tester, FakeBackend.demoUser.uid);
      expect(find.text("メンバーを選ぶと入力欄が追加されます"), findsOneWidget);
    });

    testWidgets('解除してもう一度チェックすると入力した値が残っている', (tester) async {
      await pumpSplit(tester);
      final alice = FakeBackend.alice.uid;

      await select(tester, alice);
      await tester.enterText(field("amount-$alice"), "1200");
      await select(tester, alice);
      await select(tester, alice);

      expect(tester.widget<TextField>(field("amount-$alice")).controller?.text, "1200");
    });

    testWidgets('共通の品目が各行のヒントになる', (tester) async {
      await pumpSplit(tester);
      await select(tester, FakeBackend.alice.uid);

      await tester.enterText(find.widgetWithText(TextField, "何に使ったか(共通)"), "ランチ");
      await tester.pump();

      final aliceItem = tester.widget<TextField>(field("item-${FakeBackend.alice.uid}"));
      expect(aliceItem.decoration?.hintText, "ランチ");
    });

    testWidgets('合計はチェックしている人の金額だけ', (tester) async {
      await pumpSplit(tester);
      final alice = FakeBackend.alice.uid;
      final bob = FakeBackend.bob.uid;

      await select(tester, alice);
      await select(tester, bob);
      await tester.enterText(field("amount-$alice"), "1200");
      await tester.enterText(field("amount-$bob"), "900");
      await tester.pump();
      expect(find.text("合計 ¥2,100"), findsOneWidget);

      await select(tester, bob);
      expect(find.text("合計 ¥1,200"), findsOneWidget);
    });

    testWidgets('まとめて保存するとチェックした人だけ1人1件の費用として保存され、前の画面に戻る', (tester) async {
      final backend = await pumpSplit(tester, pushed: true);
      final before = savedExpenses(backend).length;
      final alice = FakeBackend.alice.uid;
      final bob = FakeBackend.bob.uid;

      await tester.enterText(find.widgetWithText(TextField, "何に使ったか(共通)"), "ランチ");
      await select(tester, alice);
      await select(tester, bob);
      await tester.enterText(field("item-$alice"), "パスタ");
      await tester.enterText(field("amount-$alice"), "1200");
      await tester.enterText(field("amount-$bob"), "900");
      await tester.enterText(field("amount-${FakeBackend.demoUser.uid}"), "1000");
      /* Demoは解除するので保存されない */
      await select(tester, FakeBackend.demoUser.uid);

      await tester.tap(find.text("まとめて保存"));
      await settle(tester);

      final expenses = savedExpenses(backend);
      expect(expenses.length, before + 2);
      final pasta = expenses.singleWhere((e) => e.expenseItem == "パスタ");
      expect(pasta.expense, 1200);
      expect(pasta.payer.uid, FakeBackend.demoUser.uid);
      expect(pasta.reimbursedBy.keys, [alice]);
      final lunch = expenses.singleWhere((e) => e.expenseItem == "ランチ");
      expect(lunch.expense, 900);
      expect(lunch.payer.uid, FakeBackend.demoUser.uid);
      expect(lunch.reimbursedBy.keys, [bob]);

      expect(find.text(fakeAppHomeText), findsOneWidget);
      expect(find.text("2件の費用を保存しました"), findsOneWidget);
    });

    testWidgets('入力が不正なときは保存せずにエラーを表示する', (tester) async {
      final backend = await pumpSplit(tester, pushed: true);
      final before = savedExpenses(backend).length;

      /* 最初から選ばれている自分の金額が空のまま */
      await tester.enterText(find.widgetWithText(TextField, "何に使ったか(共通)"), "ランチ");
      await tester.tap(find.text("まとめて保存"));
      await tester.pump();

      expect(find.text("Demoの金額が入力されていません"), findsOneWidget);
      expect(savedExpenses(backend).length, before);
      expect(find.text(fakeAppHomeText), findsNothing);
    });
  });
}
