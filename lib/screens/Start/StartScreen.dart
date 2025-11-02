import 'package:flutter/material.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/screens/Start/LoginScreen.dart';

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
                'There is only one way left to go and That\'s up !',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 48),
              Row(
                spacing: 50,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // RoundedButton(
                  //   title: "SignUp",
                  //   onPressed: () {
                  //     Navigator.pushNamed(context, SignUpScreen.id);
                  //   },
                  //   enabled: true, //基本は押しても何も起こらないようにしておく
                  // ),
                  RoundedButton(
                    title: "Login",
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.id);
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
