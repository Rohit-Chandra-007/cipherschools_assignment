import 'package:cipherschools_assignment/features/home/presentation/screens/home_screen.dart';
import 'package:cipherschools_assignment/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: AppTheme.lightThemeMode, // Apply the light theme
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(), // Set HomeScreen as the initial route
    );
  }
}
