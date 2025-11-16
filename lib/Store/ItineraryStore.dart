import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/OnItineraryEdit.dart';
import 'package:my_travel_app/CommonClass/ShownTravelBasic.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';

import '../CommonClass/ErrorInfo.dart';
import '../CommonClass/ItineraryDefaultTable.dart';
import '../CommonClass/ItinerarySection.dart';
import '../CommonClass/ResultInfo.dart';
import '../Services/FirebaseDatabaseService.dart';
import '../constants.dart';

/**
 * UserStoreでnotifyListenersされたら
 * こっちも更新するようにしたい。
 */
class ItineraryStore extends ChangeNotifier {
  ShownTravelBasic? _shownTravelBasic;
  ShownTravelBasic? get shownTravelBasic => _shownTravelBasic;
  String? _currentUserId;
  String? get currentUserId => _currentUserId;

  List<ItinerarySection> _itinerarySections = [];

  Map<String, TravelerBasic> _allParticipants = {};
  Map<String, TravelerBasic> get allParticipants => _allParticipants;

  bool _editMode = false;
  bool get editMode => _editMode;

  ResultInfo _itineraryState = ResultInfo.success();
  ResultInfo get itineraryState => _itineraryState;

  bool _initialized = false;

  ItineraryStore() {
    /**
     * print分的に、
     */
    print("ItineraryStore: Initialized.");
  }

  void clearItineraryData() {
    print("ItineraryStore: clear itinerary data.");
    _itinerarySections = [];
    _itineraryState = ResultInfo.success();
    _editMode = false;
    notifyListeners();
  }

  void clearAllData() {
    print("ItineraryStore: clear all data.");
    _shownTravelBasic = null;
    _currentUserId = null;
    _itinerarySections = [];
    _allParticipants = {};
    _itineraryState = ResultInfo.success();
    _editMode = false;
    notifyListeners();
  }

  /**
   * 新しいShownTravelBasicとUidを比較して
   * ロードすべきか判断したい
   */
  void compareAndUpdateWithUser(ShownTravelBasic? travelBasic, String? userId) {
    print(
      "ItineraryStore compareAndUpdateWithUser: ${_shownTravelBasic?.travelId} -> ${travelBasic?.travelId} uid:${userId}",
    );
    if (_shownTravelBasic == null ||
        travelBasic == null ||
        _shownTravelBasic!.groupId != travelBasic.groupId ||
        _shownTravelBasic!.travelId != travelBasic.travelId ||
        _currentUserId != userId ||
        _initialized == false) {
      _initialized = true;

      // どれか一つでも違ったら更新する
      print("!!! ItineraryStore: Travel or User changed. Update data. !!!");
      updateWithUser(travelBasic, userId);
      if (travelBasic == null || userId == null) {
        // 旅行がnullならデータをクリアする
        clearAllData();
      } else {
        // 旅行が変わったのでデータをロードする
        loadItineraryDataWithNotify(travelBasic);
      }
    } else {
      print(
        "ItineraryStore: Travel${_shownTravelBasic?.travelId} and User are the same. No update.",
      );
    }
  }

  void updateWithUser(ShownTravelBasic? travelBasic, String? userId) {
    _shownTravelBasic = travelBasic;
    _currentUserId = userId;
  }

  Future<void> setEditMode(bool val) async {
    if (_shownTravelBasic == null ||
        _shownTravelBasic!.groupId == null ||
        _shownTravelBasic!.travelId == null) {
      print("ShownTravelBasic is not set.");
      return;
    }
    if (_currentUserId == null) {
      print("Current user ID is not set.");
      return;
    }
    final travelerBasic = _allParticipants[_currentUserId];
    if (travelerBasic == null) {
      print("Current user not found in participants.");
      return;
    }

    final groupId = _shownTravelBasic!.groupId!;
    final travelId = _shownTravelBasic!.travelId!;

    /**
     *
     * */
    final getRet = await FirebaseDatabaseService.getSingleTravelItineraryOnEdit(
      groupId,
      travelId,
    );
    if (!getRet.isSuccess) {
      /* 失敗する */
      print("Unable to get edit mode: ${getRet.error?.errorMessage}");
      return;
    } else {
      /* ここでもし、誰かが編集していたらブロックする */
    }

    final onEdit = OnItineraryEdit(
      uid: travelerBasic.uid,
      email: travelerBasic.email,
      on_edit: val,
    );

    /* リモートで誰かがリモートロックしていないかチェックする */
    /* とりあえずセットしてみる */
    final ret = await FirebaseDatabaseService.setSingleTravelItineraryOnEdit(
      groupId,
      travelId,
      onEdit,
    );
    if (!ret.isSuccess) {
      print("Unable to set edit mode: ${ret.error?.errorMessage}");
      return;
    } else {
      print("Edit mode set successfully.");
      _editMode = val;
      notifyListeners();
    }
  }

  /* UnmodifiableListViewで読み取り専用にする */
  List<ItinerarySection> getData() {
    return _itinerarySections;
  }

  /**********************************
   * ローカルで持つべきデータを一気に取ってくる
   **********************************/
  Future<ResultInfo> loadItineraryDataWithNotify(
    ShownTravelBasic? travelBasic, {
    bool isStateNotify = true,
  }) async {
    print(
      "-----------ItineraryStore: loadItineraryDataWithNotify called.---------------",
    );
    _itineraryState = ResultInfo.loading();
    if (isStateNotify) {
      notifyListeners();
    }

    final ret = await _loadItineraryData(travelBasic);
    _itineraryState = ret;
    notifyListeners();
    return ret;
  }

  /*********************************************
   * 旅行の行程表のデータ処理
   *********************************************/
  void addSection(String type) {
    _itinerarySections.add(
      ItinerarySection(
        type: type,
        title: "",
        content:
            type == ItinerarySectionType.markdown
                ? ""
                : null, // テーブル用の初期データはここにJSONなどを使う想定
        tableData:
            type == ItinerarySectionType.defaultTable
                ? ItineraryDefaultTable() /* headerもtableCellsも両方[]が入る */
                : null,
      ),
    );

    notifyListeners();
  }

  void removeSection(int index) {
    _itinerarySections.removeAt(index);
    notifyListeners();
  }

  void reorderSection(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final ItinerarySection item = _itinerarySections.removeAt(oldIndex);
    _itinerarySections.insert(newIndex, item);
    notifyListeners();
  }

  void updateSectionTitle(int index, String title) {
    _itinerarySections[index].title = title;
    notifyListeners();
  }

  void updateSectionContent(int index, String content) {
    _itinerarySections[index].content = content;
    notifyListeners();
  }

  Future<ResultInfo> _loadItineraryData(ShownTravelBasic? travelBasic) async {
    try {
      print("Started loading Itinerary!!");
      if (travelBasic == null) {
        clearItineraryData();
        return ResultInfo.success();
      } else if (travelBasic.groupId == null || travelBasic.travelId == null) {
        /* 何もしない */
        return ResultInfo.failed(
          error: ErrorInfo(
            errorCode: "invalid-travel-basic",
            errorMessage:
                "Invalid travel basic data. This is the bug. Let the developer know.",
          ),
        );
      } else {
        /* ShownTravelが入っている */
      }

      final groupId = travelBasic.groupId!;
      final travelId = travelBasic.travelId!;

      /* 参加者をロード */
      final retPart = await _loadAllParticipants(groupId, travelId);
      if (!retPart.isSuccess) {
        print("Failed in loadAllParticipants: ${retPart.error?.errorMessage}");
        return retPart;
      }
      print(
        "ItineraryStore: Participants loaded successfully. Count: ${_allParticipants.length}",
      );

      /* Firebaseからデータを取ってくる。 */
      /**
       * データを取ってきてからitinerarySectionに変換する必要ある。
       */
      final secRet =
          await FirebaseDatabaseService.getSingleTravelItinerarySections(
            groupId,
            travelId,
          );
      /* このlistを変換する */
      if (!secRet.isSuccess) {
        print("Unable to load itinerary Data ${secRet.error?.errorMessage}");
        return secRet;
      }

      final secList = secRet.data;
      if (secList == null) {
        print("secList is null. itinerary is empty. This is not an error.");
        _itinerarySections = [];
        return ResultInfo.success(
          message: "No itinerary data found, so no data loaded.",
        );
      }
      List<ItinerarySection> bufList = [];
      /* ここでリストの要素を変換していく。 */
      for (final Map<String, dynamic> section in secList) {
        bufList.add(ItinerarySection.convToItinerarySection(section));
      }

      // for (final s in bufList) {
      //   //print("Itinerary Section:${s.content} ");
      // }
      _itinerarySections = bufList;
      return ResultInfo.success();
    } catch (e) {
      print("loadData Error:$e");
      return ResultInfo.failed(
        error: ErrorInfo(
          errorCode: "unknown-error",
          errorMessage:
              "Unknown error occurred while loading itinerary data.${e.toString()}",
        ),
      );
    } finally {
      notifyListeners();
    }
  }

  /*************************************************
   * 現在ログイン中のユーザーが表示している旅行のグループのメンバー情報
   *********************************************/
  Future<ResultInfo> _loadAllParticipants(
    String groupId,
    String travelId,
  ) async {
    /**
     * 中で割と無駄なことをやっているので、
     * 将来的にFirestoreに移行するのもあり。この部分だけでも。
     */
    final fetchResult = await FirebaseDatabaseService.getTravelParticipants(
      groupId,
      travelId,
    );

    /**
     * 失敗した場合値は更新しないことにする。
     */
    if (fetchResult.isSuccess && fetchResult.data != null) {
      _allParticipants = fetchResult.data!;
      return ResultInfo.success();
    } else {
      /* 何もしない */
      return fetchResult;
    }
  }

  void saveData(String groupId, String travelId) async {
    final sectionsRef =
        FirebaseDatabaseService.singleTravelItinerarySectionsRef(
          groupId,
          travelId,
        );

    final List<Map<String, dynamic>> sectionMaps =
        _itinerarySections.map((s) => s.convToMap()).toList();

    await sectionsRef.set(sectionMaps);
    notifyListeners();
  }

  /* itinerarySectionsからFirebaseに保存できるような形に変換する */

  void addTableRow(int index) {
    _itinerarySections[index].tableData!.tableCells.add(["", "", ""]);
    notifyListeners();
  }

  void removeTableRow(int secIndex, int rowIndex) {
    _itinerarySections[secIndex].tableData!.tableCells.removeAt(rowIndex);
    notifyListeners();
  }

  void reorderTableRow(int secIndex, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final tableCells = _itinerarySections[secIndex].tableData!.tableCells;
    final item = tableCells.removeAt(oldIndex);
    tableCells.insert(newIndex, item);
    notifyListeners();
  }

  void initItinerarySections() {
    _itinerarySections = [];
    _editMode = false;
    notifyListeners();
  }
}
