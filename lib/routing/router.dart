import 'package:go_router/go_router.dart';
import 'package:my_travel_app/app_session.dart';
import 'package:my_travel_app/routing/routes.dart';
import 'package:my_travel_app/screens/Start/StartScreen.dart';
import 'package:provider/provider.dart';

GoRouter createRouter(AppSession session) {
  print("--------- createRouter was called");
  return GoRouter(
    redirect: (context, state) {
      final loggedIn = session.isLoggedIn;
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
