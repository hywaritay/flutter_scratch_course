import 'package:flutter/material.dart';

class AppColors {
  // Light theme colors
  static const Color primary = Color(0xFF004346); // Blue
  static const Color secondary = Color(0xFF0F172A); // Dark text
  static const Color background = Color.fromARGB(
    255,
    231,
    233,
    235,
  ); // Light background
  static const Color hint = Color(0xFF64748B); // Gray
  static const Color error = Color(0xFFDC2626);

  // Dark theme colors
  static const Color darkPrimary = Color(
    0xFF00ACC1,
  ); // Lighter blue for dark theme
  static const Color darkSecondary = Color(
    0xFFE0E0E0,
  ); // Light text for dark theme
  static const Color darkBackground = Color(0xFF121212); // Dark background
  static const Color darkSurface = Color(0xFF1E1E1E); // Dark surface
  static const Color darkHint = Color(0xFF9E9E9E); // Gray for dark theme
}
