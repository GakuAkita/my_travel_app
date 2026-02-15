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
import 'package:my_travel_app/state/state/ExpensesState.dart';
import 'package:my_travel_app/state/state/GroupMemebersState.dart';
import 'package:my_travel_app/state/state/TravlersState.dart';
import 'package:my_travel_app/ui/main/Expenses/main/view_models/expenses_viewmodel.dart';
import 'package:my_travel_app/ui/main/Expenses/main/widgets/ExpensesScreen.dart';
import 'package:my_travel_app/ui/main/Settings/SettingScreen.dart';
import 'package:my_travel_app/ui/main/Settings/main/view_models/settings_viewmodel.dart';
import 'package:my_travel_app/ui/main/itinerary/ItineraryScreen.dart';
import 'package:my_travel_app/ui/start/sign_in/view_models/sign_in_viewmodel.dart';
import 'package:my_travel_app/ui/start/sign_up/widgets/sign_up_screen.dart';
import 'package:provider/provider.dart';

import '../data/repositories/expenses/expense_repository_realtimedb.dart';
import '../data/repositories/general_manager/general_manager_repository_realtimedb.dart';
import '../data/repositories/group_members/group_members_repository_realtimedb.dart';
import '../data/repositories/itinerary/itinerary_repository_realtimedb.dart';
import '../data/repositories/participants/participants_repository_realtimedb.dart';
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
      ShellRoute(
        builder: (context, state, child) {
          return MultiProvider(
            providers: [
              Provider<ShownTravelRepository>(
                create: (innerContext) {
                  final appSession = innerContext.read<AppSession>();
                  final userId = appSession.currentUser?.uid;
                  if (userId == null) {
                    print("Warning!!! userId is null");
                    throw Exception("userId is null");
                  }
                  print("uid:${userId}");

                  return ShownTravelRepositoryRealtimeDb(
                    firebaseDatabase: innerContext.read<FirebaseDatabase>(),
                    userId: userId,
                  );
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
                  print("uid:${userId}");

                  return ExpenseRepositoryRealtimeDb(
                    firebaseDatabase: innerContext.read<FirebaseDatabase>(),
                    userId: userId,
                  );
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
                  print("uid:${userId}");

                  return ItineraryRepositoryRealtimeDb(
                    firebaseDatabase: innerContext.read<FirebaseDatabase>(),
                    userId: userId,
                  );
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
                  print("uid:${userId}");

                  return GeneralManagerRepositoryRealtimeDb(
                    firebaseDatabase: innerContext.read<FirebaseDatabase>(),
                    userId: userId,
                  );
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
                  print("uid:${userId}");

                  return ParticipantsRepositoryRealtimeDb(
                    firebaseDatabase: innerContext.read<FirebaseDatabase>(),
                    userId: userId,
                  );
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
                  print("uid:${userId}");
                  return GroupMembersRepositoryRealtimeDb(
                    firebaseDatabase: innerContext.read<FirebaseDatabase>(),
                    userId: userId,
                  );
                },
              ),
              ChangeNotifierProvider(
                create:
                    (innerContext) => ShownTravelSession(
                      shownTravelRepository:
                          innerContext.read<ShownTravelRepository>(),
                    ),
              ),
              ChangeNotifierProvider(
                create:
                    (innerContext) => ExpensesState(
                      travelSession: innerContext.read(),
                      expensesRepository: innerContext.read(),
                    ),
              ),
              ChangeNotifierProvider(
                create:
                    (innerContext) => GroupMembersState(
                      travelSession: innerContext.read(),
                      groupMembersRepository: innerContext.read(),
                    ),
              ),
              ChangeNotifierProvider(
                create:
                    (innerContext) => TravelersState(
                      travelSession: innerContext.read(),
                      participantsRepository: innerContext.read(),
                    ),
              ),
            ],
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
                    builder:
                        (context, state) => ChangeNotifierProvider(
                          create:
                              (innerContext) => ExpensesViewModel(
                                expenseRepository:
                                    innerContext.read<ExpenseRepository>(),
                                travelSession:
                                    innerContext.read<ShownTravelSession>(),
                                expensesState:
                                    innerContext.read<ExpensesState>(),
                              ),
                          child: ExpensesScreen(),
                        ),
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

/**
 * ログインしていないときのルート
 * ログインした後のルートと分けないと、ShellRouteがログアウト後にうまく死んでくれねい
 */
List<RouteBase> publicRoutes() => [
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
];

/**
 * もしかしてこんなことしなくてよい？
 * 普通にroutesに並べてもインスタンスが死んでくれるかも、、
 */
List<RouteBase> loggedInRoutes(AppSession session) {
  final itineraryNavigatorKey = GlobalKey<NavigatorState>();
  final expensesNavigatorKey = GlobalKey<NavigatorState>();
  final settingsNavigatorKey = GlobalKey<NavigatorState>();

  if (!session.isLoggedIn) {
    print("------------ not logged in yet. create empty route ---------------");
    return [];
  }

  print("--------- logged in screens were created -----------");
  return [
    /* ログイン後 */
    ShellRoute(
      builder: (context, state, child) {
        return MultiProvider(
          providers: [
            Provider<ShownTravelRepository>(
              create: (innerContext) {
                final appSession = innerContext.read<AppSession>();
                final userId = appSession.currentUser?.uid;
                if (userId == null) {
                  print("Warning!!! userId is null");
                  throw Exception("userId is null");
                }
                print("uid:${userId}");

                return ShownTravelRepositoryRealtimeDb(
                  firebaseDatabase: innerContext.read<FirebaseDatabase>(),
                  userId: userId,
                );
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
                print("uid:${userId}");

                return ExpenseRepositoryRealtimeDb(
                  firebaseDatabase: innerContext.read<FirebaseDatabase>(),
                  userId: userId,
                );
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
                print("uid:${userId}");

                return ItineraryRepositoryRealtimeDb(
                  firebaseDatabase: innerContext.read<FirebaseDatabase>(),
                  userId: userId,
                );
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
                print("uid:${userId}");

                return GeneralManagerRepositoryRealtimeDb(
                  firebaseDatabase: innerContext.read<FirebaseDatabase>(),
                  userId: userId,
                );
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
                print("uid:${userId}");

                return ParticipantsRepositoryRealtimeDb(
                  firebaseDatabase: innerContext.read<FirebaseDatabase>(),
                  userId: userId,
                );
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
                print("uid:${userId}");
                return GroupMembersRepositoryRealtimeDb(
                  firebaseDatabase: innerContext.read<FirebaseDatabase>(),
                  userId: userId,
                );
              },
            ),
            ChangeNotifierProvider(
              create:
                  (innerContext) => ShownTravelSession(
                    shownTravelRepository:
                        innerContext.read<ShownTravelRepository>(),
                  ),
            ),
            ChangeNotifierProvider(
              create:
                  (innerContext) => ExpensesState(
                    travelSession: innerContext.read(),
                    expensesRepository: innerContext.read(),
                  ),
            ),
            ChangeNotifierProvider(
              create:
                  (innerContext) => GroupMembersState(
                    travelSession: innerContext.read(),
                    groupMembersRepository: innerContext.read(),
                  ),
            ),
            ChangeNotifierProvider(
              create:
                  (innerContext) => TravelersState(
                    travelSession: innerContext.read(),
                    participantsRepository: innerContext.read(),
                  ),
            ),
          ],
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
                  builder:
                      (context, state) => ChangeNotifierProvider(
                        create:
                            (innerContext) => ExpensesViewModel(
                              expenseRepository:
                                  innerContext.read<ExpenseRepository>(),
                              travelSession:
                                  innerContext.read<ShownTravelSession>(),
                              expensesState: innerContext.read<ExpensesState>(),
                            ),
                        child: ExpensesScreen(),
                      ),
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
  ];
}
