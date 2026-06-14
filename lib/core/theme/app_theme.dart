import 'package:flutter/material.dart';

import 'package:kairo/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.background,

    primaryColor: AppColors.primary,

    fontFamily: 'Roboto',

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,

      secondary: AppColors.secondary,

      surface: AppColors.background,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,

      elevation: 0,

      centerTitle: false,

      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,

        fontSize: 22,

        fontWeight: FontWeight.bold,
      ),

      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),

    cardTheme: CardThemeData(
      color: AppColors.card,

      elevation: 0,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.textPrimary,

        fontSize: 34,

        fontWeight: FontWeight.bold,
      ),

      headlineMedium: TextStyle(
        color: AppColors.textPrimary,

        fontSize: 26,

        fontWeight: FontWeight.bold,
      ),

      bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 16),

      bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,

        foregroundColor: Colors.black,

        elevation: 0,

        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,

      fillColor: AppColors.card,

      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),

        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),

        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),

        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),

      hintStyle: const TextStyle(color: AppColors.textSecondary),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,

      inactiveTrackColor: Colors.white12,

      thumbColor: AppColors.primary,

      overlayColor: AppColors.primary.withOpacity(0.2),
    ),

    dividerColor: Colors.white12,
  );
}
