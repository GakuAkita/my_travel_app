import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/routing/router.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/ui/core/theme/theme.dart';
import 'package:provider/provider.dart';

import 'config/dependencies.dart';
import 'firebase_options.dart';

void main() async {
  /* webに上げるとき、デフォルト状態だと.envを認識してくれないらしい */
  /* https://zenn.dev/tsukatsuka1783/articles/64c9e06d516a3e */
  await dotenv.load(fileName: "env");
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final database = FirebaseDatabase.instance;
  if (kDebugMode) {
    /* デバッグモードだったらエミュレータに接続する */
    try {
      print("UseEmulators!!");
      database.useDatabaseEmulator("10.0.2.2", 9000);
    } catch (e) {
      print("Firebase Emulator connection failed: $e");
    }
  }
  runApp(MultiProvider(providers: providers, child: MyApp()));
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
