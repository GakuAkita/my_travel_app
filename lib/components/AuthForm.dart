import 'package:flutter/material.dart';

import '../constants.dart';
import 'BasicTextField.dart';

class AuthForm extends StatefulWidget {
  final SCREEN_TYPE screenType;
  final Function(String email, String password) onSubmit;
  final VoidCallback? onGoogleTap;
  final Function(String email)? onForgotPassword;
  final bool isLoading;

  const AuthForm({
    required this.screenType,
    required this.onSubmit,
    this.onGoogleTap,
    this.onForgotPassword,
    this.isLoading = false,
    super.key,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  String email = "";
  String password = "";
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLogin = widget.screenType == SCREEN_TYPE.LOGIN;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isLogin ? "ログイン" : "アカウント作成",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              if (widget.onGoogleTap != null) ...[
                Center(
                  child: GestureDetector(
                    onTap: widget.onGoogleTap,
                    child: const Image(image: AssetImage("assets/images/android_light_rd_ctn4x.png"), width: 250),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text("またはメールアドレスで", style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              BasicTextField(
                labelText: "Email",
                hintText: "you@example.com",
                prefixIcon: const Icon(Icons.mail_outline),
                keyboardType: TextInputType.emailAddress,
                autofocus: widget.onGoogleTap == null,
                onChanged: (value) => email = value,
              ),
              const SizedBox(height: 16),
              BasicTextField(
                labelText: "Password",
                hintText: "",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  tooltip: _obscurePassword ? "パスワードを表示" : "パスワードを隠す",
                  icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                obscureText: _obscurePassword,
                onChanged: (value) => password = value,
              ),
              const SizedBox(height: 24),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                onPressed: widget.isLoading
                    ? null
                    : () async {
                        await widget.onSubmit(email, password);
                      },
                child: Text(isLogin ? "Login" : "Sign Up", style: const TextStyle(fontSize: 16)),
              ),
              if (isLogin) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    widget.onForgotPassword?.call(email);
                  },
                  child: const Text("Forgot your password?"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
