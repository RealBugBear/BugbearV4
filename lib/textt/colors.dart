import 'package:flutter/material.dart';

class AppTheme {
  // Primärfarbe: Sanftes Violett
  static const Color primaryColor = Color(0xFF9C27B0);
  // Akzentfarbe: Warmes Amber
  static const Color accentColor = Color(0xFFFFC107);
  // Hintergrundfarbe: Helles Grau
  static const Color backgroundColor = Color.fromARGB(255, 42, 11, 92);

  // Light Theme Definition
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    // Use ColorScheme.fromSeed to generate a modern color scheme:
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: accentColor,
      surface: const Color.fromARGB(255, 93, 7, 103),
    ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 94, 5, 47),
    // TextTheme: Use Lexend as the font family with updated naming
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
