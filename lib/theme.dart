import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeDataConfig {
  static final ColorScheme _colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xfff83758),
    surface: const Color(0xFFF9F9F9),
    brightness: Brightness.light,
    primary: const Color(0xfff83758),
    secondary: const Color(0xFF4392F9),
  );

  static ThemeData get themeData {
    return ThemeData(

      fontFamily: GoogleFonts.poppins().fontFamily,

      colorScheme: _colorScheme,
      scaffoldBackgroundColor: _colorScheme.surface,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        titleSmall: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.roboto(
          fontWeight: FontWeight.normal,
        ),
        titleLarge:
        GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 34),
        labelSmall: GoogleFonts.roboto(
          fontWeight: FontWeight.normal,
          color: const Color(-11053225),
        ),
        labelMedium: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4392F9),
            fontSize: 16),
        labelLarge: GoogleFonts.roboto(
            fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14),
        bodySmall: GoogleFonts.roboto(
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            color: Colors.white),
      ),
      sliderTheme: SliderThemeData(
          activeTrackColor: _colorScheme.primary, // Matches primary color (main brand color)
          inactiveTrackColor: _colorScheme.primary.withAlpha(76), // Lighter version for inactive track
          thumbColor: _colorScheme.primary, // Thumb matches primary color
          overlayColor: _colorScheme.primary.withAlpha(90), // Subtle glow effect when sliding
          trackHeight: 5.0, // Adjust track thickness
          thumbShape: SliderComponentShape.noThumb, // Remove thumb if needed
          disabledActiveTrackColor: _colorScheme.primary.withAlpha(200), // Disabled state still visible
      ),
      useMaterial3: true,
    );
  }
}