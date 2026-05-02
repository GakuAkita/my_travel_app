import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository_firebase.dart';
import 'package:my_travel_app/data/repositories/email_auth/email_auth_repository.dart';
import 'package:my_travel_app/data/repositories/email_auth/email_auth_repository_firebase.dart';
import 'package:my_travel_app/data/repositories/google_auth/google_auth_repository.dart';
import 'package:my_travel_app/data/repositories/google_auth/google_auth_repository_firebase.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/**
 * These live throughout the app.
 */
List<SingleChildWidget> get providers {
  return [
    Provider<AuthRepository>(create: (_) => AuthRepositoryFirebase()),
    Provider<EmailAuthRepository>(create: (_) => EmailAuthRepositoryFirebase()),
    Provider<GoogleAuthRepository>(create: (_) => GoogleAuthRepositoryFirebase()),
    ChangeNotifierProvider(create: (context) => AppSession(authRepository: context.read<AuthRepository>())),
  ];
}
