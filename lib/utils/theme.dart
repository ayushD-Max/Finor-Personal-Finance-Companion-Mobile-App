import 'package:flutter/material.dart';

class AppTheme {
  // AURA FINANCE PALETTE
  static const Color primaryColor = Color(0xFF7C4DFF); // Vibrant Purple
  static const Color secondaryColor = Color(0xFF00BCD4); // Cyan for Income/Savings
  static const Color tertiaryColor = Color(0xFFB55B00); // Orange for Alert/Goals
  static const Color errorColor = Color(0xFFFF4D4D); // Soft Red for Expenses
  
  static const Color surfaceDark = Color(0xFF13151A); // From Image 2 "Neutral"
  static const Color backgroundDark = Color(0xFF0A0E1A); // From Image 1 Deep Navy
  static const Color cardDark = Color(0xFF1E2128); // Elevated cards
  
  static const Color backgroundLight = Color(0xFFF7F9FC);
  static const Color cardLight = Colors.white;

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundLight,
    fontFamily: 'Inter',
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: cardLight,
      onSurface: Colors.black87,
      error: errorColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    cardTheme: CardThemeData(
      color: cardLight,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: cardLight,
      surfaceTintColor: cardLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundDark,
    fontFamily: 'Inter',
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: cardDark,
      onSurface: Colors.white,
      error: errorColor,
      background: backgroundDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: backgroundDark,
      surfaceTintColor: backgroundDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
    ),
  );

  static InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 14),
      prefixIcon: Icon(icon, color: primaryColor, size: 20),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}
