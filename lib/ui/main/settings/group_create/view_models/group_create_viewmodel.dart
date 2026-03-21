import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';
import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';
import 'package:my_travel_app/data/repositories/users/users_repository.dart';
import 'package:my_travel_app/domain/use_cases/crud_group_use_case.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/ui/core/store/data_state.dart';
import 'package:my_travel_app/ui/main/expenses/add_edit/widgets/selected_user.dart';

class GroupCreateViewModel extends ChangeNotifier {
  final UsersRepository _usersRepository;
  final CrudGroupUseCase _crudGroupUseCase;
  final AppSession _appSession;

  DataState<Map<String, SelectedUser>> _allUsers = DataState(data: {});

  DataState<Map<String, SelectedUser>> get allUsers => _allUsers;

  GroupCreateViewModel({
    required AppSession appSession,
    required UsersRepository usersRepository,
    required CrudGroupUseCase crudGroupUseCase,
  }) : _appSession = appSession,
       _usersRepository = usersRepository,
       _crudGroupUseCase = crudGroupUseCase {
    getAllUserIds();
  }

  Future<ResultInfo> createGroup(String name) async {
    if (name.isEmpty) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "グループ名を入力してください"),
      );
    }

    /* allUsersからチェックされているやつだけを抽出する */
    if (!_allUsers.hasData) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: "データがありません"));
    }
    final Map<String, SelectedUser> users = _allUsers.data!;
    bool found = false;
    Map<String, TravelerCore> members = {};
    for (final user in users.values) {
      if (user.isChecked) {
        found = true;
        members[user.traveler.core.uid] = user.traveler.core;
      }
    }
    if (!found) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: "メンバーを選択してください"));
    }

    /* 本当は被っていないかと、禁止文字が入っていないかチェックしたい、、 */
    try {
      final creatorId = _appSession.currentUser!.uid;
      final creatorEmail = _appSession.currentUser!.email!;
      await _crudGroupUseCase.createGroup(
        members,
        TravelerCore(uid: creatorId, email: creatorEmail),
        name,
      );
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
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
