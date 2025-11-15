import 'dart:math';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _rotationController;
  late Animation<double> _imageFadeAnimation;
  late Animation<double> _imageScaleAnimation;
  late Animation<double> _imageRotationAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // 回転用のコントローラー（ゆっくり継続的に回転）
    _rotationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // 画像のフェードインとスケールアニメーション
    _imageFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _imageScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // 回転アニメーション（360度回転、継続的に繰り返し）
    _imageRotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    // テキストのフェードインアニメーション（少し遅れて開始）
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    // フェードインアニメーションを開始
    _controller.forward().then((_) {
      // フェードイン完了後、回転を開始（無限に繰り返し）
      _rotationController.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 画像のアニメーション
            AnimatedBuilder(
              animation: Listenable.merge([_controller, _rotationController]),
              builder: (context, child) {
                return Opacity(
                  opacity: _imageFadeAnimation.value,
                  child: Transform(
                    alignment: Alignment.center,
                    transform:
                        Matrix4.identity()
                          ..setEntry(3, 2, 0.001) // perspective for 3D effect
                          ..rotateY(_imageRotationAnimation.value)
                          ..scale(
                            _imageScaleAnimation.value,
                            _imageScaleAnimation.value,
                          ),
                    child: child,
                  ),
                );
              },
              child: const Image(
                image: AssetImage('assets/images/public_world.png'),
                width: 200,
              ),
            ),
            SizedBox(height: 30),
            // テキストのアニメーション
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(opacity: _textFadeAnimation.value, child: child);
              },
              child: const Column(
                children: [
                  Text(
                    "Necessity is",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "the mother of invention",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
