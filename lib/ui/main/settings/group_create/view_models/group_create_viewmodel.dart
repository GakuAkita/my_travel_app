import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';
import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';
import 'package:my_travel_app/data/repositories/users/users_repository.dart';
import 'package:my_travel_app/ui/core/store/data_state.dart';
import 'package:my_travel_app/ui/main/expenses/add_edit/widgets/selected_user.dart';

class GroupCreateViewModel extends ChangeNotifier {
  final UsersRepository _usersRepository;

  DataState<Map<String, SelectedUser>> _allUsers = DataState(data: {});

  DataState<Map<String, SelectedUser>> get allUsers => _allUsers;

  GroupCreateViewModel({required UsersRepository usersRepository})
    : _usersRepository = usersRepository {
    getAllUserIds();
  }

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

  /// やり方が汚いけど、一旦これで。本当はURL共有とかでグループ追加できるようにしたい。
  Future<void> getAllUserIds() async {
    try {
      /* mapでごちゃまぜに入っている */
      final data = await _usersRepository.getUsers();
      Map<String, SelectedUser> buf = {};
      for (final key in data.keys) {
        final uid = key;
        final email = data[key]!["email"];

        /* ロードし直したら一回リセットでいいか */
        buf[uid] = SelectedUser(
          traveler: TravelerBasic(core: TravelerCore(uid: uid, email: email)),
          isChecked: false,
        );
      }

      _allUsers = DataState(data: buf);
    } catch (e) {
      _allUsers = DataState(error: ErrorInfo(errorMessage: e.toString()));
    } finally {
      notifyListeners();
    }
  }

  /* あるuidのやつをスイッチする */
  void switchChecked(String uid) {
    if (_allUsers.data == null) return;
    if (_allUsers.data![uid] == null) return;
    _allUsers.data![uid] = _allUsers.data![uid]!.copyWith(
      isChecked: !_allUsers.data![uid]!.isChecked,
    );
    notifyListeners();
  }
}
