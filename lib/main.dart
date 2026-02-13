import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/app_session.dart';
import 'package:my_travel_app/routing/router.dart';
import 'package:my_travel_app/theme/theme.dart';
import 'package:provider/provider.dart';

import 'config/dependencies.dart';
import 'firebase_options.dart';

void main() async {
  /* webに上げるとき、デフォルト状態だと.envを認識してくれないらしい */
  /* https://zenn.dev/tsukatsuka1783/articles/64c9e06d516a3e */
  await dotenv.load(fileName: "env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: providers, child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final session = context.read<AppSession>();
    _router = createRouter(session);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Travel to the World",
      theme: customDarkBlueTheme,
      routerConfig: _router,
    );
  }
}

// class MyAppOld extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     /**
//      *  強制的にExpenseStoreとItineraryStoreをインスタンス化
//      *  これをしないと、Expense画面やItinerary画面に行くまでStoreが生成されないため
//      *  */
//     context.read<ExpenseStore>();
//     context.read<ItineraryStore>();
//
//     return MaterialApp(
//       theme: customDarkBlueTheme,
//       home: AuthGate(),
//       onGenerateRoute: (settings) {
//         switch (settings.name) {
//           case StartScreen.id:
//             return MaterialPageRoute(builder: (_) => StartScreen());
//           case SignInScreen.id:
//             return MaterialPageRoute(builder: (_) => SignInScreen());
//           /* ログイン画面から直接飛ぶことにする */
//           // case ForgotPasswordScreen.id:
//           //   /* メールアドレスを渡すか */
//           //   return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
//           case SignUpScreen.id:
//             return MaterialPageRoute(builder: (_) => SignUpScreen());
//           case MainScreen.id:
//             final args = settings.arguments as Map<String, dynamic>?;
//             final index = args?['index'] ?? 0;
//             return MaterialPageRoute(builder: (_) => MainScreen(index: index));
//           //テーブル編集用の
//           case ItineraryTableEditScreen.id:
//             final args = settings.arguments;
//             final int tblIndex = args as int;
//             return MaterialPageRoute(
//               builder: (_) => ItineraryTableEditScreen(index: tblIndex),
//             );
//
//           case AddEditExpenseScreen.id:
//             /* 引数としてexpenseIdを受け取る */
//             final args = settings.arguments as Map<String, String>?;
//             final String? expenseId = args?["expenseId"];
//             /* 何もなしだったらnullが入る */
//             return MaterialPageRoute(
//               builder: (_) => AddEditExpenseScreen(expenseId: expenseId),
//             );
//           case ExpensesResultScreen.id:
//             return MaterialPageRoute(builder: (_) => ExpensesResultScreen());
//           case EstimatedExpenseScreen.id:
//             return MaterialPageRoute(builder: (_) => EstimatedExpenseScreen());
//           case ProfileScreen.id:
//             return MaterialPageRoute(builder: (_) => ProfileScreen());
//           case CreateGroupScreen.id:
//             return MaterialPageRoute(builder: (_) => CreateGroupScreen());
//           case DeleteGroupScreen.id:
//             return MaterialPageRoute(builder: (_) => DeleteGroupScreen());
//           case TravelManageScreen.id: //@FIXME　これどう考えても汚い。
//             final args = settings.arguments as Map<String, dynamic>?;
//             final userRole = args?['userRole'] ?? UserRole.normal;
//
//             return MaterialPageRoute(
//               builder: (_) => TravelManageScreen(userRole: userRole),
//             );
//
//           case GeneralManagerSelectScreen.id:
//             return MaterialPageRoute(
//               builder: (_) => GeneralManagerSelectScreen(),
//             );
//           case VersionInfoScreen.id:
//             return MaterialPageRoute(builder: (_) => VersionInfoScreen());
//           default:
//             return MaterialPageRoute(builder: (_) => StartScreen());
//         }
//       },
//     );
//   }
// }

// class AuthGate extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final userStore = context.read<UserStore>();
//
//     return FutureBuilder<ResultInfo>(
//       future: userStore.loadUserStoreDataWithNotify(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const SplashScreen();
//         }
//
//         // 初回ロード完了後に判断
//         if (userStore.currentUserId != null) {
//           FirebaseDatabaseService.setCurrentUserLastLoginToNow();
//
//           print("User is logged in. Go straight to MainScreen.");
//           return MainScreen(index: 0);
//         } else {
//           print("User is NOT logged in. Go to StartScreen.");
//           return StartScreen();
//         }
//       },
//     );
//   }
// }
