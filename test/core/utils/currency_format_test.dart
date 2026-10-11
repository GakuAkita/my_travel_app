import 'package:flutter_test/flutter_test.dart';
import 'package:my_travel_app/core/utils/currency_format.dart';

void main() {
  test('formatYenは円単位に丸めて3桁ごとにカンマを入れる', () {
    expect(formatYen(0), "¥0");
    expect(formatYen(30000), "¥30,000");
    expect(formatYen(1234567.6), "¥1,234,568");
    expect(formatYen(-4000), "-¥4,000");
  });

  test('formatYenExactは端数があるときだけ小数第2位まで出す', () {
    expect(formatYenExact(1200), "¥1,200");
    expect(formatYenExact(10000 / 3), "¥3,333.33");
    expect(formatYenExact(-10000 / 3), "-¥3,333.33");
    expect(formatYenExact(0.5), "¥0.50");
    expect(formatYenExact(-0.05), "-¥0.05");
  });
}
