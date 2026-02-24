import 'package:flutter/cupertino.dart';

mixin LoadableMixin on ChangeNotifier {
  int _loadingCount = 0;

  bool get isLoading => _loadingCount > 0;

  Future<T> runWithLoading<T>(Future<T> Function() task) async {
    final shouldNotifyStart = _loadingCount == 0;
    _loadingCount++;

    /* notifyをなんどもやらないため。 */
    /* 例えば、もうローディングしているのに、notifyしても無駄にrebuildするだけ。 */
    if (shouldNotifyStart) {
      notifyListeners();
    }

    try {
      return await task();
    } finally {
      _loadingCount--;

      if (_loadingCount == 0) {
        notifyListeners();
      }
    }
  }
}
