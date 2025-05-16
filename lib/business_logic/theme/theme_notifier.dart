import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFFFF8E1), // Creamy sunshine
  canvasColor: Color(0xFFFFF3E0),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFFF6F00), // Flame Orange
    onPrimary: Colors.white,
    secondary: Color(0xFF9C27B0), // Vivid Purple
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: Color(0xFFFFCC80), // Toasty
    onSurface: Colors.black87,
    tertiary: Color(0xFFFFA726),
    onTertiary: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFFF6F00),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFFF9100),
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFFF9100),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black54),
    titleLarge: TextStyle(
      color: Color(0xFFE65100),
      fontWeight: FontWeight.bold,
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF121212), // Dark charcoal
  canvasColor: Color(0xFF1E1E1E),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFD32F2F), // Lava Red
    onPrimary: Colors.white,
    secondary: Color(0xFFEF6C00), // Ember Orange
    onSecondary: Colors.white,
    error: Colors.redAccent,
    onError: Colors.black,
    surface: Color(0xFF2C2C2C),
    onSurface: Colors.white70,
    tertiary: Color(0xFFBF360C),
    onTertiary: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFD32F2F),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFEF6C00),
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFD84315),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white70),
    bodyMedium: TextStyle(color: Colors.white60),
    titleLarge: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
  ),
);
