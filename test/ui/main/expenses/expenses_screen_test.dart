import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/model/expense/expense_info.dart';
import 'package:my_travel_app/data/services/fake/fake_backend.dart';
import 'package:my_travel_app/ui/main/expenses/main/widgets/expenses_screen.dart';
import 'package:provider/provider.dart';

import '../../../helpers/fake_app.dart';

void main() {
  Future<FakeBackend> pumpExpenses(WidgetTester tester, {String? email}) {
    return pumpFakeApp(
      tester,
      email: email ?? FakeBackend.demoUser.email,
      screen: (context) => ExpensesScreen(viewModel: context.read()),
    );
  }

  testWidgets('シードされた支出が一覧に表示される', (tester) async {
    await pumpExpenses(tester);

    expect(find.text("ホテル"), findsOneWidget);
    expect(find.text("¥30,000"), findsOneWidget);
    expect(find.text("夕食"), findsOneWidget);
    expect(find.text("¥9,000"), findsOneWidget);
    expect(find.text("タクシー"), findsOneWidget);
    expect(find.text("¥2,400"), findsOneWidget);
  });

  testWidgets('追加ボタン(+アイコン)と割り勘確認・費用概算ボタンが表示される', (tester) async {
    await pumpExpenses(tester);

    expect(find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);
    expect(find.text("割り勘確認"), findsOneWidget);
    expect(find.text("費用概算"), findsOneWidget);
  });

  testWidgets('+を押すと費用を追加・まとめて追加が展開される', (tester) async {
    await pumpExpenses(tester);

    await tester.tap(find.widgetWithIcon(FloatingActionButton, Icons.add));
    await tester.pump();

    expect(find.text("費用を追加"), findsOneWidget);
    expect(find.text("まとめて追加"), findsOneWidget);
  });

  testWidgets('DBに支出が追加されると一覧に反映される', (tester) async {
    final backend = await pumpExpenses(tester, email: FakeBackend.alice.email);
    expect(find.text("お土産"), findsNothing);

    final db = backend.database;
    final travel = FirebaseDatabasePaths.group(FakeBackend.demoGroupId).travels.travel(FakeBackend.demoTravelId);
    final key = db.pushKey();
    const alice = FakeBackend.alice;
    db.set(
      travel.expenses.singleData(key),
      ExpenseInfo(
        id: key,
        payer: alice,
        reimbursedBy: {alice.uid: alice},
        expenseItem: "お土産",
        expense: 1500,
        createdAt: DateTime.now().millisecondsSinceEpoch + 100,
      ).toJson(),
    );
    await settle(tester);

    expect(find.text("お土産"), findsOneWidget);
    expect(find.text("¥1,500"), findsOneWidget);
  });
}
