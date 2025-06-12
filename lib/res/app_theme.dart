import 'package:flutter/material.dart';
import 'package:mofa/res/app_colors.dart';

class AppTheme {
  static const Color primaryColor = AppColors.primaryColor;
  static const Color accentColor = AppColors.textColor;

  static ThemeData getTheme(String fontFamily) {
    return ThemeData(
      fontFamily: fontFamily,
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
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.buttonBgColor,
        selectionColor: AppColors.buttonBgColor.withOpacity(0.4),
        selectionHandleColor: AppColors.buttonBgColor,
      ),
    );
  }
}

