// app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF9C27B0);
  static const Color accentColor = Color(0xFFFFC107);
  static const Color backgroundColor = Color(0xFFF5F5F5);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: accentColor,
      surface: backgroundColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Lexend'),
      displayMedium: TextStyle(fontFamily: 'Lexend'),
      displaySmall: TextStyle(fontFamily: 'Lexend'),
      headlineLarge: TextStyle(fontFamily: 'Lexend'),
      headlineMedium: TextStyle(fontFamily: 'Lexend'),
      headlineSmall: TextStyle(fontFamily: 'Lexend'),
      bodyLarge: TextStyle(fontFamily: 'Lexend'),
      bodyMedium: TextStyle(fontFamily: 'Lexend'),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      titleTextStyle: TextStyle(
        fontFamily: 'Lexend',
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontFamily: 'Lexend'),
      ),
    ),
  );
}
