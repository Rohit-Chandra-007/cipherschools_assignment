import 'package:cipherschools_assignment/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.backgroundColor,
  );
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.violet80, // Violet 80
      onPrimary: Color(0xffFCFCFC),
      secondary: Color(0xFF4CAF50), // Green 80
      onSecondary: Colors.white,
      error: Color(0xFFE53935), // Red 80
      background: Color(0xFFF5F5F5), // Light 20
      surface: Colors.white,
      onSurface: Color(0xFF1C1B1F), // Dark 100
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1C1B1F),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    fontFamily: 'Inter',
    textTheme: TextTheme(
      // Title X - 64/80
      displayLarge: TextStyle(
        fontSize: 64,
        height: 1.25,
        fontWeight: FontWeight.w700,
      ),
      // Title 1 - 32/34
      displayMedium: TextStyle(
        fontSize: 32,
        height: 1.0625,
        fontWeight: FontWeight.w700,
      ),
      // Title 2 - 24/22
      displaySmall: TextStyle(
        fontSize: 24,
        height: 0.9167,
        fontWeight: FontWeight.w700,
      ),
      // Title 3 - 18/22
      headlineLarge: TextStyle(
        fontSize: 18,
        height: 1.2222,
        fontWeight: FontWeight.w600,
      ),
      // Regular 1 - 16/19
      headlineMedium: TextStyle(
        fontSize: 16,
        height: 1.1875,
        fontWeight: FontWeight.w500,
      ),
      // Regular 2 - 16/19
      headlineSmall: TextStyle(
        fontSize: 16,
        height: 1.1875,
        fontWeight: FontWeight.w400,
      ),
      // Regular 3 - 14/18
      titleLarge: TextStyle(
        fontSize: 14,
        height: 1.2857,
        fontWeight: FontWeight.w500,
      ),
      // Small - 13/16
      titleMedium: TextStyle(
        fontSize: 13,
        height: 1.2308,
        fontWeight: FontWeight.w400,
      ),
      // Tiny - 12/12
      titleSmall: TextStyle(
        fontSize: 12,
        height: 1.0,
        fontWeight: FontWeight.w400,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: AppColors.dark20, fontSize: 18),
      contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF9D8DFF), // Violet 60
      onPrimary: Colors.white,
      secondary: Color(0xFF81C784), // Green 60
      onSecondary: Colors.white,
      error: Color(0xFFEF5350), // Red 60
      background: Color(0xFF1C1B1F), // Dark 100
      surface: Color(0xFF2D2C31), // Dark 75
      onSurface: Color(0xFFF5F5F5), // Light 20
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF1C1B1F),
      foregroundColor: Color(0xFFF5F5F5),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    fontFamily: 'Inter',
    textTheme: TextTheme(
      // Title X - 64/80
      displayLarge: TextStyle(
        fontSize: 64,
        height: 1.25,
        fontWeight: FontWeight.w700,
      ),
      // Title 1 - 32/34
      displayMedium: TextStyle(
        fontSize: 32,
        height: 1.0625,
        fontWeight: FontWeight.w700,
      ),
      // Title 2 - 24/22
      displaySmall: TextStyle(
        fontSize: 24,
        height: 0.9167,
        fontWeight: FontWeight.w700,
      ),
      // Title 3 - 18/22
      headlineLarge: TextStyle(
        fontSize: 18,
        height: 1.2222,
        fontWeight: FontWeight.w600,
      ),
      // Regular 1 - 16/19
      headlineMedium: TextStyle(
        fontSize: 16,
        height: 1.1875,
        fontWeight: FontWeight.w500,
      ),
      // Regular 2 - 16/19
      headlineSmall: TextStyle(
        fontSize: 16,
        height: 1.1875,
        fontWeight: FontWeight.w400,
      ),
      // Regular 3 - 14/18
      titleLarge: TextStyle(
        fontSize: 14,
        height: 1.2857,
        fontWeight: FontWeight.w500,
      ),
      // Small - 13/16
      titleMedium: TextStyle(
        fontSize: 13,
        height: 1.2308,
        fontWeight: FontWeight.w400,
      ),
      // Tiny - 12/12
      titleSmall: TextStyle(
        fontSize: 12,
        height: 1.0,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
