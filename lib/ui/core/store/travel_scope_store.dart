import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/core/utils/CheckShownTravelBasic.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository.dart';
import 'package:my_travel_app/data/repositories/participants/participants_repository.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/data_state.dart';

import '../../../CommonClass/ResultInfo.dart';
import '../../../data/model/traveler/traveler_basic.dart';
import '../../../data/model/traveler/traveler_core/traveler_core.dart';

/// 画面に関わらず、旅行ごとに持っているもの。
class TravelScopeStore extends ChangeNotifier {
  final ShownTravelSession _session;
  final GroupMembersRepository _groupMembersRepository;
  final ParticipantsRepository _participantsRepository;
  final UserSettingsRepository _userSettingsRepository;

  bool _storeInitialized = false;

  bool get storeInitialized => _storeInitialized;

  TravelScopeStore({
    required ShownTravelSession session,
    required GroupMembersRepository groupMembersRepository,
    required ParticipantsRepository participantsRepository,
    required UserSettingsRepository userSettingsRepository,
  }) : _session = session,
       _groupMembersRepository = groupMembersRepository,
       _participantsRepository = participantsRepository,
       _userSettingsRepository = userSettingsRepository {
    print("TravelScopeViewModel was created. hashCode=${hashCode}");

    _session.addListener(_refresh);
  }

  void _refresh() async {
    print("TravelScopeStore detected change in ShownTravelSession.");
    if (!_session.initialized) {
      /**
       * travelSessionはログアウトしない限りは作り直されることはないので、
       * 一度trueになればそれ以降ずっとtrue
       */
      print("travelSession not initialized!! in TravelScopeStore");
      return;
    }

    try {
      /* ここに来た時点でTravelSessionは初期化されている */
      await Future.wait([
        _refreshAllGroupMembers(
          isLastNotify: false,
          isLoadingNotify: true,
          isGetProfileName: true,
        ),
        _refreshParticipants(isLastNotify: false, isLoadingNotify: true),
      ]);
    } finally {
      if (!_storeInitialized) {
        print("TravelScopeStore was initialized");
        _storeInitialized = true;
      }
      notifyListeners();
    }
  }

  /**
   *  保持しているデータ
   *  基本的に外から参照される前提
   *  */

  DataState<Map<String, TravelerBasic>> _allGroupMembers = const DataState();

  DataState<Map<String, TravelerBasic>> get allGroupMembers => _allGroupMembers;

  DataState<Map<String,TravelerCore>> _planners = const DataState();

  DataState<Map<String,TravelerCore>> get planners => _planners;

  DataState<Map<String, TravelerCore>> _participants = const DataState();

  DataState<Map<String, TravelerCore>> get participants => _participants;

  /* sessionに紐づいているから他の旅行の取る場面はないと想定。 */
  Future<void> _refreshAllGroupMembers({
    bool isLoadingNotify = true,
    bool isLastNotify = true,
    bool isGetProfileName = true,
  }) async {
    try {
      if (_session.currentTravel == null) {
        _allGroupMembers = const DataState(
          data: {},
          isLoading: false,
          error: null,
        );
        return;
      }
      if (!checkIsShownTravelValid(_session.currentTravel!).isSuccess) {
        _allGroupMembers = DataState(
          isLoading: false,
          error: ErrorInfo(
            errorMessage: "Invalid shown travel. Probably Coding error.",
          ),
        );
        return;
      }
      _allGroupMembers = const DataState(isLoading: true, error: null);
      if (isLoadingNotify) {
        notifyListeners();
      }

      final _data = await _groupMembersRepository.getAllGroupMembers(
        _session.currentTravel!.groupId!,
      );

      Map<String, TravelerBasic> data = _data.toTravelerBasicMap();
      if (isGetProfileName) {
        await Future.wait([
          /* getPutMembersProfileNAmesにawaitしたら並行処理の意味ない */
          for (final uid in data.keys)
            getPutMembersProfileName(uid, isLastNotify: false),
        ]);
      }

      _allGroupMembers = DataState(data: data, isLoading: false, error: null);
      return;
    } catch (e) {
      _allGroupMembers = DataState(
        data: null,
        isLoading: false,
        error: ErrorInfo(errorMessage: e.toString()),
      );
    } finally {
      if (isLastNotify) {
        notifyListeners();
      }
    }
  }

  /* グループメンバーを変えずにメンバーのプロフィール名だけ更新したいとき */
  Future<ResultInfo> getPutMembersProfileName(
    String uid, {
    bool isLastNotify = true,
  }) async {
    if (_allGroupMembers.hasError) {
      return ResultInfo.failed(error: _allGroupMembers.error!);
    }

    try {
      if (_allGroupMembers.hasData) {
        final profileName = await _userSettingsRepository.getProfileName(uid);
        if (_allGroupMembers.data![uid] != null) {
          _allGroupMembers.data![uid] = _allGroupMembers.data![uid]!.copyWith(
            profile_name: profileName,
          );
        }
      }
      return ResultInfo.success();
    } finally {
      if (isLastNotify) {
        notifyListeners();
      }
    }
  }

  Future<void> _refreshParticipants({
    bool isLastNotify = true,
    bool isLoadingNotify = true,
  }) async {
    try {
      if (_session.currentTravel == null) {
        _participants = const DataState(
          data: {},
          isLoading: false,
          error: null,
        );
        return;
      }

      if (!checkIsShownTravelValid(_session.currentTravel!).isSuccess) {
        _participants = DataState(
          isLoading: false,
          error: ErrorInfo(
            errorMessage: "Invalid Travel. Probably coding error",
          ),
        );
        return;
      }

      _participants = const DataState(isLoading: true, error: null);
      if (isLoadingNotify) {
        notifyListeners();
      }

      final groupId = _session.currentTravel!.groupId!;
      final travelId = _session.currentTravel!.travelId!;
      final data = await _participantsRepository.getAllTravelers(
        groupId,
        travelId,
      );
      _participants = DataState(data: data, isLoading: false, error: null);
    } finally {
      if (isLastNotify) {
        notifyListeners();
      }
    }
  }

  Future<void> _refresh

  @override
  void dispose() {
    print("TravelScopeStore was disposed: hashcode=${hashCode}");
    // TODO: implement dispose
    _session.removeListener(_refresh);
    super.dispose();
  }
}
