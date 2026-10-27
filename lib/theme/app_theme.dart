import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class AppColors {
  static const Color background = Color(0xFFE8F1FF);
  static const Color backgroundDark = Color(0xFF0F172A);
  
  static const Color primary = Color(0xFF0D66C2);
  static const Color primaryDark = Color(0xFF38BDF8);
  
  static const Color cardBg = Colors.white;
  static const Color cardBgDark = Color(0xFF1E293B);
  
  static const Color textDark = Color(0xFF0F172A);
  static const Color textLight = Color(0xFFF8FAFC);
  
  static const Color textMuted = Color(0xFF64748B);
  static const Color textMutedDark = Color(0xFF94A3B8);

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color getBg(BuildContext context) {
    return isDarkMode(context) ? backgroundDark : background;
  }

  static Color getCardBg(BuildContext context) {
    return isDarkMode(context) ? cardBgDark : Colors.white;
  }

  static Color getTextPrimary(BuildContext context) {
    return isDarkMode(context) ? textLight : textDark;
  }

  static Color getTextSecondary(BuildContext context) {
    return isDarkMode(context) ? textMutedDark : textMuted;
  }

  // Priority colors
  static const Color priorityLow = Color(0xFF4CAF50);
  static const Color priorityMedium = Color(0xFFFFB300);
  static const Color priorityHigh = Color(0xFFF44336);

  // Course theme colors
  static const Color courseBlue = Color(0xFF1D61E7);
  static const Color courseOrange = Color(0xFFE07A48);
  static const Color courseGreen = Color(0xFF4CAF50);
  static const Color courseBrown = Color(0xFF8D3C2A);
  static const Color coursePurple = Color(0xFF7C3AED);
  static const Color courseTeal = Color(0xFF0D9488);
  static const Color courseIndigo = Color(0xFF4F46E5);
  static const Color courseRose = Color(0xFFE11D48);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      cardColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        surface: AppColors.background,
      ),
      fontFamily: 'Roboto',
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardColor: AppColors.cardBgDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryDark,
        brightness: Brightness.dark,
        surface: AppColors.backgroundDark,
      ),
      fontFamily: 'Roboto',
    );
  }
}
