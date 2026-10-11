import 'package:flutter/material.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/start/reset_pass/view_models/reset_password_viewmodel.dart';

import '../../../../components/BasicTextField.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String initialEmail;
  final ResetPasswordViewModel viewModel;

  const ResetPasswordScreen({required this.initialEmail, required this.viewModel, super.key});

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

    widget.viewModel.updateEmail(_emailController.text);
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
    final viewModel = widget.viewModel;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: TopAppBar(automaticallyImplyLeading: true),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.lock_reset, size: 56, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 16),
                      const Text(
                        "Reset your password",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "登録したメールアドレスに、パスワード再設定用のリンクを送ります。",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 24),
                      BasicTextField(
                        labelText: "Email",
                        hintText: "you@example.com",
                        prefixIcon: const Icon(Icons.mail_outline),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        onChanged: (value) {
                          viewModel.updateEmail(value);
                        },
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                        onPressed: () async {
                          final result = await viewModel.sendResetPassword();
                          if (!mounted) return;

                          if (result.isSuccess) {
                            /* 成功した場合 */
                            showSnackBar("パスワード再設定メールを送信しました\n(ユーザー登録していない場合は送られません)");
                          } else {
                            showSnackBar(result.error?.errorMessage ?? "不明なエラ－");
                          }
                        },
                        child: const Text("パスワード再設定メール送信", style: TextStyle(fontSize: 16)),
                      ),
                    ],
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
