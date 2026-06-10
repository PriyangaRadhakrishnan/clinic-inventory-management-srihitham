import 'package:flutter/material.dart';

class AppColors {
  // Olive Green + White Theme Color Palette
  static const Color primary = Color(0xFF4E6B34); // Elegant Olive Green
  static const Color onPrimary = Colors.white;
  static const Color primaryContainer = Color(0xFFD0ECB5); // Soft Light Sage Green
  static const Color onPrimaryContainer = Color(0xFF112004);

  static const Color secondary = Color(0xFF5B624E); // Sage Gray
  static const Color onSecondary = Colors.white;
  static const Color secondaryContainer = Color(0xFFE0E5D5);
  static const Color onSecondaryContainer = Color(0xFF181E11);

  static const Color tertiary = Color(0xFF3B665E); // Mint/Teal Muted Green
  static const Color onTertiary = Colors.white;
  static const Color tertiaryContainer = Color(0xFFBCECE1);
  static const Color onTertiaryContainer = Color(0xFF00201B);

  // Background and Surfaces
  static const Color background = Color(0xFFF9FAF7); // Soft Clinic White
  static const Color onBackground = Color(0xFF1A1C18);
  static const Color surface = Colors.white; // Pure white surface cards
  static const Color onSurface = Color(0xFF1A1C18);
  static const Color surfaceVariant = Color(0xFFE1E4D9); // Muted card details
  static const Color onSurfaceVariant = Color(0xFF44483E);

  // Status & Utility Colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Colors.white;
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);

  static const Color outline = Color(0xFF75796E);
  static const Color shadow = Color(0x0A000000); // Super subtle shadows for clean cards
  static const Color border = Color(0xFFE4E8DF); // Light border outline

  // Role based badges/indicators
  static const Color adminBadge = Color(0xFF1E3A8A); // Blue for Admin
  static const Color adminBadgeBg = Color(0xFFDBEAFE);
  static const Color staffBadge = Color(0xFF065F46); // Green for Staff
  static const Color staffBadgeBg = Color(0xFFD1FAE5);
}
