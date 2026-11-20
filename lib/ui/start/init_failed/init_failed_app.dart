import 'package:flutter/material.dart';
import 'package:my_travel_app/ui/core/theme/theme.dart';

/// 起動時の初期化(Firebaseなど)に失敗したときに表示するアプリ。
/// webでは外部CDNからFirebase JS SDKを読み込むため、通信状況によって失敗することがある。
class InitFailedApp extends StatelessWidget {
  const InitFailedApp({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Travel to the World",
      theme: customDarkBlueTheme,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, size: 64),
                  const SizedBox(height: 24),
                  const Text(
                    "読み込みに失敗しました",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "通信環境を確認して、もう一度お試しください。",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                    onPressed: onRetry,
                    child: const Text("再読み込み", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
