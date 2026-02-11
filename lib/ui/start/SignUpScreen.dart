import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/Store/UserStore.dart';
import 'package:provider/provider.dart';

import '../../components/AuthForm.dart';
import '../../components/TopAppBar.dart';
import '../../constants.dart';
import '../Main/MainScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String id = "signup_screen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;

  void handleSignUp(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    final userStore = context.read<UserStore>();
    final signUpRet = await userStore.signUp(email, password);
    if (signUpRet.isFailed) {
      //エラーをユーザーに伝えるj
      print("${signUpRet.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${signUpRet.message}"),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final loginRet = await userStore.login(email, password);
    if (loginRet.isFailed) {
      //エラーをユーザーに伝える
      print("${loginRet.error?.errorMessage}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${loginRet.error?.errorMessage}"),
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
        child: AuthForm(screenType: SCREEN_TYPE.SIGNUP, onSubmit: handleSignUp),
      ),
    );
  }
}
