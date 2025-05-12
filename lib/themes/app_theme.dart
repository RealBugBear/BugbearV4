// lib/themes/app_theme.dart

import 'package:flutter/material.dart';

import 'package:bugbear_app/themes/typography.dart';

/// Globale App-Farben
class AppColors {
  static const Color background = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF333333);
  static const Color calmMint = Color(0xFF98FF98);
  static const Color gentleAccent = Color(0xFF82B1FF);
  static const Color gold = Color(0xFFFFD700);
}

/// Farben für die einzelnen Trainingsphasen (11 Einträge)
const List<Color> programColors = [
  Colors.green, // phase1
  Colors.blue, // phase2
  Colors.red, // phase3
  Colors.orange, // phase4
  Colors.purple, // phase5
  Colors.teal, // phase6
  Colors.indigo, // phase7
  Colors.yellow, // phase8
  Colors.cyan, // phase9
  Colors.pink, // phase10
  Colors.lime, // phase11 (optional)
];

class AppTheme {
  static final ThemeData light = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.calmMint,
      secondary: AppColors.gentleAccent,
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.calmMint,
      foregroundColor: AppColors.textPrimary,
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      buttonColor: AppColors.gentleAccent,
    ),
    textTheme: AppTypography.textTheme,
  );
}
