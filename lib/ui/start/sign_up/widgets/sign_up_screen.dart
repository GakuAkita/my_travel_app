import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../../components/AuthForm.dart';
import '../../../../constants.dart';
import '../../../core/ui/top_app_bar.dart';
import '../../sign_in/view_models/sign_in_viewmodel.dart';

class SignUpScreen extends StatefulWidget {
  final SignInViewModel viewModel;

  const SignUpScreen({super.key, required this.viewModel});

  static const String id = "signup_screen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: TopAppBar(automaticallyImplyLeading: true),
          body: LoadingOverlay(
            isLoading: viewModel.isLoading,
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: AuthForm(
                    screenType: SCREEN_TYPE.SIGNUP,
                    onSubmit: (email, password) async {
                      final result = await viewModel.signUpAndSignInWithEmail(email, password);
                      if (result.isSuccess) {
                        /* createRouterで検知して遷移する */
                      } else {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${result.error?.errorMessage}"), duration: Duration(seconds: 2)),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
