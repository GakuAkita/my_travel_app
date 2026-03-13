import 'package:my_travel_app/CommonClass/ErrorInfo.dart';

class DataState<T> {
  final T? data;
  final bool isLoading;
  final ErrorInfo? error;

  const DataState({this.data, this.isLoading = false, this.error});

  bool get hasError => error != null;

  bool get hasData => data != null;
}
