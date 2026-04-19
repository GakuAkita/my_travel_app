import 'package:my_travel_app/data/model/itinerary_on_edit/itinerary_on_edit.dart';

import '../../model/itinerary_section/itinerary_section.dart';

abstract class ItineraryRepository {
  Stream<List<ItinerarySection>> watchItinerarySections({
    required String groupId,
    required String travelId,
  });

  Future<List<ItinerarySection>> getItinerarySections({
    required String groupId,
    required String travelId,
  });

  Future<void> saveItinerarySections({
    required String groupId,
    required String travelId,
    required List<ItinerarySection> sections,
  });

  Future<ItineraryOnEdit?> getItineraryOnEdit({
    required String groupId,
    required String travelId,
  });

  Future<void> setItineraryOnEdit({
    required String groupId,
    required String travelId,
    required ItineraryOnEdit itineraryOnEdit,
  });

  Future<void> removeItineraryOnEdit({
    required String groupId,
    required String travelId,
  });

  /**
   * 現状、クライアントとの接続が切れたらonEditのデータを消す仕様だが、
   * 例えば、アプリ起動中にオフラインになったときもonEditを消してしまう。
   * 状況としてはそんな頻繁に起こるものではないが、、
   * UI側でオフラインになったらブロックするのもありだな
   */
  Future<void> setOnEditOnDisconnectRemove({
    required String groupId,
    required String travelId,
  });

  Future<void> cancelOnEditDisconnect({
    required String groupId,
    required String travelId,
  });
}
