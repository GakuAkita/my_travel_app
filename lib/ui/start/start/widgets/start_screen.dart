import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/routing/routes.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  static const String id = 'start_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '精神的なこと、それも技術のうち。',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 48),
              Row(
                spacing: 50,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // RoundedButton(
                  //   title: "SignUp",
                  //   onPressed: () {
                  //     context.push(Routes.signUp);
                  //   },
                  //   enabled: true, //基本は押しても何も起こらないようにしておく
                  // ),
                  RoundedButton(
                    title: "Login",
                    onPressed: () {
                      context.push(Routes.signIn);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
