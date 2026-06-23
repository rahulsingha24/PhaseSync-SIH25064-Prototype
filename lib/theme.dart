import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Phase 2 Color Palette
  static const Color bgLight = Color(0xFFF9FAFB);
  static const Color bgDark = Color(0xFF121212);
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color textLight = Color(
    0xFF1F2937,
  ); // Dark gray for text on light
  static const Color textDark = Color(
    0xFFE5E7EB,
  ); // Light gray for text on dark

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: primaryBlue,
    scaffoldBackgroundColor: bgLight,
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.light().textTheme,
    ).apply(bodyColor: textLight, displayColor: textLight),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFFE5E7EB),
          width: 1,
        ), // Subtle border
      ),
      color: Colors.white,
      shadowColor: Colors.black.withAlpha(10), // Very soft shadow
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: bgLight,
      foregroundColor: textLight,
      elevation: 0,
      centerTitle: true,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Colors.transparent, // Removing the capsule indicator
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: primaryBlue);
        }
        return const IconThemeData(color: Color(0xFF9CA3AF)); // Unselected gray
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: primaryBlue,
          );
        }
        return GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF9CA3AF),
        );
      }),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: primaryBlue,
    scaffoldBackgroundColor: bgDark,
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: textDark, displayColor: textDark),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF374151), width: 1),
      ),
      color: const Color(0xFF1E1E1E),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: bgDark,
      foregroundColor: textDark,
      elevation: 0,
      centerTitle: true,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      indicatorColor: Colors.transparent,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: primaryBlue);
        }
        return const IconThemeData(color: Color(0xFF9CA3AF));
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: primaryBlue,
          );
        }
        return GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF9CA3AF),
        );
      }),
    ),
  );
}
