import 'package:go_router/go_router.dart';
import 'package:my_travel_app/app_session.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';
import 'package:my_travel_app/routing/routes.dart';
import 'package:my_travel_app/ui/start/sign_in/view_models/sign_in_viewmodel.dart';
import 'package:my_travel_app/ui/start/sign_in/widgets/sign_in_screen.dart';
import 'package:my_travel_app/ui/start/sign_up/widgets/sign_up_screen.dart';
import 'package:provider/provider.dart';

import '../ui/main/app_navigation_bar.dart';
import '../ui/start/start/widgets/start_screen.dart';

GoRouter createRouter(AppSession session) {
  print("--------- createRouter was called-----------");
  return GoRouter(
    redirect: (context, state) {
      final loggedIn = session.isLoggedIn;
      final isPublicRoute = Routes.publicRoutes.contains(state.matchedLocation);

      if (!loggedIn && isPublicRoute) {
        return Routes.start;
      }

      if (loggedIn && isPublicRoute) {
        return Routes.itinerary;
      }

      //print("Nothing to redirect.");
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
          return MultiProvider(providers: [], child: child);
        },
        routes: [
          //AppNavigationBarあり
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return AppNavigationBar(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(routes: [GoRoute(path: Routes.itinerary)]),
              StatefulShellBranch(routes: [GoRoute(path: Routes.expenses)]),
              StatefulShellBranch(routes: [GoRoute(path: Routes.settings)]),
            ],
          ),
        ],
      ),
    ],
  );
}
