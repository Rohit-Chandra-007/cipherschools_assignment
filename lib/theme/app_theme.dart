import 'package:cipherschools_assignment/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

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
      backgroundColor: Color(0xFFFFF6E5),
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.dark100),
      titleTextStyle: TextStyle(
        color: AppColors.dark100,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.dark75),
      bodyMedium: TextStyle(color: AppColors.dark50),
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.dark100,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w500,
        color: AppColors.dark75,
      ),
    ),
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
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.violet100,
      unselectedItemColor: AppColors.light20,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
