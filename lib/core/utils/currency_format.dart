/// 金額を「¥12,345」の形式にする
/// @TODO 外貨に対応する場合は設定に応じて通貨記号を切り替える
String formatYen(num amount) {
  final digits = amount.round().toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );
  return "¥$digits";
}
