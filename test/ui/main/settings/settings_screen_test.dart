import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository_fake.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository_fake.dart';
import 'package:my_travel_app/data/services/fake/fake_backend.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/ui/main/settings/main/view_models/settings_viewmodel.dart';
import 'package:my_travel_app/ui/main/settings/main/widgets/settings_screen.dart';

void main() {
  /// FakeBackendの上に本物のSettingsViewModelを作ってSettingsScreenを表示する
  Future<FakeBackend> pumpSettings(WidgetTester tester, {required String email}) async {
    final backend = FakeBackend.seeded(signedIn: false);
    backend.auth.signInWithEmail(email, FakeBackend.demoPassword);

    final auth = AuthRepositoryFake(auth: backend.auth);
    final userSettings = UserSettingsRepositoryFake(database: backend.database);
    final session = AppSession(authRepository: auth, userSettingsRepository: userSettings);
    addTearDown(session.dispose);
    await tester.pump(); /* AppSessionがauthStateChangesからcurrentUserを受け取るのを待つ */

    final viewModel = SettingsViewModel(
      appSession: session,
      authRepository: auth,
      userSettingsRepository: userSettings,
    );
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: SettingsScreen(viewModel: viewModel))));
    await tester.pumpAndSettle(); /* fetchUserRoles()の完了を待つ */
    return backend;
  }

  testWidgets('adminには管理メニューが表示される', (tester) async {
    await pumpSettings(tester, email: FakeBackend.demoUser.email);

    expect(find.text("表示旅行選択(参加者決定)"), findsOneWidget);
    expect(find.text("旅行新規作成/削除"), findsOneWidget);
    expect(find.text("グループ作成/削除"), findsOneWidget);
    expect(find.text("プランナー選択"), findsOneWidget);
  });

  testWidgets('normalには管理メニューが表示されない', (tester) async {
    await pumpSettings(tester, email: FakeBackend.alice.email);

    expect(find.text("表示旅行選択"), findsOneWidget);
    expect(find.text("旅行新規作成/削除"), findsNothing);
    expect(find.text("グループ作成/削除"), findsNothing);
    expect(find.text("プランナー選択"), findsNothing);
  });

  testWidgets('Sign Outを押すとサインアウトする', (tester) async {
    final backend = await pumpSettings(tester, email: FakeBackend.alice.email);

    await tester.tap(find.text("Sign Out"));
    await tester.pumpAndSettle();

    expect(backend.auth.currentUser, isNull);
  });
}
