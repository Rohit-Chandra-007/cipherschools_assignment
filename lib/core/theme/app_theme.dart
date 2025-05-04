import 'package:cipherschools_assignment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import

class AppTheme {
  AppTheme._();

  static final _textTheme = GoogleFonts.interTextTheme(
    ThemeData.light().textTheme.copyWith(
      bodyLarge: GoogleFonts.inter(color: AppColors.dark75, fontSize: 16),
      bodyMedium: GoogleFonts.inter(color: AppColors.dark75, fontSize: 16),
      bodySmall: GoogleFonts.inter(color: AppColors.dark75, fontSize: 14),
      titleLarge: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        color: AppColors.dark100,
        fontSize: 40,
      ),
      titleMedium: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        color: AppColors.light100,
        fontSize: 24,
      ),
      titleSmall: GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        color: AppColors.light100,
        fontSize: 18,
      ),
      labelLarge: GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        color: AppColors.dark100,
      ),
      labelMedium: GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        color: AppColors.dark75,
      ),
      labelSmall: GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        color: AppColors.dark25,
      ),
    ),
  );

  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.backgroundColor,
    primaryColor: AppColors.violet100,
    colorScheme: const ColorScheme.light(
      primary: AppColors.violet100,
      secondary: AppColors.blue100,
      error: AppColors.red100,
      surface: AppColors.backgroundColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
      onSurface: AppColors.dark100,
    ),
    appBarTheme: const AppBarTheme(
      toolbarHeight: 0,
      backgroundColor: AppColors.statusBarColor,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.dark100),
      titleTextStyle: TextStyle(
        color: AppColors.dark100,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    // Merge GoogleFonts theme with existing custom styles
    textTheme: _textTheme,
    iconTheme: const IconThemeData(color: AppColors.violet100),
    cardTheme: CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.violet100,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.violet100,
      unselectedItemColor: AppColors.light20,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
