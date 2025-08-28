import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color.dart';

class ThemeDataConfig {
  static final ColorScheme _colorScheme =  ColorScheme.fromSeed(
    seedColor: AppColor.primary,
    surface: AppColor.background,
    brightness: Brightness.light,
    primary: AppColor.primary,
    secondary: AppColor.secondary,
  );

  static  ThemeData get themeData {
    return ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: _colorScheme.surface,
      sliderTheme: SliderThemeData(
        activeTrackColor:
            _colorScheme.primary, 
        inactiveTrackColor: _colorScheme.primary
            .withAlpha(76), 
        thumbColor: _colorScheme.primary, // Thumb matches primary color
        overlayColor: _colorScheme.primary
            .withAlpha(90),
        trackHeight: 5.0, 
        thumbShape: SliderComponentShape.noThumb,
        disabledActiveTrackColor:
            _colorScheme.primary.withAlpha(200),
      ),
      useMaterial3: true,
    );
  }
}
