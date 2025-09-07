import 'package:flutter/material.dart';

class ThemeApp {
  static ThemeData darkTheme() {
    final theme = ThemeData.dark().copyWith(
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.blue,              // Azul principal
        onPrimary: Colors.white,           // Texto sobre azul
        secondary: Colors.lightBlueAccent, // Azul claro de acento
        onSecondary: Colors.black,         // Texto sobre acento
        error: Colors.red,
        onError: Colors.white,
        surface: Color(0xFF1E1E2C),        // Superficie oscura azulada
        onSurface: Colors.white,
      ),
    );

    return theme;
  }

  static ThemeData lightTheme() {
    final theme = ThemeData.light().copyWith(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Colors.pink,             // Rosa principal
        onPrimary: Colors.white,          // Texto sobre rosa
        secondary: Colors.pinkAccent,     // Acento
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.white,
        surface: Colors.pink[50]!,        // Superficie clara con tono rosa
        onSurface: Colors.black,
      ),
    );

    return theme;
  }
}
