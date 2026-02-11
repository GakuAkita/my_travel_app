import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/Store/UserStore.dart';
import 'package:my_travel_app/components/AuthForm.dart';
import 'package:my_travel_app/components/TopAppBar.dart';
import 'package:my_travel_app/constants.dart';
import 'package:provider/provider.dart';

import '../view_models/sign_in_viewmodel.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String id = "login_screen";

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
    final viewModel = context.watch<SignInViewModel>();
    return Scaffold(
      appBar: TopAppBar(automaticallyImplyLeading: true),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: AuthForm(
          screenType: SCREEN_TYPE.LOGIN,
          onSubmit: (email, password) async {
            final result = await viewModel.signInWithEmail(email, password);
            if (result.isSuccess) {
              print("success");
            } else {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${result.error?.errorMessage}"),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
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
