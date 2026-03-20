import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';

class GroupCreateViewModel extends ChangeNotifier {
  GroupCreateViewModel();

  Future<ResultInfo> createGroup(String name) async {
    if (name.isEmpty) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "グループ名を入力してください"),
      );
    }

    /* グループキーを作る */

    /* グループメンバーを設定 */

    /* 各メンバーのjoined groupに追加 */
    return ResultInfo.success();
  }
}
