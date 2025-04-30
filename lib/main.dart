import 'package:cipherschools_assignment/screens/home_screen.dart';
import 'package:cipherschools_assignment/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.green),
  );
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
