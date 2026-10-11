import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/config/dependencies.dart';
import 'package:my_travel_app/data/services/fake/fake_backend.dart';
import 'package:my_travel_app/routing/router.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:provider/provider.dart';

/// [pushed]がtrueのとき、[screen]の下にあるホーム画面のテキスト
const fakeAppHomeText = "fake-app-home";

/// Fakeモードのアプリと同じProvider構成(appProviders + buildLoggedInProviders)の中で
/// [screen]を表示する。ViewModelは[screen]の中でcontext.read()して渡す。
///
/// [email]のユーザーでサインインした状態で始まる。パスワードは全員FakeBackend.demoPassword
///
/// [pushed]をtrueにすると、ホーム画面の上にgo_routerで積んだ状態で表示する。
/// 画面の中でcontext.pop()するときに使う(popするとfakeAppHomeTextが表示される)
Future<FakeBackend> pumpFakeApp(
  WidgetTester tester, {
  required String email,
  required Widget Function(BuildContext context) screen,
  bool pushed = false,
}) async {
  final backend = FakeBackend.seeded(signedIn: false);
  backend.auth.signInWithEmail(email, FakeBackend.demoPassword);

  await tester.pumpWidget(
    MultiProvider(
      providers: appProviders(fake: backend),
      child: _LoggedInScope(screen: screen, pushed: pushed),
    ),
  );
  await settle(tester);
  return backend;
}

/// 非同期の読み込みを待つ。
/// LoadingOverlayのインジケータが回り続けることがあるのでpumpAndSettleは使わない
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/* AppSessionがサインイン済みになってからログイン後のProviderを作る(ShownTravelSessionがuidを必要とするため) */
class _LoggedInScope extends StatefulWidget {
  final Widget Function(BuildContext context) screen;
  final bool pushed;

  const _LoggedInScope({required this.screen, required this.pushed});

  @override
  State<_LoggedInScope> createState() => _LoggedInScopeState();
}

class _LoggedInScopeState extends State<_LoggedInScope> {
  /* ホーム(/)の上に画面(/screen)を積む。リビルドで作り直さないようにここで持つ */
  late final GoRouter _router = GoRouter(
    initialLocation: "/screen",
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const Scaffold(body: Text(fakeAppHomeText)),
        routes: [GoRoute(path: "screen", builder: (context, state) => widget.screen(context))],
      ),
    ],
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AppSession>();
    if (!session.isLoggedIn) {
      return const SizedBox.shrink();
    }
    return MultiProvider(
      providers: buildLoggedInProviders(context),
      child: widget.pushed
          ? MaterialApp.router(routerConfig: _router)
          : MaterialApp(
              home: Scaffold(body: Builder(builder: widget.screen)),
            ),
    );
  }
}
