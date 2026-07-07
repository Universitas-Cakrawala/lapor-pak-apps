import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // From DESIGN.md
  static const civicBlue = Color(0xFF000666); // Primary Navy Blue
  static const amber = Color(0xFFFFB300); // Accent Amber
  static const background = Color(0xFFF5F5F5); // Cool light gray
  static const surface = Color(0xFFF9F9F9);
  
  static const outline = Color(0xFFE0E0E0); // Low-contrast 1px strokes

  // Status Semantic Palette
  static const statusMenungguBg = Color(0xFFFFB300); // Amber
  static const statusMenungguFg = Colors.white;
  static const statusDiprosesBg = Color(0xFF2196F3); // Blue
  static const statusDiprosesFg = Colors.white;
  static const statusSelesaiBg = Color(0xFF4CAF50); // Green
  static const statusSelesaiFg = Colors.white;
}

/// Dark Mode color constants derived from DESIGN.md inverse-surface palette.
class AppColorsDark {
  static const background = Color(0xFF1A1C1C); // on-surface from DESIGN.md
  static const surface = Color(0xFF2F3131); // inverse-surface
  static const surfaceBright = Color(0xFF3A3D3D);
  static const outline = Color(0xFF454652); // on-surface-variant
  static const onSurface = Color(0xFFF1F1F1); // inverse-on-surface
  static const onSurfaceVariant = Color(0xFFC6C5D4); // outline-variant
}

ThemeData buildAppTheme() {
  final baseTextTheme = GoogleFonts.robotoFlexTextTheme();
  
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.civicBlue,
      brightness: Brightness.light,
      primary: AppColors.civicBlue,
      secondary: AppColors.amber,
      surface: AppColors.surface,
    ),
    textTheme: baseTextTheme.copyWith(
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 28),
      titleLarge: baseTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400, fontSize: 16),
      labelLarge: baseTextTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500, fontSize: 12),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.civicBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: AppColors.civicBlue,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0, // Flat design
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.outline, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.civicBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size.fromHeight(52), // Primary Button height
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.outline, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.outline, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.civicBlue, width: 2),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always, // Labels remain visible
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.civicBlue,
      unselectedItemColor: Colors.grey,
      elevation: 8, // Soft shadow
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.outline, width: 1),
      ),
    ),
  );
}

/// Dark theme counterpart following DESIGN.md inverse palette.
ThemeData buildDarkAppTheme() {
  final baseTextTheme = GoogleFonts.robotoFlexTextTheme(ThemeData.dark().textTheme);

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColorsDark.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.civicBlue,
      brightness: Brightness.dark,
      primary: const Color(0xFFBDC2FF), // inverse-primary from DESIGN.md
      secondary: AppColors.amber,
      surface: AppColorsDark.surface,
      onSurface: AppColorsDark.onSurface,
    ),
    textTheme: baseTextTheme.copyWith(
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 28),
      titleLarge: baseTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400, fontSize: 16),
      labelLarge: baseTextTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500, fontSize: 12),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorsDark.surface,
      foregroundColor: AppColorsDark.onSurface,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: AppColorsDark.surface,
    ),
    cardTheme: CardThemeData(
      color: AppColorsDark.surfaceBright,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColorsDark.outline, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFBDC2FF),
        foregroundColor: AppColorsDark.background,
        elevation: 0,
        minimumSize: const Size.fromHeight(52),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColorsDark.outline, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColorsDark.outline, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFBDC2FF), width: 2),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColorsDark.surface,
      selectedItemColor: const Color(0xFFBDC2FF),
      unselectedItemColor: AppColorsDark.onSurfaceVariant,
      elevation: 8,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColorsDark.surfaceBright,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColorsDark.outline, width: 1),
      ),
    ),
  );
}
