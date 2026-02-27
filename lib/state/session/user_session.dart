import '../../data/model/app_user/app_user.dart';

class UserSession {
  final AppUser _appUser;

  UserSession({required AppUser appUser}) : _appUser = appUser;

  AppUser get user => _appUser;
}
