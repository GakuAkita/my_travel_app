import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_travel_app/config/dependencies.dart';
import 'package:my_travel_app/data/services/fake/fake_backend.dart';
import 'package:my_travel_app/routing/router.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:provider/provider.dart';

/// Fakeモードのアプリと同じProvider構成(appProviders + buildLoggedInProviders)の中で
/// [screen]を表示する。ViewModelは[screen]の中でcontext.read()して渡す。
///
/// [email]のユーザーでサインインした状態で始まる。パスワードは全員FakeBackend.demoPassword
Future<FakeBackend> pumpFakeApp(
  WidgetTester tester, {
  required String email,
  required Widget Function(BuildContext context) screen,
}) async {
  final backend = FakeBackend.seeded(signedIn: false);
  backend.auth.signInWithEmail(email, FakeBackend.demoPassword);

  await tester.pumpWidget(
    MultiProvider(
      providers: appProviders(fake: backend),
      child: _LoggedInScope(screen: screen),
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
class _LoggedInScope extends StatelessWidget {
  final Widget Function(BuildContext context) screen;

  const _LoggedInScope({required this.screen});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AppSession>();
    if (!session.isLoggedIn) {
      return const SizedBox.shrink();
    }
    return MultiProvider(
      providers: buildLoggedInProviders(context),
      child: MaterialApp(
        home: Scaffold(body: Builder(builder: screen)),
      ),
    );
  }
}
