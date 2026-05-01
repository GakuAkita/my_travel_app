import 'package:flutter/material.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/start/reset_pass/view_models/reset_password_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../components/BasicTextField.dart';
import '../../../../components/RoundedButton.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String initialEmail;

  const ResetPasswordScreen({required this.initialEmail, super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    // 初期値として受け取った email をセット
    _emailController = TextEditingController(text: widget.initialEmail);

    final viewModel = context.read<ResetPasswordViewModel>();
    viewModel.updateEmail(_emailController.text);
  }

  @override
  void dispose() {
    _emailController.dispose(); // メモリリーク防止
    super.dispose();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResetPasswordViewModel>();
    return Scaffold(
      appBar: TopAppBar(automaticallyImplyLeading: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Reset your password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              BasicTextField(
                hintText: "Email",
                controller: _emailController,
                onChanged: (value) {
                  viewModel.updateEmail(value);
                },
              ),
              const SizedBox(height: 20),
              RoundedButton(
                title: "パスワード再設定メール送信",
                onPressed: () async {
                  final result = await viewModel.sendResetPassword();

                  if (result.isSuccess) {
                    /* 成功した場合 */
                    showSnackBar("パスワード再設定メールを送信しました\n(ユーザー登録していない場合は送られません)");
                  } else {
                    showSnackBar(result.error?.errorMessage ?? "不明なエラ－");
                  }
                },
                textStyle: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
