import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../theme/app_theme.dart';

class AuthQuickHeader extends StatelessWidget {
  final bool showBackButton;

  const AuthQuickHeader({
    super.key,
    this.showBackButton = true,
  });

  void _showLanguageDialog(BuildContext context, bool isDark) {
    final languages = [
      'English (US)',
      'ภาษาไทย (Thai)',
      'Español (Spanish)',
      'Français (French)',
      'Deutsch (German)',
      '中文 (Chinese)',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.cardBgDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            AppStrings.get('language'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: languages.map((lang) {
                final isSelected = lang == languageNotifier.value;
                return ListTile(
                  title: Text(
                    lang,
                    style: TextStyle(
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                      : null,
                  onTap: () {
                    languageNotifier.value = lang;
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, currentLang, child) {
        final isDark = AppColors.isDarkMode(context);

        // Friendly short name for button text
        String displayLang = currentLang.split(' ').first;
        if (currentLang.contains('Thai') || currentLang.contains('ไทย')) {
          displayLang = 'ภาษาไทย';
        } else if (currentLang.contains('Spanish') || currentLang.contains('Español')) {
          displayLang = 'Español';
        } else if (currentLang.contains('French') || currentLang.contains('Français')) {
          displayLang = 'Français';
        } else if (currentLang.contains('German') || currentLang.contains('Deutsch')) {
          displayLang = 'Deutsch';
        } else if (currentLang.contains('Chinese') || currentLang.contains('中文')) {
          displayLang = '中文';
        } else {
          displayLang = 'English';
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showBackButton && Navigator.canPop(context))
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardBgDark : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
              )
            else
              const SizedBox(width: 44),

            Row(
              children: [
                // Quick Language Button
                GestureDetector(
                  onTap: () => _showLanguageDialog(context, isDark),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardBgDark : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.language_rounded, size: 20, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          displayLang,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textLight : AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Quick Dark Mode Toggle Button
                GestureDetector(
                  onTap: () {
                    themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardBgDark : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Icon(
                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      size: 20,
                      color: isDark ? Colors.amber : const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
