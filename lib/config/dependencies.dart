import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository_firebase.dart';
import 'package:my_travel_app/data/repositories/email_auth/email_auth_repository.dart';
import 'package:my_travel_app/data/repositories/email_auth/email_auth_repository_firebase.dart';
import 'package:my_travel_app/data/repositories/google_auth/google_auth_repository.dart';
import 'package:my_travel_app/data/repositories/google_auth/google_auth_repository_firebase.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/user_settings/user_settings_repository.dart';
import '../data/repositories/user_settings/user_settings_repository_realtimedb.dart';

/**
 * These live throughout the app.
 */
List<SingleChildWidget> get providers {
  return [
    Provider<AuthRepository>(create: (_) => AuthRepositoryFirebase()),
    Provider<EmailAuthRepository>(create: (_) => EmailAuthRepositoryFirebase()),
    Provider<GoogleAuthRepository>(create: (_) => GoogleAuthRepositoryFirebase()),
    Provider<UserSettingsRepository>(
      /* こいつだけ変だけど、AppSessionの中で使いたい、 */
      create: (innerContext) {
        print("UserSettingsRepository was created");
        return UserSettingsRepositoryRealtimeDb(database: FirebaseDatabase.instance);
      },
      dispose: (innerContext, repository) {
        print("UserSettingsRepository was disposed");
      },
      lazy: false,
    ),
    ChangeNotifierProvider(
      create: (context) =>
          AppSession(authRepository: context.read<AuthRepository>(), userSettingsRepository: context.read()),
    ),
  ];
}
