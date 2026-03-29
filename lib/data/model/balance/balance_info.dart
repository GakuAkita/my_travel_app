import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance_info.freezed.dart';
part 'balance_info.g.dart';

@freezed
abstract class BalanceInfo with _$BalanceInfo {
  const factory BalanceInfo({
    required String uid,
    required double netTotal,
    required double reimbursedSum,
    required double paidSum,
  }) = _BalanceInfo;

  factory BalanceInfo.fromJson(Map<String, dynamic> json) =>
      _$BalanceInfoFromJson(json);
}
