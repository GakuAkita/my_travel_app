import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_travel_app/components/ValidatedSwitch.dart';
import 'package:my_travel_app/data/model/itinerary_section/itinerary_section.dart';
import 'package:my_travel_app/data/services/fake/fake_backend.dart';
import 'package:my_travel_app/ui/main/itinerary/main/view_models/itinerary_viewmodel.dart';
import 'package:my_travel_app/ui/main/itinerary/main/widgets/itinerary_screen.dart';
import 'package:provider/provider.dart';

import '../../../helpers/fake_app.dart';

void main() {
  late ItineraryViewModel viewModel;

  Future<FakeBackend> pumpItinerary(WidgetTester tester, {required String email}) {
    return pumpFakeApp(
      tester,
      email: email,
      screen: (context) {
        viewModel = context.read();
        return ItineraryScreen(viewModel: viewModel);
      },
    );
  }

  testWidgets('シードされた旅程が表示される', (tester) async {
    await pumpItinerary(tester, email: FakeBackend.bob.email);

    expect(find.text("1日目"), findsOneWidget); /* Markdownセクションのタイトル */
    expect(find.text("場所"), findsOneWidget); /* テーブルセクションのヘッダー */
  });

  testWidgets('プランナー(demoUser)にはプランナーモードの切り替えが表示される', (tester) async {
    await pumpItinerary(tester, email: FakeBackend.demoUser.email);

    expect(find.text("プランナーモード"), findsOneWidget);
  });

  testWidgets('プランナーでもadminでもない(bob)にはプランナーモードが表示されない', (tester) async {
    await pumpItinerary(tester, email: FakeBackend.bob.email);

    expect(find.text("プランナーモード"), findsNothing);
  });

  testWidgets('編集モードでMarkdownを編集するとViewModelに反映される', (tester) async {
    await pumpItinerary(tester, email: FakeBackend.demoUser.email);

    await tester.tap(find.byType(ValidatedSwitch));
    await settle(tester);
    expect(viewModel.editMode, isTrue);

    /* Markdownセクション(section-1)のタイトル欄 */
    final titleField = find.widgetWithText(TextField, "1日目");
    expect(titleField, findsOneWidget);

    await tester.enterText(titleField, "初日");
    await settle(tester);

    final section = viewModel.getSectionById("section-1") as MarkdownSection;
    expect(section.title, "初日");
  });
}
