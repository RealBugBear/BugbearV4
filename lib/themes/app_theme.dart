// lib/themes/app_theme.dart
import 'package:flutter/material.dart';
import 'package:bugbear_app/themes/colors.dart';
import 'package:bugbear_app/themes/typography.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    // Primär- und Sekundärfarbe über ColorScheme
    colorScheme: ColorScheme.light(
      primary: AppColors.calmMint,
      secondary: AppColors.gentleAccent,
      surface: AppColors.background, // ersetzt deprecated background
      onSurface: AppColors.textPrimary, // ersetzt deprecated onBackground
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
