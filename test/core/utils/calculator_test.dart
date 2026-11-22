import 'package:flutter_test/flutter_test.dart';
import 'package:my_travel_app/core/utils/calculator.dart';

void main() {
  group('evaluateExpression', () {
    test('四則演算と優先順位', () {
      expect(evaluateExpression('1200'), 1200);
      expect(evaluateExpression('1200+800'), 2000);
      expect(evaluateExpression('1000-250'), 750);
      expect(evaluateExpression('1200+800×2'), 2800);
      expect(evaluateExpression('10000÷4'), 2500);
      expect(evaluateExpression('10-2-3'), 5);
      expect(evaluateExpression('100/4/5'), 5);
    });

    test('ASCII演算子・全角マイナス・カンマ・空白も受け付ける', () {
      expect(evaluateExpression('3*400 + 1,000'), 2200);
      expect(evaluateExpression('500−200'), 300);
    });

    test('括弧・小数・単項マイナス', () {
      expect(evaluateExpression('(1200+800)×3'), 6000);
      expect(evaluateExpression('((2))'), 2);
      expect(evaluateExpression('1.5×2'), 3);
      expect(evaluateExpression('-500+2000'), 1500);
      expect(evaluateExpression('1000×-1'), -1000);
    });

    test('不正な式・0除算は null', () {
      expect(evaluateExpression(''), isNull);
      expect(evaluateExpression('1+'), isNull);
      expect(evaluateExpression('(1+2'), isNull);
      expect(evaluateExpression('1+2)'), isNull);
      expect(evaluateExpression('1.2.3'), isNull);
      expect(evaluateExpression('10÷0'), isNull);
      expect(evaluateExpression('abc'), isNull);
      expect(evaluateExpression('2 3'), isNull);
    });
  });

  test('previewExpressionは入力途中の式を補って評価する', () {
    expect(previewExpression('1200+'), 1200);
    expect(previewExpression('1200+800×'), 2000);
    expect(previewExpression('(1200+800'), 2000);
    expect(previewExpression('100×('), 100);
    expect(previewExpression('100+(−'), 100);
    expect(previewExpression(''), isNull);
    expect(previewExpression('10÷0'), isNull);
  });

  test('formatCalculatorResultは小数第2位で丸め、整数は.0を付けない', () {
    expect(formatCalculatorResult(2000), '2000');
    expect(formatCalculatorResult(10000 / 3), '3333.33');
    expect(formatCalculatorResult(2.5), '2.5');
    expect(formatCalculatorResult(1.999), '2');
  });
}
