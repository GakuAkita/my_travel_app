import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/CommonClass/ShownTravelBasic.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';
import 'package:my_travel_app/Services/FirebaseDatabaseService.dart';
import 'package:my_travel_app/Services/UserService.dart';

import '../CommonClass/ErrorInfo.dart';
import '../Services/AuthService.dart';
import '../constants.dart';

/**
 * Store!!!!
 */
class UserStore extends ChangeNotifier {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  String? _currentUserId;
  String? get currentUserId => _currentUserId;
  String _userRole = UserRole.normal;
  String get userRole => _userRole;

  ShownTravelBasic? _shownTravelBasic;
  ShownTravelBasic? get shownTravelBasic => _shownTravelBasic;

  TravelerBasic? _gManager;
  TravelerBasic? get gManager => _gManager;

  bool _isGManager = false;
  bool get isGManager => _isGManager;

  ResultInfo _userStoreState = ResultInfo.success();
  ResultInfo get userStoreState => _userStoreState;

  bool _initialized = false;
  UserStore() {
    // 初期化時にデータをロード(したのと被っているので2回呼ばれるのでコメントアウト)

    /**
     * まじでアプリ起動時複数回呼ばれるのなんとかならないかな、、
     */
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!_initialized) {
        print("=========This is the first load ========");
        _initialized = true;
        /* これは本当の初回のロード */
        /* これがないと2回走ってしまう。 */
        if (user != null) {
          print("UserStore: Initial user is not null: ${user.uid}");
          //loadUserStoreDataWithNotify();
        } else {
          clearAllData();
          //なんかこれも2回呼ばれている気がするけどまあいいか。
          print("UserStore: All data cleared on initial null user.");
        }
      } else {
        print("========= Auth state changed ${user?.uid}========");
        if (user == null) {
          clearAllData();
        } else {
          loadUserStoreDataWithNotify();
          FirebaseDatabaseService.setCurrentUserLastLoginToNow();
        }
      }
    });
  }

  void clearAllData() {
    _currentUserId = null;
    _userRole = UserRole.normal;
    _shownTravelBasic = null;
    _gManager = null;
    _isGManager = false;
    _userStoreState = ResultInfo.success();
    print("UserStore: All data cleared on sign out.");
    notifyListeners();
  }

  /**
   * ユーザー作成やサインイン系
   */
  Future<ResultInfo> login(String email, String password) async {
    /**
     * サインイン後の処理はauthStateChangesでやる
     */
    final ret = await _authService.login(email, password);
    if (ret.userCredential != null) {
      /* サインイン成功 */
      return ResultInfo.success();
    } else {
      /* サインイン失敗 */
      return ResultInfo.failed(
        error: ErrorInfo(
          errorCode: ret.errorCode ?? "unknown-error",
          errorMessage: ret.message ?? "Unknown error occurred during sign in.",
        ),
      );
    }
  }

  Future<ResultInfo> signUp(String email, String password) async {
    final ret = await _authService.signUp(email, password);
    if (ret.userCredential == null) {
      /* サインアップ失敗 */
      return ResultInfo.failed(
        error: ErrorInfo(
          errorCode: ret.errorCode ?? "unknown-error",
          errorMessage: ret.message ?? "Unknown error occurred during sign up.",
        ),
      );
    }

    /* サインアップ成功したらユーザーデータを作成 */
    final createRet = await _userService.createUserData(
      ret.userCredential!.user!.uid,
      email,
    );
    if (createRet.isFailed) {
      return createRet;
    }

    /* サインアップ成功 */
    return ResultInfo.success();
  }

  Future<ResultInfo> signOut() async {
    final ret = await _authService.signOut();
    if (ret.success) {
      return ResultInfo.success();
    } else {
      return ResultInfo.failed(
        error: ErrorInfo(
          errorCode: "sign-out-failed",
          errorMessage:
              ret.message ?? "Unknown error occurred during sign out.",
        ),
      );
    }
  }

  /**
   * アプリ起動時画面が作られていないのに
   * notifyListenersを読んでしまうので待つ
   */
  void notifyListenersWithWaitForBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /***
   * データを取ってきて、最後にnotifyListenersを呼ぶ
   * */
  Future<ResultInfo> loadUserStoreDataWithNotify() async {
    print("**** Start loadUserStoreDataWithNotify ****");
    _userStoreState = ResultInfo.loading();
    /**
     * あーここで2回呼ばれるのか？？
     */
    notifyListenersWithWaitForBuild();

    final ret = await _loadUserStoreData();
    _userStoreState = ret;
    notifyListenersWithWaitForBuild();
    return ret;
  }

  Future<ResultInfo> _loadUserStoreData() async {
    final _ = await _loadCurrentUserId();
    if (_currentUserId == null) {
      return ResultInfo.success(
        message: "No user is logged in. UserStore is cleared.",
      );
    }

    final userRoleRet = await _loadCurrentUserRole();
    if (!userRoleRet.isSuccess) {
      print(
        "Failed to load user role data. ${userRoleRet.error?.errorMessage}",
      );
      /* 失敗しても次へ */
    }

    final travelRet = await _loadShownTravelWithManager();
    if (!travelRet.isSuccess) {
      print(
        "Failed to load shown travel data. ${travelRet.error?.errorMessage}",
      );
      /* 失敗しても次へ */
      return travelRet;
    }
    return ResultInfo.success();
  }

  /*********************************************
   * そもそもユーザーIDを取得
   * これはほぼ変わらない
   *********************************************/
  Future<ResultInfo> _loadCurrentUserId() async {
    _currentUserId = AuthService.currentUser?.uid;
    return ResultInfo.success();
  }

  /**
   * これだけ現在ユーザーのみだが、、
   * まあいいｙは
   */
  Future<ResultInfo> _loadCurrentUserRole() async {
    final ret = await FirebaseDatabaseService.getCurrentUserRole();
    /* ローカルを書き換える */
    if (ret.isSuccess) {
      _userRole = ret.data ?? UserRole.normal;
    } else {
      _userRole = UserRole.normal;
    }
    return ret;
  }

  Future<ResultInfo> _loadGManagerId(String groupId, String travelId) async {
    final ret = await FirebaseDatabaseService.getSingleTravelGManager(
      groupId,
      travelId,
    );
    if (ret.isSuccess) {
      _gManager = ret.data;
    } else {
      _gManager = null;
    }
    return ret;
  }

  /*************************************************
   * 現在ログイン中のユーザーが表示している旅行の情報
   * これがまず最初に必要
   *********************************************/
  Future<ResultInfo> _loadShownTravel(String? uid) async {
    if (uid == null) {
      _shownTravelBasic = null;
    } else {
      /**
       * これ以降はUIDが入っているということ
       */
      final shownTravel =
          await FirebaseDatabaseService.getSingleUserShownTravel(uid);
      /**
       * nullならnullが返ってくるのでそのままいれる
       */
      _shownTravelBasic = shownTravel;
    }
    return ResultInfo.success();
  }

  Future<ResultInfo> loadShownTravelWithManagerWithNotify() async {
    final ret = await _loadShownTravelWithManager();
    notifyListeners();
    return ret;
  }

  /**
   * ShownTravel関連を再読み込み
   * ShownTravelが変わったときに呼び出す
   */
  Future<ResultInfo> _loadShownTravelWithManager() async {
    if (_currentUserId == null) {
      return ResultInfo.failed(
        error: ErrorInfo(
          errorCode: "no-user",
          errorMessage: "No user is logged in. Impossible to load travel.",
        ),
      );
    }
    final ret = await _loadShownTravel(_currentUserId);
    if (!ret.isSuccess) {
      _shownTravelBasic = null;
      _gManager = null;
      _isGManager = false;
      return ret;
    }

    /* もしshownTravelがnullならGManagerは取らない */
    /* ここ関数化したほうが良いかもな、、 */
    if (_shownTravelBasic == null) {
      _gManager = null;
      _isGManager = false;
      return ResultInfo.success(
        message: "No shownTravel is set. No GManager data loaded.",
      );
    } else if (_shownTravelBasic!.groupId == null ||
        _shownTravelBasic!.travelId == null) {
      print(
        "groupId or travelId is null, so no GManager data loaded. Something wrong in the app.",
      );
      _gManager = null;
      _isGManager = false;
      return ResultInfo.failed(
        error: ErrorInfo(
          errorCode: "invalid-data",
          errorMessage:
              "groupId or travelId is null, so no GManager data loaded. Something wrong in the app.",
        ),
      );
    } else {
      /* Do nothing */
    }

    final gManagerRet = await _loadGManagerId(
      _shownTravelBasic!.groupId!,
      _shownTravelBasic!.travelId!,
    );

    if (!gManagerRet.isSuccess) {
      print("Failed to load GManager data. ${gManagerRet.error?.errorMessage}");
      return gManagerRet;
    }

    if (_gManager != null && _gManager!.uid == _currentUserId) {
      _isGManager = true;
    } else {
      _isGManager = false;
    }
    return ResultInfo.success();
  }
}
