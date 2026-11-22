/// 費用入力用の簡易電卓。
///
/// 四則演算(+ - × ÷ / * も可)、括弧、小数、単項マイナスに対応。
/// 演算子の優先順位は通常通り(× ÷ が + - より先)。
library;

/// 式を評価する。式が不完全・不正、または0除算のときは null を返す。
double? evaluateExpression(String expression) {
  final tokens = _tokenize(expression);
  if (tokens == null || tokens.isEmpty) return null;
  final parser = _Parser(tokens);
  final value = parser.parseExpression();
  if (value == null || !parser.isAtEnd || !value.isFinite) return null;
  return value;
}

/// 入力途中の式をプレビュー用に評価する。
/// 末尾の演算子や閉じていない括弧を補って評価する(例: "100+" -> 100, "(2+3" -> 5)。
double? previewExpression(String expression) {
  var expr = expression.trimRight();
  while (expr.isNotEmpty && _isOperator(expr[expr.length - 1])) {
    expr = expr.substring(0, expr.length - 1).trimRight();
  }
  while (expr.endsWith('(')) {
    expr = expr.substring(0, expr.length - 1).trimRight();
    while (expr.isNotEmpty && _isOperator(expr[expr.length - 1])) {
      expr = expr.substring(0, expr.length - 1).trimRight();
    }
  }
  final open = '('.allMatches(expr).length - ')'.allMatches(expr).length;
  if (open > 0) expr += ')' * open;
  return evaluateExpression(expr);
}

/// 金額欄に入れる文字列にする(小数第2位で丸め、整数なら ".0" を付けない)。
String formatCalculatorResult(double value) {
  final rounded = (value * 100).round() / 100;
  if (rounded == rounded.roundToDouble()) return rounded.toInt().toString();
  return rounded.toStringAsFixed(2).replaceFirst(RegExp(r'0$'), '');
}

bool _isOperator(String c) => '+-×÷*/−'.contains(c);

sealed class _Token {}

class _Num extends _Token {
  final double value;
  _Num(this.value);
}

class _Op extends _Token {
  final String op; // + - * / ( )
  _Op(this.op);
}

List<_Token>? _tokenize(String input) {
  final tokens = <_Token>[];
  var i = 0;
  while (i < input.length) {
    final c = input[i];
    if (c == ' ') {
      i++;
      continue;
    }
    if (RegExp(r'[0-9.]').hasMatch(c)) {
      final start = i;
      while (i < input.length && RegExp(r'[0-9.,]').hasMatch(input[i])) {
        i++;
      }
      final value = double.tryParse(input.substring(start, i).replaceAll(',', ''));
      if (value == null) return null; // "1.2.3" など
      tokens.add(_Num(value));
      continue;
    }
    switch (c) {
      case '+':
        tokens.add(_Op('+'));
      case '-' || '−':
        tokens.add(_Op('-'));
      case '*' || '×':
        tokens.add(_Op('*'));
      case '/' || '÷':
        tokens.add(_Op('/'));
      case '(' || ')':
        tokens.add(_Op(c));
      default:
        return null;
    }
    i++;
  }
  return tokens;
}

/// expression := term (('+' | '-') term)*
/// term       := factor (('*' | '/') factor)*
/// factor     := '-' factor | '+' factor | number | '(' expression ')'
class _Parser {
  final List<_Token> _tokens;
  int _pos = 0;

  _Parser(this._tokens);

  bool get isAtEnd => _pos >= _tokens.length;

  _Token? get _peek => isAtEnd ? null : _tokens[_pos];

  bool _matchOp(String op) {
    final t = _peek;
    if (t is _Op && t.op == op) {
      _pos++;
      return true;
    }
    return false;
  }

  double? parseExpression() {
    var left = _parseTerm();
    if (left == null) return null;
    while (true) {
      if (_matchOp('+')) {
        final right = _parseTerm();
        if (right == null) return null;
        left = left! + right;
      } else if (_matchOp('-')) {
        final right = _parseTerm();
        if (right == null) return null;
        left = left! - right;
      } else {
        return left;
      }
    }
  }

  double? _parseTerm() {
    var left = _parseFactor();
    if (left == null) return null;
    while (true) {
      if (_matchOp('*')) {
        final right = _parseFactor();
        if (right == null) return null;
        left = left! * right;
      } else if (_matchOp('/')) {
        final right = _parseFactor();
        if (right == null || right == 0) return null;
        left = left! / right;
      } else {
        return left;
      }
    }
  }

  double? _parseFactor() {
    if (_matchOp('-')) {
      final v = _parseFactor();
      return v == null ? null : -v;
    }
    if (_matchOp('+')) return _parseFactor();
    final t = _peek;
    if (t is _Num) {
      _pos++;
      return t.value;
    }
    if (_matchOp('(')) {
      final v = parseExpression();
      if (v == null || !_matchOp(')')) return null;
      return v;
    }
    return null;
  }
}
