/// 3桁ごとにカンマを入れる(例: 12345 -> 12,345)
String _withComma(int value) {
  return value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
}

/// 金額を「¥12,345」の形式にする。負の値は「-¥12,345」
/// @TODO 外貨に対応する場合は設定に応じて通貨記号を切り替える
String formatYen(num amount) {
  final rounded = amount.round();
  final sign = rounded < 0 ? "-" : "";
  return "$sign¥${_withComma(rounded.abs())}";
}

/// 割り勘で端数が出るときは小数第2位まで出す(例: ¥3,333.33)。整数ならformatYenと同じ
String formatYenExact(num amount) {
  final cents = (amount * 100).round();
  if (cents % 100 == 0) return formatYen(cents ~/ 100);
  final sign = cents < 0 ? "-" : "";
  final abs = cents.abs();
  return "$sign¥${_withComma(abs ~/ 100)}.${(abs % 100).toString().padLeft(2, '0')}";
}
