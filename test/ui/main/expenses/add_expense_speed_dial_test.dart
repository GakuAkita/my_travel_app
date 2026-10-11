import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_travel_app/ui/main/expenses/main/widgets/add_expense_speed_dial.dart';

void main() {
  late List<String> pressed;

  Future<void> pumpSpeedDial(WidgetTester tester) {
    pressed = [];
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          floatingActionButton: AddExpenseSpeedDial(
            onAddPressed: () => pressed.add("add"),
            onSplitAddPressed: () => pressed.add("split"),
          ),
        ),
      ),
    );
  }

  testWidgets('最初は+だけが表示されている', (tester) async {
    await pumpSpeedDial(tester);

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text("費用を追加"), findsNothing);
    expect(find.text("まとめて追加"), findsNothing);
  });

  testWidgets('+を押すと選択肢が展開され、×で閉じる', (tester) async {
    await pumpSpeedDial(tester);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text("費用を追加"), findsOneWidget);
    expect(find.text("まとめて追加"), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    expect(find.text("費用を追加"), findsNothing);
    expect(find.text("まとめて追加"), findsNothing);
    expect(pressed, isEmpty);
  });

  testWidgets('まとめて追加を選ぶと呼ばれて閉じる', (tester) async {
    await pumpSpeedDial(tester);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.playlist_add));
    await tester.pump();

    expect(pressed, ["split"]);
    expect(find.text("まとめて追加"), findsNothing);
  });

  testWidgets('費用を追加はラベルを押しても選べる', (tester) async {
    await pumpSpeedDial(tester);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.tap(find.text("費用を追加"));
    await tester.pump();

    expect(pressed, ["add"]);
    expect(find.text("費用を追加"), findsNothing);
  });
}
