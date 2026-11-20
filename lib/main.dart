import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/routing/router.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/ui/core/theme/theme.dart';
import 'package:my_travel_app/ui/start/init_failed/init_failed_app.dart';
import 'package:provider/provider.dart';

import 'config/dependencies.dart';
import 'core/utils/page_reload/page_reload.dart';
import 'firebase_options.dart';

/// webではFirebase JS SDKを外部CDN(gstatic)から読み込む。
/// 読み込みに失敗するとinitializeAppが完了もエラーもせずに止まり、
/// index.htmlのスプラッシュ画面のまま進まなくなるのでタイムアウトを設ける。
const Duration _firebaseInitTimeout = Duration(seconds: 15);

void main() {
  _bootstrap();
}

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    /* webに上げるとき、デフォルト状態だと.envを認識してくれないらしい */
    /* https://zenn.dev/tsukatsuka1783/articles/64c9e06d516a3e */
    await dotenv.load(fileName: "env");
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).timeout(_firebaseInitTimeout);
  } catch (e, st) {
    debugPrint("App initialization failed: $e\n$st");
    runApp(
      InitFailedApp(
        onRetry: () {
          if (kIsWeb) {
            /* 失敗したdynamic importの状態が残らないようにページごと読み直す */
            reloadPage();
          } else {
            _bootstrap();
          }
        },
      ),
    );
    return;
  }

  if (kDebugMode) {
    /* デバッグモードだったらエミュレータに接続する */
    try {
      FirebaseAuth.instance.useAuthEmulator("localhost", 9099);

      /// まじで意味わからないが、
      /// java.lang.IllegalStateException: Cannot call useEmulator() after instance has already been initialized.
      /// こういうエラーが出る。
      FirebaseDatabase.instance.useDatabaseEmulator("localhost", 9000);
    } catch (e) {
      print("Firebase Emulator connection failed: $e");
    }
  }
  runApp(MultiProvider(providers: appProviders(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoRouter _router;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final session = context.read<AppSession>();
    _router = createRouter(session);
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AppSession>();
    return MaterialApp.router(
      key: ValueKey(session.isLoggedIn),
      title: "Travel to the World",
      theme: customDarkBlueTheme,
      //routerConfig: createRouter(session),
      routerConfig: _router,
    );
  }
}
