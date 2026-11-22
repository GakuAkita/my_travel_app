import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_travel_app/ui/main/expenses/add_edit/widgets/expense_calculator_sheet.dart';

void main() {
  Future<Future<String?> Function()> pumpSheet(WidgetTester tester, {String initial = ''}) async {
    String? returned;
    var closed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                returned = await showExpenseCalculator(context, initialExpression: initial);
                closed = true;
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    return () async {
      expect(closed, isTrue);
      return returned;
    };
  }

  Future<void> tapKeys(WidgetTester tester, List<String> keys) async {
    for (final k in keys) {
      await tester.tap(find.byKey(Key('calculator_key_$k')));
      await tester.pump();
    }
  }

  String expressionText(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(const Key('calculator_expression'))).data!;

  testWidgets('式を入力すると結果がプレビューされ、確定で値を返す', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.reset);

    final result = await pumpSheet(tester);
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tapKeys(tester, ['1', '2', '0', '0', '+', '8', '0', '0', '×', '2']);
    expect(expressionText(tester), '1200+800×2');
    expect(find.text('= ¥2,800'), findsOneWidget);

    await tester.tap(find.text('¥2,800 を入力'));
    await tester.pumpAndSettle();
    expect(await result(), '2800');
  });

  testWidgets('演算子の連続は置き換え、⌫とCで消せる', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.reset);

    await pumpSheet(tester, initial: '500');
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(expressionText(tester), '500');
    await tapKeys(tester, ['+', '×']);
    expect(expressionText(tester), '500×');
    await tapKeys(tester, ['⌫']);
    expect(expressionText(tester), '500');
    await tapKeys(tester, ['÷', '0']);
    expect(find.text('計算できません'), findsOneWidget);
    await tapKeys(tester, ['C']);
    expect(expressionText(tester), '0');
  });

  testWidgets('割り切れない値は小数第2位まで返す', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.reset);

    final result = await pumpSheet(tester);
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tapKeys(tester, ['1', '00', '00', '÷', '3']);
    expect(expressionText(tester), '10000÷3');
    await tester.tap(find.text('¥3,333.33 を入力'));
    await tester.pumpAndSettle();
    expect(await result(), '3333.33');
  });
}
