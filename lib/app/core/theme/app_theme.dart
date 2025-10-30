import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Classe contenant la configuration du thème de l'application.
///
/// Centralise les couleurs, polices et autres styles pour garantir
/// une cohérence visuelle à travers toute l'application.
class AppTheme {
  // Couleurs principales basées sur les maquettes
  static const Color primary = Color(0xFF003366);
  static const Color backgroundLight = Color(0xFFF5F7F8);
  static const Color backgroundDark = Color(0xFF0F1923);
  static const Color senegaleseOrange = Color(0xFFE85A24);
  static const Color errorRed = Color(0xFFD32F2F);

  // Thème pour le mode clair
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundLight,
    fontFamily: GoogleFonts.lexend().fontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundLight,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: senegaleseOrange,
      error: errorRed,
      background: backgroundLight,
    ),
  );

  // Thème pour le mode sombre
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundDark,
    fontFamily: GoogleFonts.lexend().fontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: senegaleseOrange,
      error: errorRed,
      background: backgroundDark,
    ),
  );
}