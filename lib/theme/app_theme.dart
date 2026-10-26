import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFE8F1FF);
  static const Color primary = Color(0xFF0D66C2);
  static const Color primaryDark = Color(0xFF0052A3);
  static const Color cardBg = Colors.white;
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textBlue = Color(0xFF0D66C2);

  // Priority colors
  static const Color priorityLow = Color(0xFF4CAF50);
  static const Color priorityMedium = Color(0xFFFFB300);
  static const Color priorityHigh = Color(0xFFF44336);

  // Course theme colors
  static const Color courseBlue = Color(0xFF1D61E7);
  static const Color courseOrange = Color(0xFFE07A48);
  static const Color courseGreen = Color(0xFF4CAF50);
  static const Color courseBrown = Color(0xFF8D3C2A);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        surface: AppColors.background,
      ),
      fontFamily: 'Roboto',
    );
  }
}
