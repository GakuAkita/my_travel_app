import 'package:flutter_test/flutter_test.dart';
import 'package:my_travel_app/constants.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/services/fake/fake_backend.dart';
import 'package:my_travel_app/ui/core/store/travel_scope_store.dart';
import 'package:my_travel_app/ui/main/settings/travel_select/view_models/travle_select_viewmodel.dart';
import 'package:my_travel_app/ui/main/settings/travel_select/widgets/travel_select_screen.dart';
import 'package:provider/provider.dart';

import '../../../helpers/fake_app.dart';

void main() {
  late TravelSelectViewModel viewModel;
  late TravelScopeStore store;

  Future<FakeBackend> pumpTravelSelect(WidgetTester tester) {
    return pumpFakeApp(
      tester,
      email: FakeBackend.demoUser.email,
      screen: (context) => ChangeNotifierProvider(
        create: (c) => TravelSelectViewModel(
          appSession: c.read(),
          travelSession: c.read(),
          itineraryStore: c.read(),
          travelScopeStore: c.read(),
          getUserTravelsUseCase: c.read(),
          userSettingsRepository: c.read(),
          groupMembersRepository: c.read(),
          participantsRepository: c.read(),
          userRole: UserRole.admin,
        ),
        builder: (c, _) {
          viewModel = c.read();
          store = c.read();
          return TravelSelectScreen(userRole: UserRole.admin, viewModel: viewModel);
        },
      ),
    );
  }

  /* 指定したuidのチェックを切り替える */
  void toggle(String uid) {
    final index = viewModel.selectableParticipants.indexWhere((p) => p.traveler.core.uid == uid);
    viewModel.switchChecked(index);
  }

  /* チェックが入っているuid */
  Iterable<String> checkedUids() =>
      viewModel.selectableParticipants.where((p) => p.isChecked).map((p) => p.traveler.core.uid);

  /* まだ参加者が保存されていない旅行を追加して選択する */
  Future<void> selectNewTravel(WidgetTester tester, FakeBackend backend, String travelId) async {
    final group = FirebaseDatabasePaths.group(FakeBackend.demoGroupId);
    backend.database.set(FirebaseDatabasePaths.groupKey(FakeBackend.demoGroupId).travel(travelId), true);
    backend.database.set(group.travels.travel(travelId).name, "Other Trip");
    await viewModel.initialize();
    await tester.pump();

    viewModel.setSelectTravelId(travelId);
    await viewModel.setTravelers();
  }

  testWidgets('保存されている参加者だけにチェックが入り、メンバー全員が候補に出る', (tester) async {
    final backend = await pumpTravelSelect(tester);
    final travelers = FirebaseDatabasePaths.group(FakeBackend.demoGroupId).travels.travel(FakeBackend.demoTravelId).travelers;
    backend.database.set(travelers, {FakeBackend.alice.uid: FakeBackend.alice.toJson()});

    await viewModel.setTravelers();

    expect(viewModel.selectableParticipants, hasLength(3));
    expect(checkedUids(), [FakeBackend.alice.uid]);
  });

  testWidgets('参加者が保存されていない旅行では誰にもチェックが入らない', (tester) async {
    final backend = await pumpTravelSelect(tester);

    await selectNewTravel(tester, backend, "other-travel");

    expect(viewModel.selectableParticipants, hasLength(3));
    expect(checkedUids(), isEmpty);
  });

  testWidgets('外した参加者は開き直してもチェックが外れたまま', (tester) async {
    await pumpTravelSelect(tester);

    toggle(FakeBackend.bob.uid);
    await viewModel.setParticipants();
    await viewModel.setTravelers();

    expect(checkedUids(), unorderedEquals([FakeBackend.demoUser.uid, FakeBackend.alice.uid]));
  });

  testWidgets('表示中の旅行の参加者を更新すると、再起動しなくてもStoreに反映される', (tester) async {
    await pumpTravelSelect(tester);
    expect(store.participants.data!.keys, contains(FakeBackend.bob.uid));

    toggle(FakeBackend.bob.uid);
    final ret = await viewModel.setParticipants();

    expect(ret.isSuccess, isTrue);
    expect(store.participants.isLoading, isFalse);
    expect(store.participants.data!.keys, unorderedEquals([FakeBackend.demoUser.uid, FakeBackend.alice.uid]));
  });

  testWidgets('表示中でない旅行の参加者を更新しても、Storeの参加者は変わらない', (tester) async {
    final backend = await pumpTravelSelect(tester);
    const otherTravelId = "other-travel";
    await selectNewTravel(tester, backend, otherTravelId);

    toggle(FakeBackend.alice.uid);
    final ret = await viewModel.setParticipants();

    expect(ret.isSuccess, isTrue);
    expect(store.participants.data!.keys, contains(FakeBackend.bob.uid));
    final saved = backend.database.getChildren(
      FirebaseDatabasePaths.group(FakeBackend.demoGroupId).travels.travel(otherTravelId).travelers,
    );
    expect(saved.keys, [FakeBackend.alice.uid]);
  });
}
