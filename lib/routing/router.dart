import 'package:go_router/go_router.dart';
import 'package:my_travel_app/app_session.dart';
import 'package:my_travel_app/routing/routes.dart';
import 'package:provider/provider.dart';

import '../ui/start/start/widgets/start_screen.dart';

GoRouter createRouter(AppSession session) {
  print("--------- createRouter was called");
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
      GoRoute(path: Routes.signIn),
      GoRoute(path: Routes.signUp),

      /* ログイン後 */
      ShellRoute(
        builder: (context, state, child) {
          return MultiProvider(providers: []);
        },
        routes: [],
      ),
    ],
  );
}
