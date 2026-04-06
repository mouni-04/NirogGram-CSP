import 'package:flutter/material.dart';

const kPrimary = Color(0xFF00897B);   // teal
const kSecondary = Color(0xFF26C6DA); // cyan accent
const kAccent = Color(0xFFFF7043);    // deep orange
const kBg = Color(0xFFF0F7F6);

ThemeData buildAppTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimary,
      primary: kPrimary,
      secondary: kSecondary,
      tertiary: kAccent,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: kBg,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: kPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 3,
      shadowColor: kPrimary.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kPrimary.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kPrimary.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimary, width: 2),
      ),
      prefixIconColor: kPrimary,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
      titleLarge: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
      bodyMedium: TextStyle(color: Color(0xFF4A4A6A)),
    ),
  );
}
