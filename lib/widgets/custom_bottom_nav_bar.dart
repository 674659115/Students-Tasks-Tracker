import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../theme/app_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, currentLang, child) {
        final isDark = AppColors.isDarkMode(context);
        final cardBg = isDark ? AppColors.cardBgDark : Colors.white;

        return Container(
          height: 72,
          decoration: BoxDecoration(
            color: cardBg,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.home,
                label: AppStrings.get('home'),
              ),
              _buildNavItem(
                context: context,
                index: 1,
                icon: Icons.folder_copy_outlined,
                label: AppStrings.get('courses'),
              ),
              _buildNavItem(
                context: context,
                index: 2,
                icon: Icons.calendar_today_outlined,
                label: AppStrings.get('calendar'),
              ),
              _buildNavItem(
                context: context,
                index: 3,
                icon: Icons.person,
                label: AppStrings.get('profile'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;
    final isDark = AppColors.isDarkMode(context);
    final Color activeColor = isDark ? AppColors.primaryDark : AppColors.primary;
    final Color inactiveColor = isDark ? AppColors.textMutedDark : const Color(0xFF94A3B8);

    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? activeColor : inactiveColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}
