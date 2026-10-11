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
    onSurfaceVariant: Colors.white70,
    // 補足テキストの色（少し暗い白）
    outlineVariant: Colors.grey[700],
    // M3のDividerなどの線の色（灰色）
    outline: Colors.grey[600],
    // OutlinedButtonなどの枠線の色（灰色）
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
  inputDecorationTheme: InputDecorationTheme(
    // 入力欄は少し明るい背景の角丸
    filled: true,
    fillColor: Colors.grey[850],
    hintStyle: TextStyle(color: Colors.white38),
    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[700]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[800]!),
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.grey[850],
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey[800]!),
    ),
  ),
  snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating),
  // 選択中のチップとナビゲーションバーは、シアンではなく薄い青で目立たせる
  chipTheme: ChipThemeData(
    selectedColor: Colors.lightBlueAccent.withValues(alpha: 0.25),
    checkmarkColor: Colors.lightBlueAccent,
    labelStyle: TextStyle(color: Colors.white, fontFamily: baseFontFamily),
    secondaryLabelStyle: TextStyle(color: Colors.white, fontFamily: baseFontFamily),
    side: BorderSide(color: Colors.grey[700]!),
  ),
  navigationBarTheme: NavigationBarThemeData(
    indicatorColor: Colors.lightBlueAccent.withValues(alpha: 0.25),
    iconTheme: WidgetStateProperty.resolveWith(
      (states) => IconThemeData(color: states.contains(WidgetState.selected) ? Colors.lightBlueAccent : Colors.white70),
    ),
  ),
  splashColor: Colors.transparent,
  // 波紋の非表示
  iconTheme: IconThemeData(color: Colors.lightBlueAccent),
  // アイコンの色（青）
  dividerColor: Colors.grey[700],
  // 区切り線の色（灰色）
  useMaterial3: true,
);
