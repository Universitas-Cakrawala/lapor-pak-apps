import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const civicBlue = Color(0xFF0D4A8A);
  static const amber = Color(0xFFF5A623);
  static const background = Color(0xFFF5F7FA);

  static const statusMenungguBg = Color(0xFFFEF3C7);
  static const statusMenungguFg = Color(0xFF92400E);
  static const statusDiprosesBg = Color(0xFFDBEAFE);
  static const statusDiprosesFg = Color(0xFF1E40AF);
  static const statusSelesaiBg = Color(0xFFD1FAE5);
  static const statusSelesaiFg = Color(0xFF065F46);
}

ThemeData buildAppTheme() {
  final baseTextTheme = GoogleFonts.interTextTheme();
  
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.civicBlue,
      primary: AppColors.civicBlue,
      secondary: AppColors.amber,
      surface: Colors.white,
    ),
    textTheme: baseTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.civicBlue,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.civicBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.civicBlue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );
}
