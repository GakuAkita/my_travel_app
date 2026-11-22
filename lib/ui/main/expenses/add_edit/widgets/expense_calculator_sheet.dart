import 'package:flutter/material.dart';
import 'package:my_travel_app/core/utils/calculator.dart';
import 'package:my_travel_app/core/utils/currency_format.dart';

/// 金額入力用の電卓をボトムシートで開く。
/// 「確定」で金額欄に入れる文字列(例: "1250", "3333.33")を返す。閉じた場合は null。
/// [title] を渡すと上部に表示する(まとめて追加で誰の金額か分かるように)。
Future<String?> showExpenseCalculator(BuildContext context, {String initialExpression = "", String? title}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => ExpenseCalculatorSheet(initialExpression: initialExpression, title: title),
  );
}

class ExpenseCalculatorSheet extends StatefulWidget {
  final String initialExpression;
  final String? title;

  const ExpenseCalculatorSheet({super.key, this.initialExpression = "", this.title});

  @override
  State<ExpenseCalculatorSheet> createState() => _ExpenseCalculatorSheetState();
}

class _ExpenseCalculatorSheetState extends State<ExpenseCalculatorSheet> {
  static const _operators = ['+', '−', '×', '÷'];

  late String _expression = widget.initialExpression;

  String get _last => _expression.isEmpty ? '' : _expression[_expression.length - 1];

  /// 今入力している数値(最後の演算子・括弧より後ろ)
  String get _currentNumber => RegExp(r'[0-9.]*$').stringMatch(_expression) ?? '';

  void _input(String key) {
    setState(() {
      switch (key) {
        case 'C':
          _expression = '';
        case '⌫':
          if (_expression.isNotEmpty) _expression = _expression.substring(0, _expression.length - 1);
        case '.':
          if (_currentNumber.contains('.')) return;
          if (_last == ')') _expression += '×';
          _expression += _currentNumber.isEmpty ? '0.' : '.';
        case '(':
          /* "2(" や "2)(" は掛け算として扱う */
          if (RegExp(r'[0-9.)]$').hasMatch(_expression)) _expression += '×';
          _expression += '(';
        case ')':
          final open = '('.allMatches(_expression).length - ')'.allMatches(_expression).length;
          if (open <= 0 || _operators.contains(_last) || _last == '(' || _expression.isEmpty) return;
          _expression += ')';
        case '+' || '−' || '×' || '÷':
          if (_expression.isEmpty || _last == '(') {
            /* 先頭や括弧の直後はマイナスだけ許可 */
            if (key == '−') _expression += key;
            return;
          }
          if (_operators.contains(_last)) {
            /* 演算子の連続は置き換え */
            _expression = _expression.substring(0, _expression.length - 1) + key;
          } else {
            _expression += key;
          }
        default: // 数字 / 00
          if (_last == ')') _expression += '×';
          if (key == '00' && (_currentNumber.isEmpty || _currentNumber == '0')) {
            if (_currentNumber.isEmpty) _expression += '0';
            return;
          }
          /* 先頭の0は置き換える("0" -> "5") */
          if (_currentNumber == '0') {
            _expression = _expression.substring(0, _expression.length - 1);
          }
          _expression += key;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final result = previewExpression(_expression);
    final canConfirm = result != null && result > 0;

    String resultLabel;
    if (_expression.isEmpty) {
      resultLabel = " ";
    } else if (result == null) {
      resultLabel = "計算できません";
    } else {
      resultLabel = "= ${formatYenExact(result)}";
    }

    const keys = [
      ['C', '(', ')', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '−'],
      ['1', '2', '3', '+'],
      ['0', '00', '.', '⌫'],
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  widget.title!,
                  key: const Key('calculator_title'),
                  style: textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _expression.isEmpty ? "0" : _expression,
                      key: const Key('calculator_expression'),
                      style: textTheme.headlineMedium?.copyWith(
                        color: _expression.isEmpty ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    resultLabel,
                    key: const Key('calculator_result'),
                    style: textTheme.titleMedium?.copyWith(
                      color: result == null ? colorScheme.error : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            for (final row in keys)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    for (final key in row)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _CalculatorKey(label: key, onPressed: () => _input(key)),
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              icon: const Icon(Icons.check),
              label: Text(canConfirm ? "${formatYenExact(result)} を入力" : "確定"),
              onPressed: canConfirm ? () => Navigator.of(context).pop(formatCalculatorResult(result)) : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _CalculatorKey extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _CalculatorKey({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isOperator = const ['+', '−', '×', '÷', '(', ')'].contains(label);
    final isAction = label == 'C' || label == '⌫';

    final Color background;
    final Color foreground;
    if (isOperator) {
      background = colorScheme.secondaryContainer;
      foreground = colorScheme.onSecondaryContainer;
    } else if (isAction) {
      background = colorScheme.tertiaryContainer;
      foreground = colorScheme.onTertiaryContainer;
    } else {
      background = colorScheme.surfaceContainer;
      foreground = colorScheme.onSurface;
    }

    return SizedBox(
      height: 56,
      child: TextButton(
        key: Key('calculator_key_$label'),
        style: TextButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: label == '⌫'
            ? const Icon(Icons.backspace_outlined, semanticLabel: "1文字削除")
            : Text(label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
