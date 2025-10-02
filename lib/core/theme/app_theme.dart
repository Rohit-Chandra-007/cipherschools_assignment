import 'package:cipherschools_assignment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static final _textTheme = GoogleFonts.fredokaTextTheme(
    ThemeData.light().textTheme.copyWith(
      bodyLarge: GoogleFonts.fredoka(color: AppColors.dark75, fontSize: 18),
      bodyMedium: GoogleFonts.fredoka(color: AppColors.dark75, fontSize: 16),
      bodySmall: GoogleFonts.fredoka(color: AppColors.dark75, fontSize: 14),
      titleLarge: GoogleFonts.fredoka(
        fontWeight: FontWeight.w600,
        color: AppColors.dark100,
        fontSize: 32,
      ),
      titleMedium: GoogleFonts.fredoka(
        fontWeight: FontWeight.w600,
        color: AppColors.light100,
        fontSize: 24,
      ),
      titleSmall: GoogleFonts.fredoka(
        fontWeight: FontWeight.w500,
        color: AppColors.light100,
        fontSize: 18,
      ),
      labelLarge: GoogleFonts.fredoka(
        fontWeight: FontWeight.w400,
        color: AppColors.dark100,
      ),
      labelMedium: GoogleFonts.fredoka(
        fontWeight: FontWeight.w400,
        color: AppColors.dark75,
      ),
      labelSmall: GoogleFonts.fredoka(
        fontWeight: FontWeight.w400,
        color: AppColors.dark25,
      ),
    ),
  );

  // Add this TabBarTheme
  static final _tabBarTheme = TabBarThemeData(
    indicatorSize: TabBarIndicatorSize.tab,
    dividerHeight: 0.0,
    splashFactory: NoSplash.splashFactory,
    labelPadding: const EdgeInsets.symmetric(horizontal: 24),
    overlayColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      // When pressed, show purple splash color
      if (states.contains(WidgetState.pressed)) {
        return AppColors.backgroundColor; // Purple with opacity
      }
      if (states.contains(WidgetState.focused)) {
        return AppColors.transparent; // Purple with opacity
      }
      return null; // Use default for other states
    }),

    labelColor: AppColors.yellow100, // Purple text for selected tab
    unselectedLabelColor: AppColors.dark50, // Gray text for unselected tabs,

    labelStyle: _textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
    unselectedLabelStyle: _textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.normal,
      backgroundColor: Colors.transparent,
    ),
    indicator: BoxDecoration(
      color: AppColors.yellow20, // White background for selected tab
      borderRadius: BorderRadius.circular(24),
    ),

    indicatorColor: Colors.transparent,
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.violet100,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    cardTheme: CardThemeData(
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.violet100,
      unselectedItemColor: AppColors.light20,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    // Add the TabBarTheme here
    tabBarTheme: _tabBarTheme,
  );
}
