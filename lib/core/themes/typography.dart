// lib/themes/typography.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.lora(fontSize: 32, fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.lora(fontSize: 20, fontWeight: FontWeight.w600),
    bodyMedium: GoogleFonts.montserrat(fontSize: 16),
    bodySmall: GoogleFonts.montserrat(fontSize: 14),
    labelLarge:
        GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600),
  );
}
