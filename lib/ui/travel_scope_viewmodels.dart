import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/data/repositories/general_manager/general_manager_repository.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository.dart';
import 'package:my_travel_app/data/repositories/participants/participants_repository.dart';

class TravelScopeViewModel extends ChangeNotifier {
  ShownTravelBasic? _travel;

  GroupMembersRepository _groupMembersRepository;

  GeneralManagerRepository _generalManagerRepository;

  ParticipantsRepository _participantsRepository;

  ExpenseRepository _expenseRepository;

  bool _initialized = false;

  bool get initialized => _initialized;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  TravelScopeViewModel({
    required ShownTravelBasic? travel,
    required GroupMembersRepository groupMembersRepository,
    required GeneralManagerRepository generalManagerRepository,
    required ParticipantsRepository participantsRepository,
    required ExpenseRepository expenseRepository,
  }) : _groupMembersRepository = groupMembersRepository,
       _generalManagerRepository = generalManagerRepository,
       _participantsRepository = participantsRepository,
       _expenseRepository = expenseRepository,
       _travel = travel {
    print("TravelScopeViewModel was created");
  }

  /**
   *  保持しているデータ
   *  基本的に外から参照される前提
   *  */
  Map<String, TravelerBasic> _allGroupMembers = {};

  Map<String, TravelerBasic> get allGroupMembers => _allGroupMembers;

  String? _generalManager = null;

  String? get generalManager => _generalManager;

  Map<String, TravelerBasic> _participants = {};

  Map<String, TravelerBasic> get participants => _participants;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    try {
      /*
       * グループメンバーを全部取って、各個人のプロフィール名を取っていく。
       * */

      /* 参加者を取得して、グループメンバーの中から引っ張ってくる */
    } finally {
      _initialized = false;
    }
  }
}
