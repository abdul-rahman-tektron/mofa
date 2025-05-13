import 'package:flutter/material.dart';
import 'package:mofa/res/app_colors.dart';

class AppTheme {
  // Define the primary and accent colors
  static const Color primaryColor = AppColors.primaryColor;
  static const Color accentColor = AppColors.textColor;

  // Define the light theme
  static final ThemeData theme = ThemeData(
    fontFamily: 'Lexend',
    useMaterial3: true,
    primaryColor: primaryColor,
    hintColor: accentColor,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: primaryColor,
      toolbarTextStyle: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ).bodyMedium,
      titleTextStyle: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ).titleLarge,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black54),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
