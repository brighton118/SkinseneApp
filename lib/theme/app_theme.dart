import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors defined by the web UI
  static const Color ssCream = Color(0xFFF8F6EF);
  static const Color ssForest = Color(0xFF0E3B36);
  static const Color ssMoss = Color(0xFF187765);
  static const Color ssCoral = Color(0xFFDF6A4A);
  static const Color ssPrimaryGreen = Color(0xFF22C55E); // Tailwind green-500
  static const Color ssBlue = Color(0xFF3C82F6);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ssCream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ssForest, // Used as the base generator
        primary: ssForest,
        secondary: ssMoss,
        tertiary: ssCoral,
        surface: ssCream,
        error: ssCoral,
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Georgia', color: ssForest),
        displayMedium: TextStyle(fontFamily: 'Georgia', color: ssForest),
        displaySmall: TextStyle(fontFamily: 'Georgia', color: ssForest),
        headlineLarge: TextStyle(fontFamily: 'Georgia', color: ssForest, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontFamily: 'Georgia', color: ssForest, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontFamily: 'Georgia', color: ssForest, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontFamily: 'Georgia', color: ssForest, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: ssForest),
        bodyMedium: TextStyle(color: ssForest),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: ssCream,
        foregroundColor: ssForest,
        titleTextStyle: TextStyle(
          fontFamily: 'Georgia',
          color: ssForest,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: ssForest),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ssPrimaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ssForest,
          side: const BorderSide(color: ssForest, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ssBlue,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: ssForest),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: ssForest, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
