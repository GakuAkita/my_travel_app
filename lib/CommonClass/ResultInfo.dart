import 'package:my_travel_app/CommonClass/ErrorInfo.dart';

enum ResultStatus { success, loading, timeout, failed }

class ResultInfo<T> {
  final ResultStatus status;
  final T? data; // 成功でも null の可能性がある
  final String? message; // 成功でも null の可能性がある
  final ErrorInfo? error;
  final dynamic extraData;

  ResultInfo._({
    required this.status,
    this.data,
    this.message,
    this.error,
    this.extraData,
  });

  factory ResultInfo.success({T? data, String? message, dynamic extraData}) {
    return ResultInfo._(
      status: ResultStatus.success,
      data: data,
      message: message,
      extraData: extraData,
    );
  }

  factory ResultInfo.loading() {
    return ResultInfo._(status: ResultStatus.loading);
  }

  factory ResultInfo.timeout({ErrorInfo? error, dynamic extraData}) {
    return ResultInfo._(
      status: ResultStatus.timeout,
      error: error,
      extraData: extraData,
    );
  }

  factory ResultInfo.failed({ErrorInfo? error, dynamic extraData}) {
    return ResultInfo._(
      status: ResultStatus.failed,
      error: error,
      extraData: extraData,
    );
  }

  bool get isSuccess => status == ResultStatus.success;
  bool get isLoading => status == ResultStatus.loading;
  bool get isFailed => status == ResultStatus.failed;
  bool get isTimeout => status == ResultStatus.timeout;
}

extension ResultInfoVoidExtension<T> on ResultInfo<T> {
  /// データを破棄して ResultInfo<void> に変換
  ResultInfo<void> toVoid() {
    switch (status) {
      case ResultStatus.success:
        return ResultInfo<void>.success(message: message, extraData: extraData);
      case ResultStatus.loading:
        return ResultInfo<void>.loading();
      case ResultStatus.timeout:
        return ResultInfo<void>.timeout(error: error, extraData: extraData);
      case ResultStatus.failed:
        return ResultInfo<void>.failed(error: error, extraData: extraData);
    }
  }
}
