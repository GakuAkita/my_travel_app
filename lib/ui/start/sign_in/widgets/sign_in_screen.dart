import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/components/AuthForm.dart';
import 'package:my_travel_app/constants.dart';
import 'package:my_travel_app/routing/routes.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:provider/provider.dart';

import '../view_models/sign_in_viewmodel.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignInViewModel>();
    return Scaffold(
      appBar: TopAppBar(automaticallyImplyLeading: true),
      body: LoadingOverlay(
        isLoading: viewModel.isLoading,
        child: AuthForm(
          screenType: SCREEN_TYPE.LOGIN,
          onSubmit: (email, password) async {
            final result = await viewModel.signInWithEmail(email, password);
            if (result.isSuccess) {
              print("success");
            } else {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${result.error?.errorMessage}"), duration: Duration(seconds: 2)),
              );
            }
          },
          onGoogleTap: () async {
            print("tapped");
            await viewModel.signInWithGoogle();
            print("Google has ended");
          },
          onForgotPassword: (email) {
            /* 引数を渡す */
            print("$email pushed");
            context.push(Routes.reset_password, extra: email);
          },
        ),
      ),
    );
  }
}
