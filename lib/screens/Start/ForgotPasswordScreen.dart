import 'package:flutter/material.dart';
import 'package:my_travel_app/Services/AuthService.dart';
import 'package:my_travel_app/components/TopAppBar.dart';

import '../../components/BasicTextField.dart';
import '../../components/RoundedButton.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String initialEmail;

  const ForgotPasswordScreen({required this.initialEmail, super.key});
  static const String id = "forgot_password";

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _emailController;

  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // 初期値として受け取った email をセット
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose(); // メモリリーク防止
    super.dispose();
  }

  void showSnackBar(String message) {
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
    return Scaffold(
      appBar: TopAppBar(automaticallyImplyLeading: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Reset your password",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              BasicTextField(
                hintText: "Email",
                controller: _emailController,
                onChanged: (value) => {},
              ),
              const SizedBox(height: 20),
              RoundedButton(
                title: "パスワード再設定メール送信",
                onPressed: () async {
                  final result = await _authService.sendResetPassword(
                    _emailController.text,
                  );

                  if (result.isSuccess) {
                    /* 成功した場合 */
                    showSnackBar("パスワード再設定メールを送信しました\n(ユーザー登録していない場合は送られません)");
                  } else {
                    var message = "";
                    switch (result.error?.errorCode) {
                      case FirebaseAuthErrorCodes.invalidEmail:
                      case FirebaseAuthErrorCodes.tooManyRequests:
                        final errorMsg = result.error?.errorMessage;
                        if (errorMsg == null) {
                          message = "エラーメッセージが空です";
                        } else {
                          message = result.error!.errorMessage!;
                        }
                        break;

                      default:
                        message = "再設定メール送信に失敗しました";
                        break;
                    }
                    print(message);
                    showSnackBar(message);
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
