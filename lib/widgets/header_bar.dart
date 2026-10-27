import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'google_profile_popup.dart';
import 'notifications_modal.dart';

class HeaderBar extends StatelessWidget {
  final String title;
  final String? subtitle;

  const HeaderBar({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDarkMode(context);
    final cardBg = isDark ? AppColors.cardBgDark : Colors.white;
    final textPrimary = isDark ? AppColors.textLight : const Color(0xFF0F172A);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title & Subtitle Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subtitle != null) ...[
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textMutedDark : const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 2),
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          // Action Icons (Bell Notification & Avatar)
          Row(
            children: [
              // Notification Bell Card (Clickable to show Notifications Modal)
              GestureDetector(
                onTap: () => showNotificationsModal(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Icon(
                            Icons.notifications_none_outlined,
                            size: 24,
                            color: textPrimary,
                          ),
                          Positioned(
                            right: 1,
                            top: 1,
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // User Avatar (Clickable to show Google Profile Popup)
              GestureDetector(
                onTap: () => showGoogleProfilePopup(context),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.cardBgDark : Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Container(
                      color: const Color(0xFF0D66C2),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
