import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository_fake.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository_firebase.dart';
import 'package:my_travel_app/data/repositories/balance_info/balance_info_repository.dart';
import 'package:my_travel_app/data/repositories/balance_info/balance_info_repository_fake.dart';
import 'package:my_travel_app/data/repositories/balance_info/balance_info_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/email_auth/email_auth_repository.dart';
import 'package:my_travel_app/data/repositories/email_auth/email_auth_repository_fake.dart';
import 'package:my_travel_app/data/repositories/email_auth/email_auth_repository_firebase.dart';
import 'package:my_travel_app/data/repositories/estimated_expense/estimated_expense_repository.dart';
import 'package:my_travel_app/data/repositories/estimated_expense/estimated_expense_repository_fake.dart';
import 'package:my_travel_app/data/repositories/estimated_expense/estimated_expense_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository_fake.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/general_manager/general_manager_repository.dart';
import 'package:my_travel_app/data/repositories/general_manager/general_manager_repository_fake.dart';
import 'package:my_travel_app/data/repositories/general_manager/general_manager_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/google_auth/google_auth_repository.dart';
import 'package:my_travel_app/data/repositories/google_auth/google_auth_repository_fake.dart';
import 'package:my_travel_app/data/repositories/google_auth/google_auth_repository_firebase.dart';
import 'package:my_travel_app/data/repositories/group_creator/group_creator_repository.dart';
import 'package:my_travel_app/data/repositories/group_creator/group_creator_repository_fake.dart';
import 'package:my_travel_app/data/repositories/group_creator/group_creator_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository_fake.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/groups/groups_repository.dart';
import 'package:my_travel_app/data/repositories/groups/groups_repository_fake.dart';
import 'package:my_travel_app/data/repositories/groups/groups_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/itinerary/itinerary_repository.dart';
import 'package:my_travel_app/data/repositories/itinerary/itinerary_repository_fake.dart';
import 'package:my_travel_app/data/repositories/itinerary/itinerary_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/joined_groups/joined_groups_repository.dart';
import 'package:my_travel_app/data/repositories/joined_groups/joined_groups_repository_fake.dart';
import 'package:my_travel_app/data/repositories/joined_groups/joined_groups_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/money_exchange/money_exchange_repository.dart';
import 'package:my_travel_app/data/repositories/money_exchange/money_exchange_repository_fake.dart';
import 'package:my_travel_app/data/repositories/money_exchange/money_exchange_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/participants/participants_repository.dart';
import 'package:my_travel_app/data/repositories/participants/participants_repository_fake.dart';
import 'package:my_travel_app/data/repositories/participants/participants_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/planners/planners_repository.dart';
import 'package:my_travel_app/data/repositories/planners/planners_repository_fake.dart';
import 'package:my_travel_app/data/repositories/planners/planners_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/travel/travel_repository.dart';
import 'package:my_travel_app/data/repositories/travel/travel_repository_fake.dart';
import 'package:my_travel_app/data/repositories/travel/travel_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/travel_keys/travel_keys_repository.dart';
import 'package:my_travel_app/data/repositories/travel_keys/travel_keys_repository_fake.dart';
import 'package:my_travel_app/data/repositories/travel_keys/travel_keys_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository_fake.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/users/users_repository.dart';
import 'package:my_travel_app/data/repositories/users/users_repository_fake.dart';
import 'package:my_travel_app/data/repositories/users/users_repository_realtimedb.dart';
import 'package:my_travel_app/data/services/fake/fake_backend.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/**
 * These live throughout the app.
 * fakeを渡すとFakeモード(Firebaseを一切使わない)。nullならFirebase(エミュレータ or 本番)
 */
List<SingleChildWidget> appProviders({FakeBackend? fake}) {
  return [
    /* ログイン後のProviderでも同じFakeBackendを使うため、nullでも登録しておく */
    Provider<FakeBackend?>.value(value: fake),
    if (fake == null) ..._firebaseAppRepositories() else ..._fakeAppRepositories(fake),
    ChangeNotifierProvider(
      create: (context) =>
          AppSession(authRepository: context.read<AuthRepository>(), userSettingsRepository: context.read()),
    ),
  ];
}

/* サインアウトで死ぬインスタンス */
List<SingleChildWidget> loggedInRepositoryProviders(BuildContext context) {
  final fake = context.read<FakeBackend?>();
  if (fake == null) {
    return _firebaseLoggedInRepositories();
  }
  return _fakeLoggedInRepositories(fake);
}

List<SingleChildWidget> _firebaseAppRepositories() {
  return [
    Provider<AuthRepository>(create: (_) => AuthRepositoryFirebase()),
    Provider<EmailAuthRepository>(create: (_) => EmailAuthRepositoryFirebase()),
    Provider<GoogleAuthRepository>(create: (_) => GoogleAuthRepositoryFirebase()),
    Provider<UserSettingsRepository>(
      /* こいつだけ変だけど、AppSessionの中で使いたい、 */
      create: (innerContext) {
        print("UserSettingsRepository was created");
        return UserSettingsRepositoryRealtimeDb(database: FirebaseDatabase.instance);
      },
      dispose: (innerContext, repository) {
        print("UserSettingsRepository was disposed");
      },
      lazy: false,
    ),
  ];
}

List<SingleChildWidget> _fakeAppRepositories(FakeBackend fake) {
  return [
    Provider<AuthRepository>(create: (_) => AuthRepositoryFake(auth: fake.auth)),
    Provider<EmailAuthRepository>(
      create: (_) => EmailAuthRepositoryFake(auth: fake.auth, database: fake.database),
    ),
    Provider<GoogleAuthRepository>(
      create: (_) => GoogleAuthRepositoryFake(auth: fake.auth, database: fake.database),
    ),
    Provider<UserSettingsRepository>(
      create: (_) => UserSettingsRepositoryFake(database: fake.database),
      lazy: false,
    ),
  ];
}

List<SingleChildWidget> _firebaseLoggedInRepositories() {
  return [
    Provider<ExpenseRepository>(
      create: (innerContext) {
        print("ExpenseRepository was created");
        return ExpenseRepositoryRealtimeDb(firebaseDatabase: FirebaseDatabase.instance);
      },
      lazy: false,
      dispose: (innerContext, repository) {
        //print("ExpenseRepository was disposed");
      },
    ),
    Provider<ItineraryRepository>(
      create: (innerContext) {
        //print("ItineraryRepository was created");
        return ItineraryRepositoryRealtimeDb(firebaseDatabase: FirebaseDatabase.instance);
      },
      lazy: false,
      dispose: (innerContext, repo) {
        // print("ItineraryRepository was disposed");
      },
    ),
    Provider<GeneralManagerRepository>(
      create: (innerContext) {
        final appSession = innerContext.read<AppSession>();
        final userId = appSession.currentUser?.uid;
        if (userId == null) {
          print("Warning!!! userId is null");
          throw Exception("userId is null");
        }

        // print("GeneralManagerRepository was created");
        return GeneralManagerRepositoryRealtimeDb(
          firebaseDatabase: FirebaseDatabase.instance,
          userId: userId,
        );
      },
      lazy: false,
      dispose: (innerContext, repo) {
        // print("GeneralManagerRepository was disposed");
      },
    ),
    Provider<ParticipantsRepository>(
      create: (innerContext) {
        final appSession = innerContext.read<AppSession>();
        final userId = appSession.currentUser?.uid;
        if (userId == null) {
          print("Warning!!! userId is null");
          throw Exception("userId is null");
        }

        // print("ParticipantsRepository was created");
        return ParticipantsRepositoryRealtimeDb(firebaseDatabase: FirebaseDatabase.instance, userId: userId);
      },
      lazy: false,
      dispose: (innerContext, repo) {
        // print("ParticipantsRepository was disposed");
      },
    ),
    Provider<GroupMembersRepository>(
      create: (innerContext) {
        final appSession = innerContext.read<AppSession>();
        final userId = appSession.currentUser?.uid;

        if (userId == null) {
          print("Warning!!! userId is null");
          throw Exception("userId is null");
        }

        // print("GroupMembersRepository was created");
        return GroupMembersRepositoryRealtimeDb(firebaseDatabase: FirebaseDatabase.instance);
      },
      lazy: false,
      dispose: (innerContext, repo) {
        // print("GroupMembersRepository was disposed");
      },
    ),
    Provider<JoinedGroupsRepository>(
      create: (innerContext) => JoinedGroupsRepositoryRealtimeDb(database: FirebaseDatabase.instance),
    ),
    Provider<TravelKeysRepository>(
      create: (innerContext) => TravelKeysRepositoryRealtimedb(database: FirebaseDatabase.instance),
    ),
    Provider<TravelRepository>(
      create: (innerContext) => TravelRepositoryRealtimeDb(database: FirebaseDatabase.instance),
    ),
    Provider<PlannersRepository>(
      create: (innerContext) => PlannersRepositoryRealtimeDb(database: FirebaseDatabase.instance),
    ),
    Provider<UsersRepository>(
      create: (innerContext) => UsersRepositoryRealtimeDb(database: FirebaseDatabase.instance),
    ),
    Provider<GroupCreatorRepository>(
      create: (innerContext) => GroupCreatorRepositoryRealtimeDb(firebaseDatabase: FirebaseDatabase.instance),
    ),
    Provider<GroupsRepository>(
      create: (innerContext) => GroupsRepositoryRealtimeDb(database: FirebaseDatabase.instance),
    ),
    Provider<MoneyExchangeRepository>(
      create: (innerContext) => MoneyExchangeRepositoryRealtimeDb(database: FirebaseDatabase.instance),
    ),
    Provider<BalanceInfoRepository>(
      create: (innerContext) => BalanceInfoRepositoryRealtimeDb(database: FirebaseDatabase.instance),
    ),
    Provider<EstimatedExpenseRepository>(
      create: (innerContext) => EstimatedExpenseRepositoryRealtimeDb(database: FirebaseDatabase.instance),
    ),
  ];
}

List<SingleChildWidget> _fakeLoggedInRepositories(FakeBackend fake) {
  final db = fake.database;
  return [
    Provider<ExpenseRepository>(create: (_) => ExpenseRepositoryFake(database: db), lazy: false),
    Provider<ItineraryRepository>(create: (_) => ItineraryRepositoryFake(database: db), lazy: false),
    Provider<GeneralManagerRepository>(create: (_) => GeneralManagerRepositoryFake(), lazy: false),
    Provider<ParticipantsRepository>(create: (_) => ParticipantsRepositoryFake(database: db), lazy: false),
    Provider<GroupMembersRepository>(create: (_) => GroupMembersRepositoryFake(database: db), lazy: false),
    Provider<JoinedGroupsRepository>(create: (_) => JoinedGroupsRepositoryFake(database: db)),
    Provider<TravelKeysRepository>(create: (_) => TravelKeysRepositoryFake(database: db)),
    Provider<TravelRepository>(create: (_) => TravelRepositoryFake(database: db)),
    Provider<PlannersRepository>(create: (_) => PlannersRepositoryFake(database: db)),
    Provider<UsersRepository>(create: (_) => UsersRepositoryFake(database: db)),
    Provider<GroupCreatorRepository>(create: (_) => GroupCreatorRepositoryFake(database: db)),
    Provider<GroupsRepository>(create: (_) => GroupsRepositoryFake(database: db)),
    Provider<MoneyExchangeRepository>(create: (_) => MoneyExchangeRepositoryFake(database: db)),
    Provider<BalanceInfoRepository>(create: (_) => BalanceInfoRepositoryFake(database: db)),
    Provider<EstimatedExpenseRepository>(create: (_) => EstimatedExpenseRepositoryFake(database: db)),
  ];
}
