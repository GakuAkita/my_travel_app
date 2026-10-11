import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/routes.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  static const String id = 'start_screen';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 3),
              const Image(image: AssetImage("assets/images/public_world.png"), width: 120),
              const SizedBox(height: 32),
              const Text(
                '精神的なこと、\nこれも技術のうち。',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
              ),
              const SizedBox(height: 12),
              Text(
                "旅のしおりと割り勘を、みんなで。",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
              ),
              const Spacer(flex: 4),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                onPressed: () {
                  context.push(Routes.sign_in);
                },
                child: const Text("Login", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
