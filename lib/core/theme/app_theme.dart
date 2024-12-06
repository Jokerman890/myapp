import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBlue,
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        displayMedium: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        displaySmall: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.white,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.lightGray,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.turquoise.withOpacity(0.2),
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: AppColors.turquoise.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.glassWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.glassBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.turquoise.withOpacity(0.5),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(16),
        hintStyle: GoogleFonts.inter(
          color: AppColors.lightGray.withOpacity(0.7),
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.white,
        size: 24,
      ),

      // Dropdown Theme
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: GoogleFonts.inter(
          color: AppColors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
