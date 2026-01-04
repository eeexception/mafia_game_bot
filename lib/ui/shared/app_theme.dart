import 'package:flutter/material.dart';

class AppTheme {
  static const darkBackground = Color(0xFF121212);
  static const surfaceColor = Color(0xFF1E1E1E);
  static const accentColor = Color(0xFFBB86FC);
  static const secondaryColor = Color(0xFF03DAC6);
  static const errorColor = Color(0xFFCF6679);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: accentColor,
    scaffoldBackgroundColor: darkBackground,
    cardColor: surfaceColor,
    colorScheme: const ColorScheme.dark(
      primary: accentColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      error: errorColor,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 18, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
