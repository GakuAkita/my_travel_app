import 'package:my_travel_app/CommonClass/ErrorInfo.dart';

enum ResultStatus { success, loading, timeout, failed }

class ResultInfo<T> {
  final ResultStatus status;
  final T? data; // 成功でも null の可能性がある
  final String? message; // 成功でも null の可能性がある
  final ErrorInfo? error;

  ResultInfo._({required this.status, this.data, this.message, this.error});

  factory ResultInfo.success({T? data, String? message}) {
    return ResultInfo._(
      status: ResultStatus.success,
      data: data,
      message: message,
    );
  }

  factory ResultInfo.loading() {
    return ResultInfo._(status: ResultStatus.loading);
  }

  factory ResultInfo.timeout({ErrorInfo? error}) {
    return ResultInfo._(status: ResultStatus.timeout, error: error);
  }

  factory ResultInfo.failed({ErrorInfo? error}) {
    return ResultInfo._(status: ResultStatus.failed, error: error);
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
        return ResultInfo<void>.success(message: message);
      case ResultStatus.loading:
        return ResultInfo<void>.loading();
      case ResultStatus.timeout:
        return ResultInfo<void>.timeout(error: error);
      case ResultStatus.failed:
        return ResultInfo<void>.failed(error: error);
    }
  }
}
