import 'package:flutter/material.dart';

import '../constants.dart';
import 'BasicTextField.dart';
import 'RoundedButton.dart';

class AuthForm extends StatefulWidget {
  final SCREEN_TYPE screenType;
  final Function(String email, String password) onSubmit;
  final Function(String email)? onForgotPassword;
  final bool isLoading;

  const AuthForm({
    required this.screenType,
    required this.onSubmit,
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BasicTextField(
              hintText: "Email",
              autofocus: true,
              onChanged: (value) => email = value,
            ),
            SizedBox(height: 30),
            BasicTextField(
              hintText: "Password",
              obscureText: true,
              onChanged: (value) => password = value,
            ),
            SizedBox(height: 40),
            RoundedButton(
              title:
                  widget.screenType == SCREEN_TYPE.LOGIN ? "Login" : "Sign Up",
              onPressed: () async {
                await widget.onSubmit(email, password);
              },
              textStyle: TextStyle(fontSize: 15),
              buttonStyle: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 100),
              ),
            ),
            if (widget.screenType == SCREEN_TYPE.LOGIN) ...[
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  widget.onForgotPassword?.call(email);
                },
                child: Text(
                  "Forgot your password?",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
