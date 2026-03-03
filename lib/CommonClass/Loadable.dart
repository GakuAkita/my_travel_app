import 'package:my_travel_app/CommonClass/ErrorInfo.dart';

sealed class Loadable<T> {
  const Loadable();
}

class NotLoaded<T> extends Loadable<T> {
  const NotLoaded();
}

class Loading<T> extends Loadable<T> {
  const Loading();
}

class Success<T> extends Loadable<T> {
  final T value;

  const Success(this.value);
}

class Failure<T> extends Loadable<T> {
  final ErrorInfo error;

  const Failure(this.error);
}
