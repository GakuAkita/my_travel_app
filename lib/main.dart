import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_travel_app/Services/FirebaseDatabaseService.dart';
import 'package:my_travel_app/Store/UserStore.dart';
import 'package:my_travel_app/screens/Main/Expenses/AddEditExpenseScreen.dart';
import 'package:my_travel_app/screens/Main/Expenses/EstimatedExpenseScreen.dart';
import 'package:my_travel_app/screens/Main/Expenses/ExpensesResultScreen.dart';
import 'package:my_travel_app/screens/Main/MainScreen.dart';
import 'package:my_travel_app/screens/Main/Settings/CreateGroupScreen.dart';
import 'package:my_travel_app/screens/Main/Settings/DeleteGroupScreen.dart';
import 'package:my_travel_app/screens/Main/Settings/GeneralManagerSelectScreen.dart';
import 'package:my_travel_app/screens/Main/Settings/ProfileScreen.dart';
import 'package:my_travel_app/screens/Main/Settings/TravelManageScreen.dart';
import 'package:my_travel_app/screens/Main/Settings/VersionInfoScreen.dart';
import 'package:my_travel_app/screens/Main/itinerary/ItineraryTableEditScreen.dart';
import 'package:my_travel_app/screens/Start/LoginScreen.dart';
import 'package:my_travel_app/screens/Start/SignUpScreen.dart';
import 'package:my_travel_app/screens/Start/SplashScreen.dart';
import 'package:my_travel_app/screens/Start/StartScreen.dart';
import 'package:my_travel_app/theme/theme.dart';
import 'package:provider/provider.dart';

import 'CommonClass/ResultInfo.dart';
import 'Store/ExpenseStore.dart';
import 'Store/ItineraryStore.dart';
import 'constants.dart';
import 'firebase_options.dart';

void main() async {
  /* webに上げるとき、デフォルト状態だと.envを認識してくれないらしい */
  /* https://zenn.dev/tsukatsuka1783/articles/64c9e06d516a3e */
  await dotenv.load(fileName: "env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserStore()),

        /// UserStore に依存する ExpenseStore
        ChangeNotifierProxyProvider<UserStore, ExpenseStore>(
          create: (_) {
            return ExpenseStore();
          },
          update: (_, userStore, expenseStore) {
            expenseStore ??= ExpenseStore();
            expenseStore.compareAndUpdateWithUser(
              userStore.shownTravelBasic,
              userStore.currentUserId,
            );
            //expenseStore.updateWithUser();
            return expenseStore;
          },
        ),

        /// UserStore に依存する ItineraryStore
        ChangeNotifierProxyProvider<UserStore, ItineraryStore>(
          create: (_) {
            return ItineraryStore();
          },
          update: (_, userStore, itineraryStore) {
            //print("UserStore changed. Update ItineraryStore.");
            itineraryStore ??= ItineraryStore();
            //itineraryStore;
            itineraryStore.compareAndUpdateWithUser(
              userStore.shownTravelBasic,
              userStore.currentUserId,
            );
            return itineraryStore;
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /**
     *  強制的にExpenseStoreとItineraryStoreをインスタンス化
     *  これをしないと、Expense画面やItinerary画面に行くまでStoreが生成されないため
     *  */
    context.read<ExpenseStore>();
    context.read<ItineraryStore>();

    return MaterialApp(
      theme: customDarkBlueTheme,
      home: AuthGate(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case StartScreen.id:
            return MaterialPageRoute(builder: (_) => StartScreen());
          case LoginScreen.id:
            return MaterialPageRoute(builder: (_) => LoginScreen());
          /* ログイン画面から直接飛ぶことにする */
          // case ForgotPasswordScreen.id:
          //   /* メールアドレスを渡すか */
          //   return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
          case SignUpScreen.id:
            return MaterialPageRoute(builder: (_) => SignUpScreen());
          case MainScreen.id:
            final args = settings.arguments as Map<String, dynamic>?;
            final index = args?['index'] ?? 0;
            return MaterialPageRoute(builder: (_) => MainScreen(index: index));
          //テーブル編集用の
          case ItineraryTableEditScreen.id:
            final args = settings.arguments;
            final int tblIndex = args as int;
            return MaterialPageRoute(
              builder: (_) => ItineraryTableEditScreen(index: tblIndex),
            );

          case AddEditExpenseScreen.id:
            /* 引数としてexpenseIdを受け取る */
            final args = settings.arguments as Map<String, String>?;
            final String? expenseId = args?["expenseId"];
            /* 何もなしだったらnullが入る */
            return MaterialPageRoute(
              builder: (_) => AddEditExpenseScreen(expenseId: expenseId),
            );
          case ExpensesResultScreen.id:
            return MaterialPageRoute(builder: (_) => ExpensesResultScreen());
          case EstimatedExpenseScreen.id:
            return MaterialPageRoute(builder: (_) => EstimatedExpenseScreen());
          case ProfileScreen.id:
            return MaterialPageRoute(builder: (_) => ProfileScreen());
          case CreateGroupScreen.id:
            return MaterialPageRoute(builder: (_) => CreateGroupScreen());
          case DeleteGroupScreen.id:
            return MaterialPageRoute(builder: (_) => DeleteGroupScreen());
          case TravelManageScreen.id: //@FIXME　これどう考えても汚い。
            final args = settings.arguments as Map<String, dynamic>?;
            final userRole = args?['userRole'] ?? UserRole.normal;

            return MaterialPageRoute(
              builder: (_) => TravelManageScreen(userRole: userRole),
            );

          case GeneralManagerSelectScreen.id:
            return MaterialPageRoute(
              builder: (_) => GeneralManagerSelectScreen(),
            );
          case VersionInfoScreen.id:
            return MaterialPageRoute(builder: (_) => VersionInfoScreen());
          default:
            return MaterialPageRoute(builder: (_) => StartScreen());
        }
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userStore = context.read<UserStore>();

    return FutureBuilder<ResultInfo>(
      future: userStore.loadUserStoreDataWithNotify(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // 初回ロード完了後に判断
        if (userStore.currentUserId != null) {
          FirebaseDatabaseService.setCurrentUserLastLoginToNow();

          print("User is logged in. Go straight to MainScreen.");
          return MainScreen(index: 0);
        } else {
          print("User is NOT logged in. Go to StartScreen.");
          return StartScreen();
        }
      },
    );
  }
}
