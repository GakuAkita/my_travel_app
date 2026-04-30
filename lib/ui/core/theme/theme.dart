import 'package:flutter/material.dart';

final String baseFontFamily = "NotoSerifJP";
final ThemeData customDarkBlueTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.grey[900],
  primaryColor: Colors.lightBlueAccent,
  fontFamily: baseFontFamily,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.lightBlueAccent,
    iconTheme: IconThemeData(color: Colors.grey[900]),
    titleTextStyle: TextStyle(
      fontFamily: "Caveat",
      fontFamilyFallback: [baseFontFamily],
      color: Colors.grey[900],
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
  ),
  colorScheme: ColorScheme.dark(
    primary: Colors.lightBlueAccent,
    // メインカラー（青）
    secondary: Colors.cyanAccent,
    // セカンダリカラー（青系）
    surface: Colors.grey[850]!,
    // 背景色（暗い灰色）
    error: Colors.redAccent,
    // エラー色（赤）
    onPrimary: Colors.black,
    // メインカラー上の文字色（黒）
    onSecondary: Colors.black,
    // セカンダリカラー上の文字色（黒）
    onSurface: Colors.white,
    // 背景色上の文字色（白）
    onError: Colors.white, // エラー色上の文字色（白）
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.lightBlueAccent, // 青いFAB背景
    foregroundColor: Colors.black, // FABアイコン色（黒）
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.lightBlueAccent, // ボタン背景色（青）
    textTheme: ButtonTextTheme.primary, // ボタンのテキスト色（白）
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.lightBlueAccent, // ボタン背景色（青）
      foregroundColor: Colors.black, // ボタンテキスト色（黒）
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textTheme: ThemeData.dark().textTheme
      .apply(
        fontFamily: baseFontFamily,
        bodyColor: Colors.white, // bodyMediumなどに適用
        displayColor: Colors.white, // titleLargeなどに適用
      )
      .copyWith(
        // 特定のスタイルのみ色を上書き
        titleLarge: TextStyle(color: Colors.lightBlueAccent), // タイトル（青）
      ),
  splashColor: Colors.transparent,
  // 波紋の非表示
  iconTheme: IconThemeData(color: Colors.lightBlueAccent),
  // アイコンの色（青）
  dividerColor: Colors.grey[700],
  // 区切り線の色（灰色）
  useMaterial3: true,
);
