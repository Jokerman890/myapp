import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const darkBlue = Color(0xFF1A1F36);
  static const darkPurple = Color(0xFF2A2353);
  
  // Secondary Colors
  static const turquoise = Color(0xFF00C2C7);
  
  // Accent Colors
  static const metalGold = Color(0xFFD39F5E);
  
  // Text Colors
  static const white = Color(0xFFFFFFFF);
  static const lightGray = Color(0xFFE0E0E0);

  // Gradients
  static final primaryGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      darkBlue,
      darkPurple,
    ],
  );

  // Transparent Colors for Glass Effect
  static final glassWhite = Colors.white.withOpacity(0.1);
  static final glassBorder = Colors.white.withOpacity(0.2);
  static final glassHighlight = Colors.white.withOpacity(0.4);
}
