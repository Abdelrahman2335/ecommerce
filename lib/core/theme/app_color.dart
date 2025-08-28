import 'package:flutter/material.dart';

abstract class AppColor {
  static const primary = Color(0xfff83758);

  /// Main brand color (red/pink - matches ThemeDataConfig)
  static const secondary = Color(0xFF4392F9);

  /// Blue secondary color (matches ThemeDataConfig)
  static const background = Color(0xFFF9F9F9);

  /// App background (matches ThemeDataConfig surface)
  static const card = Color(0xFFFFFFFF);

  /// For cards
  static const textPrimary = Color(0xFF1E1E1E);

  /// Main title text
  static const textSecondary = Color(0xFF9E9E9E);

  /// Subtitles and descriptions
  static const accentPink = Color(0xFFFF6B6B);

  /// For progress indicators / alerts
  static const accentGreen = Color(0xFF49F988);

  /// For Background effects
  static const accentPurple = Color(0xFF9D00FC);
  static const accentTeal = Color(0xFF00B2A9);
  static const accentOrange = Color(0xFFFFA500);

  /// For progress indicators / alerts
  static const accentRed = Color(0xFFFF0000);

  static const accentLightPurple =
      Color(0xFFB9A7F9); // Light purple for time text

  // Dark theme colors
  static const darkBackground = Color(0xFF121212);
  static const darkCard = Color(0xFF1E1E1E);
  static const darkTextPrimary = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFFB3B3B3);

  /// Method to check if the current theme is dark
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Method to check system/platform brightness
  static bool isSystemDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  /// Get background color based on theme
  static Color getBackgroundColor(BuildContext context) {
    return isDarkMode(context) ? darkBackground : background;
  }

  /// Get card color based on theme
  static Color getCardColor(BuildContext context) {
    return isDarkMode(context) ? darkCard : card;
  }

  /// Get primary text color based on theme
  static Color getPrimaryTextColor(BuildContext context) {
    return isDarkMode(context) ? darkTextPrimary : textPrimary;
  }

  /// Get secondary text color based on theme
  static Color getSecondaryTextColor(BuildContext context) {
    return isDarkMode(context) ? darkTextSecondary : textSecondary;
  }
}
