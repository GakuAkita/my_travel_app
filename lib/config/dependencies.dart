import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository_firebase.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/**
 * These live throughout the app.
 */
List<SingleChildWidget> get providers {
  return [
    Provider<FirebaseDatabase>(create: (_) => FirebaseDatabase.instance),
    Provider<AuthRepository>(create: (_) => AuthRepositoryFirebase()),
    ChangeNotifierProxyProvider(
      create:
          (context) =>
              AppSession(authRepository: context.read<AuthRepository>()),
      update: (context, auth, previous) {
        /* AppSessionを作り直すのではなく、同じインスタンスを返す */
        return previous!;
      },
    ),
  ];
}
