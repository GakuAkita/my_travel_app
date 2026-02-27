import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/data/repositories/general_manager/general_manager_repository.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository.dart';
import 'package:my_travel_app/data/repositories/itinerary/itinerary_repository.dart';
import 'package:my_travel_app/data/repositories/participants/participants_repository.dart';
import 'package:my_travel_app/data/repositories/shown_travel/shown_travel_repository.dart';
import 'package:my_travel_app/data/repositories/shown_travel/shown_travel_repository_realtimedb.dart';
import 'package:my_travel_app/routing/routes.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/state/session/user_session.dart';
import 'package:my_travel_app/ui/main/Expenses/main/view_models/expenses_viewmodel.dart';
import 'package:my_travel_app/ui/main/Expenses/main/widgets/expenses_screen.dart';
import 'package:my_travel_app/ui/main/Settings/SettingScreen.dart';
import 'package:my_travel_app/ui/main/Settings/main/view_models/settings_viewmodel.dart';
import 'package:my_travel_app/ui/main/itinerary/main/view_models/itinerary_viewmodel.dart';
import 'package:my_travel_app/ui/main/itinerary/main/widgets/itinerary_screen.dart';
import 'package:my_travel_app/ui/start/sign_in/view_models/sign_in_viewmodel.dart';
import 'package:my_travel_app/ui/start/sign_up/widgets/sign_up_screen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/expenses/expense_repository_realtimedb.dart';
import '../data/repositories/general_manager/general_manager_repository_realtimedb.dart';
import '../data/repositories/group_members/group_members_repository_realtimedb.dart';
import '../data/repositories/itinerary/itinerary_repository_realtimedb.dart';
import '../data/repositories/participants/participants_repository_realtimedb.dart';
import '../ui/main/app_navigation_bar.dart';
import '../ui/start/sign_in/widgets/sign_in_screen.dart';
import '../ui/start/start/widgets/start_screen.dart';
import '../ui/travel_scope_viewmodels.dart';

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
                    builder: (context, state) {
                      final travel =
                          context.watch<ShownTravelSession>().currentTravel;
                      final travelId = travel?.travelId;
                      /* ValueKeyにtravelIdを渡して、travelIdが変わればViewModelとUIごと再生成。 */
                      return ChangeNotifierProvider(
                        key: ValueKey(travelId),
                        create:
                            (innerContext) => ItineraryViewModel(
                              itineraryRepository: innerContext.read(),
                              travel: travel,
                            ),
                        child: ItineraryScreen(),
                        lazy: false,
                      );
                    },
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
                                authRepository: context.read(),
                              ),
                          child: SettingScreen(),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/* サインアウトで死ぬインスタンス */
List<SingleChildWidget> buildLoggedInProviders(BuildContext context) {
  return [
    Provider(
      create: (innerContext) {
        final appSession = innerContext.read<AppSession>();
        return UserSession(appUser: appSession.currentUser!);
      },
    ),
    Provider<ShownTravelRepository>(
      create: (innerContext) {
        final appSession = innerContext.read<AppSession>();
        final userId = appSession.currentUser?.uid;
        if (userId == null) {
          print("Warning!!! userId is null");
          throw Exception("userId is null");
        }
        print("ShownTravelRepository was created");
        return ShownTravelRepositoryRealtimeDb(
          firebaseDatabase: innerContext.read<FirebaseDatabase>(),
          userId: userId,
        );
      },
      lazy: false,
      dispose: (innerContext, repository) {
        print("ShownTravelRepository was disposed");
      },
    ),
    Provider<ExpenseRepository>(
      create: (innerContext) {
        final appSession = innerContext.read<AppSession>();
        final userId = appSession.currentUser?.uid;
        if (userId == null) {
          print("Warning!!! userId is null");
          throw Exception("userId is null");
        }

        print("ExpenseRepository was created");
        return ExpenseRepositoryRealtimeDb(
          firebaseDatabase: innerContext.read<FirebaseDatabase>(),
        );
      },
      lazy: false,
      dispose: (innerContext, repository) {
        print("ExpenseRepository was disposed");
      },
    ),
    Provider<ItineraryRepository>(
      create: (innerContext) {
        final appSession = innerContext.read<AppSession>();
        final userId = appSession.currentUser?.uid;
        if (userId == null) {
          print("Warning!!! userId is null");
          throw Exception("userId is null");
        }

        print("ItineraryRepository was created");
        return ItineraryRepositoryRealtimeDb(
          firebaseDatabase: innerContext.read<FirebaseDatabase>(),
          userId: userId,
        );
      },
      lazy: false,
      dispose: (innerContext, repo) {
        print("ItineraryRepository was disposed");
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

        print("GeneralManagerRepository was created");
        return GeneralManagerRepositoryRealtimeDb(
          firebaseDatabase: innerContext.read<FirebaseDatabase>(),
          userId: userId,
        );
      },
      lazy: false,
      dispose: (innerContext, repo) {
        print("GeneralManagerRepository was disposed");
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

        print("ParticipantsRepository was created");
        return ParticipantsRepositoryRealtimeDb(
          firebaseDatabase: innerContext.read<FirebaseDatabase>(),
          userId: userId,
        );
      },
      lazy: false,
      dispose: (innerContext, repo) {
        print("ParticipantsRepository was disposed");
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

        print("GroupMembersRepository was created");
        return GroupMembersRepositoryRealtimeDb(
          firebaseDatabase: innerContext.read<FirebaseDatabase>(),
          userId: userId,
        );
      },
      lazy: false,
      dispose: (innerContext, repo) {
        print("GroupMembersRepository was disposed");
      },
    ),
    ChangeNotifierProvider(
      create: (innerContext) {
        final session = ShownTravelSession();
        print("call initialize for ShownTravelSession");
        /* 最初はここでinitする必要がある */
        session.initialize(innerContext.read<ShownTravelRepository>());
        return session;
      },
      lazy: false,
    ),
    ChangeNotifierProxyProvider<ShownTravelSession, TravelScopeViewModel>(
      create: /* createはほとんど機能しない。すぐ生成しだすから。 */
          (_) => TravelScopeViewModel(travel: null),
      update: (innerContext, session, previous) {
        /* 旅行が切り替わったらTravelScopeViewModelが再生成される */
        final travel = session.currentTravel;
        if (previous?.travel?.travelId == travel?.travelId) {
          //print("travel didn't change. Don't generate TravelScopeViewModel");
          return previous!;
        }
        previous?.dispose();
        return TravelScopeViewModel(travel: travel);
      },
    ),
    ChangeNotifierProxyProvider<ShownTravelSession, ItineraryViewModel>(
      create:
          (innerContext) => ItineraryViewModel(
            itineraryRepository: innerContext.read(),
            travel: null,
          ),
      update: (innerContext, session, previous) {
        final travel = session.currentTravel;
        if (previous?.travel?.travelId == travel?.travelId) {
          //print("travel didn't change. don't generate ItineraryViewModel");
          return previous!;
        }

        return ItineraryViewModel(
          itineraryRepository: innerContext.read(),
          travel: travel,
        );
      },
      lazy: false,
    ),
    ChangeNotifierProxyProvider<ShownTravelSession, ExpensesViewModel>(
      create:
          (innerContext) => ExpensesViewModel(
            expenseRepository: innerContext.read(),
            groupMembersRepository: innerContext.read(),
            travel: null,
          ),
      update: (innerContext, session, previous) {
        final travel = session.currentTravel;
        if (previous?.travel?.travelId == travel?.travelId) {
          //print("travel didn't change. don't generate ExpensesViewModel");
          return previous!;
        }
        return ExpensesViewModel(
          expenseRepository: innerContext.read(),
          groupMembersRepository: innerContext.read(),
          travel: travel,
        );
      },
      lazy: false,
    ),
  ];
}
