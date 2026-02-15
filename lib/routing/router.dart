import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';
import 'package:my_travel_app/data/repositories/shown_travel/shown_travel_repository.dart';
import 'package:my_travel_app/data/repositories/shown_travel/shown_travel_repository_realtimedb.dart';
import 'package:my_travel_app/routing/routes.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/main/Expenses/main/view_models/expenses_viewmodel.dart';
import 'package:my_travel_app/ui/main/Settings/SettingScreen.dart';
import 'package:my_travel_app/ui/main/Settings/main/view_models/settings_viewmodel.dart';
import 'package:my_travel_app/ui/main/itinerary/ItineraryScreen.dart';
import 'package:my_travel_app/ui/start/sign_in/view_models/sign_in_viewmodel.dart';
import 'package:my_travel_app/ui/start/sign_in/widgets/sign_in_screen.dart';
import 'package:my_travel_app/ui/start/sign_up/widgets/sign_up_screen.dart';
import 'package:provider/provider.dart';

import '../ui/main/app_navigation_bar.dart';
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

      print("Nothing to redirect.");
      return null;
    },
    routes: [
      /* ログアウト時 */
      GoRoute(path: Routes.start, builder: (context, state) => StartScreen()),
      GoRoute(
        path: Routes.signIn,
        builder:
            (context, state) => ChangeNotifierProvider(
              create:
                  (innerContext) => SignInViewModel(
                    authRepository: innerContext.read<AuthRepository>(),
                  ),
              child: SignInScreen(),
            ),
      ),
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
                    firebaseDatabase: context.read<FirebaseDatabase>(),
                    userId: userId,
                  );
                },
              ),
              ChangeNotifierProvider(
                create:
                    (_) => ShownTravelSession(
                      shownTravelRepository:
                          context.read<ShownTravelRepository>(),
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
                                expenseRepository: innerContext.read(),
                                travelSession: innerContext.read(),
                              ),
                          child: SignInScreen(),
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
