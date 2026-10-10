import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/config/dependencies.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';
import 'package:my_travel_app/domain/use_cases/crud_group_use_case.dart';
import 'package:my_travel_app/domain/use_cases/get_user_travels_use_case.dart';
import 'package:my_travel_app/routing/routes.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/expense_store.dart';
import 'package:my_travel_app/ui/core/store/itinerary_store.dart';
import 'package:my_travel_app/ui/main/expenses/add_edit/view_models/add_edit_expense_viewmodel.dart';
import 'package:my_travel_app/ui/main/expenses/add_edit/widgets/add_edit_expenses_screen.dart';
import 'package:my_travel_app/ui/main/expenses/estimated/view_models/estimated_expense_viewmodel.dart';
import 'package:my_travel_app/ui/main/expenses/estimated/widgets/estimated_expense_screen.dart';
import 'package:my_travel_app/ui/main/expenses/result/view_models/expense_result_viewmodel.dart';
import 'package:my_travel_app/ui/main/expenses/result/widgets/expense_result_screen.dart';
import 'package:my_travel_app/ui/main/itinerary/main/view_models/itinerary_viewmodel.dart';
import 'package:my_travel_app/ui/main/itinerary/table_edit/widgets/itinerary_table_edit_screen.dart';
import 'package:my_travel_app/ui/main/settings/group_create/view_models/group_create_viewmodel.dart';
import 'package:my_travel_app/ui/main/settings/group_create/widgets/group_create_screen.dart';
import 'package:my_travel_app/ui/main/settings/main/widgets/settings_screen.dart';
import 'package:my_travel_app/ui/main/settings/planner_select/view_models/planner_select_viewmodel.dart';
import 'package:my_travel_app/ui/main/settings/planner_select/widgets/planner_select_screen.dart';
import 'package:my_travel_app/ui/main/settings/profile/view_models/profile_viewmodel.dart';
import 'package:my_travel_app/ui/main/settings/profile/widgets/profile_screen.dart';
import 'package:my_travel_app/ui/main/settings/software_version/widgets/version_info_screen.dart';
import 'package:my_travel_app/ui/main/settings/travel_create/view_models/travel_create_viewmodel.dart';
import 'package:my_travel_app/ui/main/settings/travel_select/view_models/travle_select_viewmodel.dart';
import 'package:my_travel_app/ui/main/settings/travel_select/widgets/travel_select_screen.dart';
import 'package:my_travel_app/ui/start/reset_pass/view_models/reset_password_viewmodel.dart';
import 'package:my_travel_app/ui/start/reset_pass/widgets/reset_password_screen.dart';
import 'package:my_travel_app/ui/start/sign_in/view_models/sign_in_viewmodel.dart';
import 'package:my_travel_app/ui/start/sign_up/widgets/sign_up_screen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../ui/core/store/travel_scope_store.dart';
import '../ui/main/app_navigation_bar.dart';
import '../ui/main/expenses/main/view_models/expenses_viewmodel.dart';
import '../ui/main/expenses/main/widgets/expenses_screen.dart';
import '../ui/main/itinerary/main/widgets/itinerary_screen.dart';
import '../ui/main/settings/main/view_models/settings_viewmodel.dart';
import '../ui/main/settings/travel_create/widgets/travel_create_screen.dart';
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
        path: Routes.sign_up,
        builder: (context, state) => ChangeNotifierProvider(
          create: (innerContext) => SignInViewModel(
            emailAuthRepository: innerContext.read(),
            googleAuthRepository: innerContext.read(),
          ),
          child: SignUpScreen(),
        ),
      ),
      GoRoute(
        path: Routes.sign_in,
        builder: (context, state) => ChangeNotifierProvider(
          create: (innerContext) => SignInViewModel(
            emailAuthRepository: innerContext.read(),
            googleAuthRepository: innerContext.read(),
          ),
          child: SignInScreen(),
        ),
      ),
      GoRoute(
        path: Routes.reset_password,
        builder: (context, state) {
          final String email = state.extra as String? ?? "";
          return ChangeNotifierProvider(
            create: (innerContext) => ResetPasswordViewModel(emailAuthRepository: innerContext.read()),
            child: ResetPasswordScreen(initialEmail: email),
          );
        },
      ),
      /* ログイン後 */
      /* サインアウトしたらShellRouteごと死ぬっぽい。それでよい。 */
      ShellRoute(
        builder: (context, state, child) {
          return MultiProvider(providers: buildLoggedInProviders(context), child: child);
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
                routes: [GoRoute(path: Routes.itinerary, builder: (context, state) => ItineraryScreen())],
              ),
              StatefulShellBranch(
                navigatorKey: expensesNavigatorKey,
                routes: [GoRoute(path: Routes.expenses, builder: (context, state) => ExpensesScreen())],
              ),
              StatefulShellBranch(
                navigatorKey: settingsNavigatorKey,
                routes: [
                  GoRoute(
                    path: Routes.settings,
                    builder: (context, state) => ChangeNotifierProvider(
                      create: (innerContext) => SettingsViewModel(
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
            path: Routes.itinerary_table_edit,
            builder: (context, state) {
              final sectionId = state.extra as String? ?? "";
              return ItineraryTableEditScreen(sectionId: sectionId);
            },
          ),
          GoRoute(
            path: Routes.expenses_add_edit,
            builder: (context, state) {
              final expenseId = state.extra as String?;
              return ChangeNotifierProvider(
                create: (innerContext) => AddEditExpenseViewModel(
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
            path: Routes.expenses_result,
            builder: (context, state) {
              return ChangeNotifierProvider(
                create: (innerContext) => ExpenseResultViewModel(
                  expenseStore: innerContext.read(),
                  travelScopeStore: innerContext.read(),
                  session: innerContext.read(),
                  moneyExchangeRepository: innerContext.read(),
                  balanceInfoRepository: innerContext.read(),
                ),
                child: ExpenseResultScreen(),
              );
            },
          ),
          GoRoute(
            path: Routes.estimated_expense,
            builder: (context, state) {
              return ChangeNotifierProvider(
                create: (innerContext) => EstimatedExpenseViewModel(
                  travelSession: innerContext.read(),
                  itineraryStore: innerContext.read(),
                  travelScopeStore: innerContext.read(),
                  estimatedExpenseRepository: innerContext.read(),
                ),
                child: EstimatedExpenseScreen(),
              );
            },
          ),
          GoRoute(
            path: Routes.settings_travel_select,
            builder: (context, state) {
              final role = state.extra as String?;
              /* Adminかどうかを引数で渡しておく */

              return ChangeNotifierProvider(
                create: (innerContext) => TravelSelectViewModel(
                  appSession: innerContext.read(),
                  travelSession: innerContext.read(),
                  itineraryStore: innerContext.read(),
                  getUserTravelsUseCase: innerContext.read(),
                  userSettingsRepository: innerContext.read(),
                  groupMembersRepository: innerContext.read(),
                  participantsRepository: innerContext.read(),
                  userRole: role,
                ),
                child: TravelSelectScreen(userRole: role),
              );
            },
          ),
          GoRoute(path: Routes.settings_version_info, builder: (context, state) => VersionInfoScreen()),
          GoRoute(
            path: Routes.settings_create_group,
            builder: (context, state) => ChangeNotifierProvider(
              create: (innerContext) => GroupCreateViewModel(
                appSession: innerContext.read(),
                usersRepository: innerContext.read(),
                crudGroupUseCase: innerContext.read(),
                joinedGroupRepository: innerContext.read(),
              ),
              child: GroupCreateScreen(),
            ),
          ),
          GoRoute(
            path: Routes.settings_create_travel,
            builder: (context, state) => ChangeNotifierProvider(
              create: (innerContext) => TravelCreateViewModel(
                appSession: innerContext.read(),
                travelRepository: innerContext.read(),
                travelKeysRepository: innerContext.read(),
                joinedGroupsRepository: innerContext.read(),
                getUserTravelsUseCase: innerContext.read(),
              ),
              child: TravelCreateScreen(),
            ),
          ),
          GoRoute(
            path: Routes.settings_profile,
            builder: (context, state) => ChangeNotifierProvider(
              create: (innerContext) => ProfileViewModel(
                appSession: innerContext.read(),
                userSettingsRepository: innerContext.read(),
              ),
              child: ProfileScreen(),
            ),
          ),
          GoRoute(
            path: Routes.settings_planners,
            builder: (context, state) => ChangeNotifierProvider(
              create: (innerContext) => PlannerSelectViewModel(
                travelSession: innerContext.read(),
                travelScopeStore: innerContext.read(),
                plannersRepository: innerContext.read(),
              ),
              child: PlannerSelectScreen(),
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
    ...loggedInRepositoryProviders(context),

    /// UserCases
    Provider<GetUserTravelsUseCase>(
      create: (innerContext) => GetUserTravelsUseCase(
        travelKeysRepository: innerContext.read(),
        joinedGroupsRepository: innerContext.read(),
        travelRepository: innerContext.read(),
      ),
    ),
    Provider<CrudGroupUseCase>(
      create: (innerContext) => CrudGroupUseCase(
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
        session.initialize(appSession.currentUser!.uid, innerContext.read<UserSettingsRepository>());
        return session;
      },
      lazy: false,
    ),
    ChangeNotifierProvider<TravelScopeStore>(
      create: /* createはほとんど機能しない。すぐ生成しだすから。 */ (innerContext) => TravelScopeStore(
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
          (innerContext) =>
              ExpenseStore(expenseRepository: innerContext.read(), travelSession: innerContext.read()),
      lazy: false,
    ),
    ChangeNotifierProvider<ItineraryStore>(
      create: (innerContext) =>
          ItineraryStore(itineraryRepository: innerContext.read(), travelSession: innerContext.read()),
      lazy: false,
    ),
    ChangeNotifierProvider(
      create: (innerContext) => ItineraryViewModel(
        itineraryRepository: innerContext.read(),
        userSettingsRepository: innerContext.read(),
        itineraryStore: innerContext.read(),
        travelScopeStore: innerContext.read(),
        travelSession: innerContext.read(),
        appSession: innerContext.read(),
      ),
      lazy: false,
    ),
    ChangeNotifierProvider(
      create: (innerContext) => ExpensesViewModel(
        expenseStore: innerContext.read(),
        travelScopeStore: innerContext.read(),
        travelSession: innerContext.read(),
      ),
      lazy: false,
    ),
  ];
}
