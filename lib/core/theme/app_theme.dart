import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        background: AppColors.background,
        onBackground: AppColors.onBackground,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceVariant: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        shadow: AppColors.shadow,
      ),
      scaffoldBackgroundColor: AppColors.background,
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: AppDimensions.borderThickness,
        space: 1.0,
      ),
    );

    // Apply Outfit Font to TextTheme
    final outfitTextTheme = GoogleFonts.outfitTextTheme(baseTheme.textTheme).copyWith(
      displayLarge: GoogleFonts.outfit(
        textStyle: baseTheme.textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.onBackground,
        ),
      ),
      displayMedium: GoogleFonts.outfit(
        textStyle: baseTheme.textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.onBackground,
        ),
      ),
      titleLarge: GoogleFonts.outfit(
        textStyle: baseTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onBackground,
        ),
      ),
      titleMedium: GoogleFonts.outfit(
        textStyle: baseTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.onBackground,
        ),
      ),
      bodyLarge: GoogleFonts.outfit(
        textStyle: baseTheme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.normal,
          color: AppColors.onBackground,
        ),
      ),
      bodyMedium: GoogleFonts.outfit(
        textStyle: baseTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.normal,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );

    return baseTheme.copyWith(
      textTheme: outfitTextTheme,
      primaryTextTheme: GoogleFonts.outfitTextTheme(baseTheme.primaryTextTheme),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceM,
          vertical: AppDimensions.spaceM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.border, width: AppDimensions.borderThickness),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.border, width: AppDimensions.borderThickness),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.error, width: AppDimensions.borderThickness),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.error, width: 2.0),
        ),
        labelStyle: GoogleFonts.outfit(color: AppColors.onSurfaceVariant),
        hintStyle: GoogleFonts.outfit(color: AppColors.onSurfaceVariant.withOpacity(0.6)),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          side: const BorderSide(color: AppColors.border, width: AppDimensions.borderThickness),
        ),
        margin: EdgeInsets.zero,
      ),

      // Button Themes
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spaceM,
            horizontal: AppDimensions.spaceL,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spaceM,
            horizontal: AppDimensions.spaceL,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 14.0,
          ),
        ),
      ),

      // Drawer Theme
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),

      // Navigation Drawer Theme
      navigationDrawerTheme: const NavigationDrawerThemeData(
        backgroundColor: AppColors.background,
        elevation: 0,
        indicatorColor: AppColors.primaryContainer,
      ),
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: AppColors.onBackground,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
