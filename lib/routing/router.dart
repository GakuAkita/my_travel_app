import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/data/repositories/general_manager/general_manager_repository.dart';
import 'package:my_travel_app/data/repositories/group_creator/group_creator_repository.dart';
import 'package:my_travel_app/data/repositories/group_creator/group_creator_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository.dart';
import 'package:my_travel_app/data/repositories/groups/groups_repository.dart';
import 'package:my_travel_app/data/repositories/groups/groups_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/itinerary/itinerary_repository.dart';
import 'package:my_travel_app/data/repositories/joined_groups/joined_groups_repository.dart';
import 'package:my_travel_app/data/repositories/joined_groups/joined_groups_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/participants/participants_repository.dart';
import 'package:my_travel_app/data/repositories/planners/planners_repository.dart';
import 'package:my_travel_app/data/repositories/planners/planners_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/travel/travel_repository.dart';
import 'package:my_travel_app/data/repositories/travel/travel_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/travel_keys/travel_keys_repository.dart';
import 'package:my_travel_app/data/repositories/travel_keys/travel_keys_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository_realtimedb.dart';
import 'package:my_travel_app/data/repositories/users/users_repository.dart';
import 'package:my_travel_app/data/repositories/users/users_repository_realtimedb.dart';
import 'package:my_travel_app/domain/use_cases/crud_group_use_case.dart';
import 'package:my_travel_app/domain/use_cases/get_user_travels_use_case.dart';
import 'package:my_travel_app/routing/routes.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/expense_store.dart';
import 'package:my_travel_app/ui/core/store/itinerary_store.dart';
import 'package:my_travel_app/ui/main/Expenses/main/view_models/expenses_viewmodel.dart';
import 'package:my_travel_app/ui/main/Expenses/main/widgets/expenses_screen.dart';
import 'package:my_travel_app/ui/main/Settings/main/view_models/settings_viewmodel.dart';
import 'package:my_travel_app/ui/main/expenses/add_edit/view_models/add_edit_expense_viewmodel.dart';
import 'package:my_travel_app/ui/main/expenses/add_edit/widgets/add_edit_expenses_screen.dart';
import 'package:my_travel_app/ui/main/itinerary/main/view_models/itinerary_viewmodel.dart';
import 'package:my_travel_app/ui/main/itinerary/main/widgets/itinerary_screen.dart';
import 'package:my_travel_app/ui/main/settings/group_create/view_models/group_create_viewmodel.dart';
import 'package:my_travel_app/ui/main/settings/group_create/widgets/group_create_screen.dart';
import 'package:my_travel_app/ui/main/settings/main/widgets/settings_screen.dart';
import 'package:my_travel_app/ui/main/settings/software_version/widgets/version_info_screen.dart';
import 'package:my_travel_app/ui/main/settings/travel_select/view_models/travle_select_viewmodel.dart';
import 'package:my_travel_app/ui/main/settings/travel_select/widgets/travel_select_screen.dart';
import 'package:my_travel_app/ui/start/sign_in/view_models/sign_in_viewmodel.dart';
import 'package:my_travel_app/ui/start/sign_up/widgets/sign_up_screen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/expenses/expense_repository_realtimedb.dart';
import '../data/repositories/general_manager/general_manager_repository_realtimedb.dart';
import '../data/repositories/group_members/group_members_repository_realtimedb.dart';
import '../data/repositories/itinerary/itinerary_repository_realtimedb.dart';
import '../data/repositories/participants/participants_repository_realtimedb.dart';
import '../ui/core/store/travel_scope_store.dart';
import '../ui/main/app_navigation_bar.dart';
import '../ui/start/sign_in/widgets/sign_in_screen.dart';
import '../ui/start/start/widgets/start_screen.dart';

final rootNavigationKey = GlobalKey<NavigatorState>();
final itineraryNavigatorKey = GlobalKey<NavigatorState>();
final expensesNavigatorKey = GlobalKey<NavigatorState>();
final settingsNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AppSession session) {
  print("--------- createRouter was called-----------");
  return GoRouter(
    navigatorKey: rootNavigationKey,
    refreshListenable: session,
    initialLocation: Routes.start,
    redirect: (context, state) {
      final loggedIn = session.isLoggedIn;
      final isPublicRoute = Routes.publicRoutes.contains(state.matchedLocation);

      if (!loggedIn && !isPublicRoute) {
        print("Redirecting to start screen.");
        return Routes.start;
      }

      if (loggedIn && isPublicRoute) {
        print("Redirecting to itinerary screen.");
        return Routes.itinerary;
      }

      //print("Nothing to redirect.");
      return null;
    },
    routes: [
      GoRoute(path: Routes.start, builder: (context, state) => StartScreen()),
      GoRoute(
        path: Routes.signUp,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (innerContext) => SignInViewModel(
                    authRepository: innerContext.read<AuthRepository>(),
                  ),
              child: SignUpScreen(),
            ),
      ),
      GoRoute(
        path: Routes.signIn,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (innerContext) =>
                      SignInViewModel(authRepository: innerContext.read()),
              child: SignInScreen(),
            ),
      ),
      /* ログイン後 */
      /* サインアウトしたらShellRouteごと死ぬっぽい。それでよい。 */
      ShellRoute(
        builder: (context, state, child) {
          return MultiProvider(
            providers: buildLoggedInProviders(context),
            child: child,
          );
        },
        routes: [
          //AppNavigationBarあり
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return AppNavigationBar(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(
                navigatorKey: itineraryNavigatorKey,
                routes: [
                  GoRoute(
                    path: Routes.itinerary,
                    builder: (context, state) => ItineraryScreen(),
                  ),
                ],
              ),
              StatefulShellBranch(
                navigatorKey: expensesNavigatorKey,
                routes: [
                  GoRoute(
                    path: Routes.expenses,
                    builder: (context, state) => ExpensesScreen(),
                  ),
                ],
              ),
              StatefulShellBranch(
                navigatorKey: settingsNavigatorKey,
                routes: [
                  GoRoute(
                    path: Routes.settings,
                    builder:
                        (context, state) => ChangeNotifierProvider(
                          create:
                              (innerContext) => SettingsViewModel(
                                authRepository: innerContext.read(),
                                userSettingsRepository: innerContext.read(),
                                appSession: innerContext.read(),
                              ),
                          child: SettingsScreen(),
                        ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: Routes.expenses_add_edit,
            builder: (context, state) {
              final expenseId = state.extra as String?;
              return ChangeNotifierProvider(
                create:
                    (innerContext) => AddEditExpenseViewModel(
                      expenseId: expenseId,
                      expenseRepository: innerContext.read(),
                      expenseStore: innerContext.read(),
                      travelScopeStore: innerContext.read(),
                      travelSession: innerContext.read(),
                      appSession: innerContext.read(),
                    ),
                child: AddEditExpenseScreen(),
              );
            },
          ),
          GoRoute(
            path: Routes.settings_travel_select,
            builder: (context, state) {
              /* Adminかどうかを引数で渡しておく */

              return ChangeNotifierProvider(
                create:
                    (innerContext) => TravelSelectViewModel(
                      appSession: innerContext.read(),
                      travelSession: innerContext.read(),
                      getUserTravelsUseCase: innerContext.read(),
                      userSettingsRepository: innerContext.read(),
                    ),
                child: TravelSelectScreen(),
              );
            },
          ),
          GoRoute(
            path: Routes.settings_version_info,
            builder: (context, state) => VersionInfoScreen(),
          ),
          GoRoute(
            path: Routes.settings_create_group,
            builder:
                (context, state) => ChangeNotifierProvider(
                  create:
                      (innerContext) => GroupCreateViewModel(
                        appSession: innerContext.read(),
                        usersRepository: innerContext.read(),
                        crudGroupUseCase: innerContext.read(),
                      ),
                  child: GroupCreateScreen(),
                ),
          ),
        ],
      ),
    ],
  );
}

/* サインアウトで死ぬインスタンス */
List<SingleChildWidget> buildLoggedInProviders(BuildContext context) {
  return [
    Provider<UserSettingsRepository>(
      create: (innerContext) {
        print("UserSettingsRepository was created");
        return UserSettingsRepositoryRealtimeDb(
          database: FirebaseDatabase.instance,
        );
      },
      dispose: (innerContext, repository) {
        print("UserSettingsRepository was disposed");
      },
      lazy: false,
    ),

    Provider<ExpenseRepository>(
      create: (innerContext) {
        print("ExpenseRepository was created");
        return ExpenseRepositoryRealtimeDb(
          firebaseDatabase: FirebaseDatabase.instance,
        );
      },
      lazy: false,
      dispose: (innerContext, repository) {
        //print("ExpenseRepository was disposed");
      },
    ),
    Provider<ItineraryRepository>(
      create: (innerContext) {
        //print("ItineraryRepository was created");
        return ItineraryRepositoryRealtimeDb(
          firebaseDatabase: FirebaseDatabase.instance,
        );
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
        return ParticipantsRepositoryRealtimeDb(
          firebaseDatabase: FirebaseDatabase.instance,
          userId: userId,
        );
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
        return GroupMembersRepositoryRealtimeDb(
          firebaseDatabase: FirebaseDatabase.instance,
        );
      },
      lazy: false,
      dispose: (innerContext, repo) {
        // print("GroupMembersRepository was disposed");
      },
    ),
    Provider<JoinedGroupsRepository>(
      create:
          (innerContext) => JoinedGroupsRepositoryRealtimeDb(
            database: FirebaseDatabase.instance,
          ),
    ),
    Provider<TravelKeysRepository>(
      create:
          (innerContext) => TravelKeysRepositoryRealtimedb(
            database: FirebaseDatabase.instance,
          ),
    ),
    Provider<TravelRepository>(
      create:
          (innerContext) =>
              TravelRepositoryRealtimeDb(database: FirebaseDatabase.instance),
    ),
    Provider<PlannersRepository>(
      create: (innerContext) => PlannersRepositoryRealtimeDb(),
    ),
    Provider<UsersRepository>(
      create:
          (innerContext) =>
              UsersRepositoryRealtimeDb(database: FirebaseDatabase.instance),
    ),
    Provider<GroupCreatorRepository>(
      create:
          (innerContext) => GroupCreatorRepositoryRealtimeDb(
            firebaseDatabase: FirebaseDatabase.instance,
          ),
    ),
    Provider<GroupsRepository>(
      create:
          (innerContext) =>
              GroupsRepositoryRealtimeDb(database: FirebaseDatabase.instance),
    ),

    /// UserCases
    Provider<GetUserTravelsUseCase>(
      create:
          (innerContext) => GetUserTravelsUseCase(
            travelKeysRepository: innerContext.read(),
            joinedGroupsRepository: innerContext.read(),
            travelRepository: innerContext.read(),
          ),
    ),
    Provider<CrudGroupUseCase>(
      create:
          (innerContext) => CrudGroupUseCase(
            groupCreatorRepository: innerContext.read(),
            groupMembersRepository: innerContext.read(),
            joinedGroupsRepository: innerContext.read(),
            groupsRepository: innerContext.read(),
            travelKeyRepository: innerContext.read(),
          ),
    ),
    ChangeNotifierProvider(
      create: (innerContext) {
        final appSession = innerContext.read<AppSession>();
        if (appSession.currentUser?.uid == null) {
          throw Exception("userId is null");
        }
        final session = ShownTravelSession();
        // print("call initialize for ShownTravelSession");
        /* 最初はここでinitする必要がある */
        session.initialize(
          appSession.currentUser!.uid,
          innerContext.read<UserSettingsRepository>(),
        );
        return session;
      },
      lazy: false,
    ),
    ChangeNotifierProvider<TravelScopeStore>(
      create: /* createはほとんど機能しない。すぐ生成しだすから。 */
          (innerContext) => TravelScopeStore(
            session: innerContext.read<ShownTravelSession>(),
            groupMembersRepository: innerContext.read(),
            participantsRepository: innerContext.read(),
            userSettingsRepository: innerContext.read(),
            plannersRepository: innerContext.read(),
          ),
      lazy: false,
    ),
    ChangeNotifierProvider<ExpenseStore>(
      create:
          /// 参照渡しっぽいので、Store内でtravelSessionを参照すれば最新のtravelSessionになる
          (innerContext) => ExpenseStore(
            expenseRepository: innerContext.read(),
            travelSession: innerContext.read(),
          ),
      lazy: false,
    ),
    ChangeNotifierProxyProvider<ShownTravelSession, ItineraryStore>(
      create: (innerContext) => ItineraryStore(),
      update: (innerContext, session, previous) {
        return previous!;
      },
      lazy: false,
    ),
    ChangeNotifierProvider(
      create:
          (innerContext) => ItineraryViewModel(
            itineraryRepository: innerContext.read(),
            travelSession: innerContext.read(),
          ),
      lazy: false,
    ),
    ChangeNotifierProvider(
      create:
          (innerContext) => ExpensesViewModel(
            expenseStore: innerContext.read(),
            travelScopeStore: innerContext.read(),
            travelSession: innerContext.read(),
          ),
      lazy: false,
    ),
  ];
}
