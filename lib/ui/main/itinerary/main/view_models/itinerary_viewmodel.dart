import 'package:flutter/widgets.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/data/model/itinerary_on_edit/itinerary_on_edit.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/data_state.dart';
import 'package:my_travel_app/ui/core/store/itinerary_store.dart';
import 'package:my_travel_app/ui/core/store/travel_scope_store.dart';

import '../../../../../CommonClass/ResultInfo.dart';
import '../../../../../data/model/itinerary_section/itinerary_section.dart';
import '../../../../../data/repositories/itinerary/itinerary_repository.dart';

class ItineraryViewModel extends ChangeNotifier {
  final ItineraryStore _itineraryStore;
  final UserSettingsRepository _userSettingsRepository;
  final TravelScopeStore _travelScopeStore;
  final ItineraryRepository _itineraryRepository;
  final ShownTravelSession _travelSession;
  final AppSession _appSession;

  List<ItinerarySection> _itinerarySections = [];

  List<ItinerarySection> get itinerarySections => _itinerarySections;

  List<ItinerarySection> _editingItinerarySections = [];

  List<ItinerarySection> get editingItinerarySections => _editingItinerarySections;

  ItinerarySection? getSectionById(String id) {
    for (final section in _editingItinerarySections) {
      if (section.id == id) {
        return section;
      }
    }
    return null;
  }

  bool get isItineraryLoading => _itineraryStore.itinerarySections.isLoading;

  ShownTravelBasic? get travel => _travelSession.currentTravel;

  DataState<String?> _roleState = const DataState();

  DataState<String?> get roleState => _roleState;

  String? get userRole {
    if (_roleState.hasError || !_roleState.hasData) {
      return null;
    }
    return _roleState.data;
  }

  bool _editMode = false;

  bool get editMode => _editMode;

  void setEditMode(bool value) {
    _editMode = value;
    notifyListeners();
  }

  bool _isEditLoading = false;

  bool get isEditLoading => _isEditLoading;

  /**
   * Travelが変わったときは
   */
  ItineraryViewModel({
    required ItineraryRepository itineraryRepository,
    required UserSettingsRepository userSettingsRepository, //adminかどうかを判断する
    required ItineraryStore itineraryStore,
    required TravelScopeStore travelScopeStore,
    required ShownTravelSession travelSession,
    required AppSession appSession,
  }) : _itineraryRepository = itineraryRepository,
       _userSettingsRepository = userSettingsRepository,
       _itineraryStore = itineraryStore,
       _travelScopeStore = travelScopeStore,
       _travelSession = travelSession,
       _appSession = appSession {
    print("ItineraryViewModel was created. code=${hashCode}");

    _travelSession.addListener(_travelSessionChanged);
    _itineraryStore.addListener(_itinerarySync);
    _travelScopeStore.addListener(_travelScopeSync);
  }

  void _travelSessionChanged() {
    /* editModeを強制的にオフにする */
  }

  void _itinerarySync() {
    try {
      if (_itineraryStore.itinerarySections.hasError) {
        print("エラーを出したい");
      } else if (_itineraryStore.itinerarySections.hasData) {
        _itinerarySections = _itineraryStore.itinerarySections.data!;
      } else {
        /* エラーでもないけどdataがない */
        print("Probably coding error>>");
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchUserRole() async {
    try {
      final String uid = _appSession.currentUser!.uid;
      final role = await _userSettingsRepository.getUserRole(uid);
      _roleState = DataState(data: role);
    } catch (e) {
      _roleState = DataState(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  void _travelScopeSync() {
    try {} finally {
      notifyListeners();
    }
  }

  Future<ResultInfo<void>> saveItinerary() async {
    /* ローカルの中のitineraryを保存する */
    return ResultInfo.success();
  }

  Future<ResultInfo<void>> saveItineraryForTravel(
    String groupId,
    String travelId,
    List<ItinerarySection> sections /* dynamicでいいのか？？ */,
  ) async {
    try {
      await _itineraryRepository.saveItinerarySections(
        groupId: groupId,
        travelId: travelId,
        sections: sections,
      );
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  Future<ResultInfo> switchEditModePreCheckWithNotify(bool newValue) async {
    _isEditLoading = true;
    notifyListeners();
    final result = await switchEditModePrecheck(newValue);
    _isEditLoading = false;
    notifyListeners();
    return result;
  }

  /// Switchの状態とViewModelのeditModeはきちんと合わせないとずれる。
  Future<ResultInfo> switchEditModePrecheck(bool newValue) async {
    if (_travelSession.currentTravel == null) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: "Travel is not set."));
    }
    final ShownTravelBasic travel = _travelSession.currentTravel!;

    if (newValue) {
      /**
       *  offからonにする場合
       *  on_editをチェックして誰かが触っていないかチェックする
       *  */

      try {
        final onEdit = await _itineraryRepository.getItineraryOnEdit(
          groupId: travel.groupId!,
          travelId: travel.travelId!,
        );
        if (onEdit?.onEdit == true && onEdit?.editor?.uid != _appSession.currentUser!.uid) {
          /* o自分の編集中が残っている場合はそのままで良い */
          /* 仮にAuthもFirebaseではなくなったらどうするんだろう、、 */

          /* プロフィール名を出したい */
          if (!_travelScopeStore.allGroupMembers.hasError &&
              _travelScopeStore.allGroupMembers.hasData &&
              !_travelScopeStore.allGroupMembers.isLoading &&
              onEdit?.editor?.uid != null) {
            final editorUid = onEdit?.editor!.uid;
            print("editorUid=${editorUid} is editing");
            final members = _travelScopeStore.allGroupMembers.data!;
            final displayName = members[editorUid]?.displayName;

            return ResultInfo.failed(error: ErrorInfo(errorMessage: "${displayName}が編集中です"));
          }

          /* 編集者名がちゃんと見つかった場合は上でreturnしている。 */
          return ResultInfo.failed(error: ErrorInfo(errorMessage: "他の人が編集中です"));
        } else {
          /* 誰も編集していない場合は編集して良い */
          /* この中でsetOnEditをすると失敗したときに下のcatchに入ってしまうので、次のブロックで行う */
        }
      } catch (e) {
        return ResultInfo.failed(error: ErrorInfo(errorMessage: "編集状態の取得に失敗しました。: ${e.toString()}"));
      }

      /* onEditで誰も編集していなかったときこちらに来る */
      try {
        final uid = _appSession.currentUser!.uid;
        final email = _appSession.currentUser?.email;

        await _itineraryRepository.setItineraryOnEdit(
          groupId: travel.groupId!,
          travelId: travel.travelId!,
          itineraryOnEdit: ItineraryOnEdit(
            onEdit: true,
            editor: TravelerCore(uid: uid, email: email ?? "") /* emailが空になっていることはないはず、、 */,
          ),
        );
      } catch (e) {
        print("${e.toString()}");
        return ResultInfo.failed(error: ErrorInfo(errorMessage: "編集状態の設定に失敗しました"));
      }
      return ResultInfo.success();
    } else {
      /**
       * onからoffにする場合
       * on_editの中身を初期状態に戻す
       */
      try {
        await _itineraryRepository.removeItineraryOnEdit(
          groupId: travel.groupId!,
          travelId: travel.travelId!,
        );
      } catch (e) {
        return ResultInfo.failed(error: ErrorInfo(errorMessage: "編集状態の更新に失敗しました。: ${e.toString()}"));
      }
      return ResultInfo.success();
    }
  }

  void copySectionsToBuffer() {
    _editingItinerarySections = List.from(_itinerarySections);
    notifyListeners();
  }

  void reorderSection(int oldIndex, int newIndex) {
    print("reorder called :${oldIndex} ${newIndex}");
    if (newIndex > oldIndex) {
      /* 一個removeAtで消えるので一個ずれる？ */
      newIndex -= 1;
    }
    /* removeAtの戻り値は消された要素 */
    final ItinerarySection item = _editingItinerarySections.removeAt(oldIndex);
    _editingItinerarySections.insert(newIndex, item);
    notifyListeners();
  }

  int removeSection(String id) {
    final index = _editingItinerarySections.indexWhere((element) => element.id == id);

    if (index == -1) return -1;

    _editingItinerarySections.removeAt(index);
    notifyListeners();
    return 0;
  }

  int addSection(ItinerarySection section) {
    _editingItinerarySections.add(section);
    notifyListeners();
    return 0;
  }

  int updateItineraryMarkdownSection({
    required String sectionId,
    required String title,
    required String content,
  }) {
    final index = _editingItinerarySections.indexWhere((element) => element.id == sectionId);
    if (index == -1) return -1;

    _editingItinerarySections[index] = MarkdownSection(id: sectionId, title: title, content: content);
    notifyListeners();
    return 0;
  }

  @override
  void dispose() {
    print("ItineraryViewModel was disposed. code=${hashCode}");

    _travelSession.removeListener(_travelSessionChanged);
    _itineraryStore.removeListener(_itinerarySync);
    _travelScopeStore.removeListener(_travelScopeSync);
    // TODO: implement dispose
    super.dispose();
  }
}
