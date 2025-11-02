import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/Store/UserStore.dart';
import 'package:my_travel_app/components/AuthForm.dart';
import 'package:my_travel_app/components/TopAppBar.dart';
import 'package:my_travel_app/constants.dart';
import 'package:my_travel_app/screens/Main/MainScreen.dart';
import 'package:my_travel_app/screens/Start/ForgotPasswordScreen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = "login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    final userStore = context.read<UserStore>();

    final ret = await userStore.login(email, password);

    await userStore.loadUserStoreDataWithNotify();
    if (ret.isFailed) {
      //エラーをユーザーに伝える
      print(" ${ret.error?.errorMessage}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${ret.error?.errorMessage}"),
          backgroundColor: Theme.of(context).colorScheme.onError,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = false;
    });
    //サインアップとログインが成功したら、メイン画面に遷移
    Navigator.pushNamedAndRemoveUntil(
      context,
      MainScreen.id,
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(automaticallyImplyLeading: true),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: AuthForm(
          screenType: SCREEN_TYPE.LOGIN,
          onSubmit: handleLogin,
          onForgotPassword: (email) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ForgotPasswordScreen(initialEmail: email),
              ),
            );
          },
        ),
      ),
    );
  }
}
