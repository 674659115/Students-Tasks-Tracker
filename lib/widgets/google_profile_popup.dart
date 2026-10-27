import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../pages/settings_screen.dart';
import '../pages/sign_in_screen.dart';
import '../theme/app_theme.dart';

void showGoogleProfilePopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const GoogleProfilePopupDialog(),
  );
}

class GoogleProfilePopupDialog extends StatefulWidget {
  const GoogleProfilePopupDialog({super.key});

  @override
  State<GoogleProfilePopupDialog> createState() =>
      _GoogleProfilePopupDialogState();
}

class _GoogleProfilePopupDialogState extends State<GoogleProfilePopupDialog> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, currentLang, child) {
        final bool isDark = themeNotifier.value == ThemeMode.dark;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBgDark : Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Close Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: isDark
                              ? AppColors.textMutedDark
                              : const Color(0xFF64748B),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Students Task Tracker',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 48), // Balance close button
                    ],
                  ),
                  const SizedBox(height: 8),

                  // User Avatar with edit badge
                  Stack(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                          border: Border.all(
                            color:
                                isDark ? AppColors.cardBgDark : Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const ClipOval(
                          child: Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 44,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0F172A),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // User Full Name & Email
                  Text(
                    'Sir William',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textLight
                          : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'SirWilliam@gmail.com',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textMutedDark
                          : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Manage your Profile Pill Button
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.manage_accounts_outlined, size: 18),
                    label: Text(
                      AppStrings.get('manage_profile'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? AppColors.textLight
                          : const Color(0xFF0F172A),
                      side: BorderSide(
                        color: isDark
                            ? AppColors.textMutedDark
                            : const Color(0xFFCBD5E1),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Divider(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    thickness: 1,
                  ),
                  const SizedBox(height: 8),

                  // Profile Popup Menu Options
                  _buildPopupOption(
                    isDark: isDark,
                    icon: Icons.person_add_alt_1_outlined,
                    title: 'Add or Switch Account',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    },
                  ),
                  _buildPopupOption(
                    isDark: isDark,
                    icon: Icons.settings_outlined,
                    title: AppStrings.get('settings'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildPopupOption(
                    isDark: isDark,
                    icon: Icons.dark_mode_outlined,
                    title: AppStrings.get('dark_theme'),
                    trailing: Switch.adaptive(
                      value: isDark,
                      activeTrackColor: AppColors.primary,
                      onChanged: (val) {
                        setState(() {
                          themeNotifier.value =
                              val ? ThemeMode.dark : ThemeMode.light;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        themeNotifier.value =
                            isDark ? ThemeMode.light : ThemeMode.dark;
                      });
                    },
                  ),
                  _buildPopupOption(
                    isDark: isDark,
                    icon: Icons.help_outline_rounded,
                    title: AppStrings.get('help_faqs'),
                    onTap: () {},
                  ),

                  const SizedBox(height: 8),
                  Divider(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    thickness: 1,
                  ),
                  const SizedBox(height: 8),

                  // Sign Out Option
                  _buildPopupOption(
                    isDark: isDark,
                    icon: Icons.logout_rounded,
                    title: AppStrings.get('sign_out'),
                    textColor: Colors.redAccent,
                    iconColor: Colors.redAccent,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopupOption({
    required bool isDark,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
    Color? textColor,
    Color? iconColor,
  }) {
    final effectiveTextColor = textColor ??
        (isDark ? AppColors.textLight : const Color(0xFF0F172A));
    final effectiveIconColor = iconColor ??
        (isDark ? AppColors.textMutedDark : const Color(0xFF475569));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: effectiveIconColor, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: effectiveTextColor,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
