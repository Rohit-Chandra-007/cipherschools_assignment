import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const backgroundColor = Color(0xffFCFCFC);
  static const statusBarColor = Color(0xffFFF6E5);
  static const transparent = Colors.transparent;

  // Base Colors (100% Opacity)
  static const dark100 = Color(0xFF0D0E0F);
  static const light100 = Color(0xFFFFFFFF);
  static const violet100 = Color(0xFF7F3DFF);
  static const red100 = Color(0xFFFD3C4A);
  static const green100 = Color(0xFF00A86B);
  static const yellow100 = Color(0xFFFCAC12);
  static const blue100 = Color(0xFF0077FF);

  // Dark shades (derived from dark100)
  static final Color dark75 = dark100.withAlpha(191); // 75%
  static final Color dark50 = dark100.withAlpha(128); // 50%
  static final Color dark25 = dark100.withAlpha(64); // 25%

  // Light shades (derived from light100)
  static final Color light80 = light100.withAlpha(204); // 80%
  static final Color light60 = light100.withAlpha(153); // 60%
  static final Color light40 = light100.withAlpha(102); // 40%
  static final Color light20 = light100.withAlpha(51); // 20%

  // Violet shades (derived from violet100)
  static final Color violet80 = violet100.withAlpha(204); // 80%
  static final Color violet60 = violet100.withAlpha(153); // 60%
  static final Color violet40 = violet100.withAlpha(102); // 40%
  static final Color violet20 = violet100.withAlpha(51); // 20%

  // Red shades (derived from red100)
  static final Color red80 = red100.withAlpha(204); // 80%
  static final Color red60 = red100.withAlpha(153); // 60%
  static final Color red40 = red100.withAlpha(102); // 40%
  static final Color red20 = red100.withAlpha(51); // 20%

  // Green shades (derived from green100)
  static final Color green80 = green100.withAlpha(204); // 80%
  static final Color green60 = green100.withAlpha(153); // 60%
  static final Color green40 = green100.withAlpha(102); // 40%
  static final Color green20 = green100.withAlpha(51); // 20%

  // Yellow shades (derived from yellow100)
  static final Color yellow80 = yellow100.withAlpha(204); // 80%
  static final Color yellow60 = yellow100.withAlpha(153); // 60%
  static final Color yellow40 = yellow100.withAlpha(102); // 40%
  static final Color yellow20 = yellow100.withAlpha(51); // 20%

  // Blue shades (derived from blue100)
  static final Color blue80 = blue100.withAlpha(204); // 80%
  static final Color blue60 = blue100.withAlpha(153); // 60%
  static final Color blue40 = blue100.withAlpha(102); // 40%
  static final Color blue20 = blue100.withAlpha(51); // 20%
}
