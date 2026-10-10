import 'package:my_travel_app/core/exceptions/app_exception.dart';
import 'package:my_travel_app/data/repositories/general_manager/general_manager_repository.dart';

/// 本物(RealtimeDb版)がまだ未実装なので、Fakeも同じく未実装の例外を投げる
class GeneralManagerRepositoryFake implements GeneralManagerRepository {
  @override
  Future<String?> getGeneralManager(String groupId, String travelId) async {
    throw AppException("Not implemented getGeneralManager");
  }

  @override
  Future<void> setGeneralManager(String groupId, String travelId, String uid) async {
    throw AppException("Not implemented setGeneralManager");
  }

  @override
  Future<void> deleteGeneralManager(String groupId, String travelId) async {
    throw AppException("Not implemented deleteGeneralManager");
  }
}
