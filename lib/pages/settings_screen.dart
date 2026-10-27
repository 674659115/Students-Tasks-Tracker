import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/help_faqs_modal.dart';
import 'reset_password_screen.dart';
import 'sign_in_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;

  // Privacy toggles
  bool _locationAccess = false;
  bool _analyticsSharing = true;
  bool _publicProfile = false;

  void _showIdentificationCheckDialog(bool isDark) {
    final passwordController = TextEditingController();
    bool obscure = true;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.cardBgDark : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Row(
                children: [
                  const Icon(Icons.verified_user_outlined, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Identity Verification',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To protect your account, please confirm your current password before resetting.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: obscure,
                    style: TextStyle(
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      hintText: 'Enter current password',
                      errorText: errorMessage,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setDialogState(() => obscure = !obscure);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Demo Hint: Enter "password123" or your account password.',
                    style: const TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppStrings.get('cancel')),
                ),
                ElevatedButton(
                  onPressed: () {
                    final text = passwordController.text.trim();
                    if (text.isEmpty) {
                      setDialogState(() {
                        errorMessage = 'Please enter your password.';
                      });
                    } else {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPasswordScreen(),
                        ),
                      );
                    }
                  },
                  child: const Text('Verify & Continue'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditProfileDialog(bool isDark) {
    final currentUser = AuthService.currentUser;
    final nameController = TextEditingController(text: currentUser?.name ?? 'Sir William');
    final emailController = TextEditingController(text: currentUser?.email ?? 'SirWilliam@gmail.com');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.cardBgDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            AppStrings.get('edit_profile'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: isDark ? AppColors.textLight : AppColors.textDark),
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                style: TextStyle(color: isDark ? AppColors.textLight : AppColors.textDark),
                decoration: const InputDecoration(labelText: 'Email Address'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.get('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedUser = UserModel(
                  id: currentUser?.id ?? '1',
                  name: nameController.text.trim().isEmpty
                      ? (currentUser?.name ?? 'Sir William')
                      : nameController.text.trim(),
                  email: emailController.text.trim().isEmpty
                      ? (currentUser?.email ?? 'SirWilliam@gmail.com')
                      : emailController.text.trim(),
                );
                AuthService.saveSession(updatedUser);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully!')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.cardBgDark : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Text(
                AppStrings.get('privacy_permissions'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile.adaptive(
                    title: Text(
                      'Location Access',
                      style: TextStyle(
                        color: isDark ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                    subtitle: const Text('For campus deadline reminders'),
                    value: _locationAccess,
                    onChanged: (val) {
                      setDialogState(() => _locationAccess = val);
                      setState(() => _locationAccess = val);
                    },
                  ),
                  SwitchListTile.adaptive(
                    title: Text(
                      'Share Usage Analytics',
                      style: TextStyle(
                        color: isDark ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                    subtitle: const Text('Helps improve app performance'),
                    value: _analyticsSharing,
                    onChanged: (val) {
                      setDialogState(() => _analyticsSharing = val);
                      setState(() => _analyticsSharing = val);
                    },
                  ),
                  SwitchListTile.adaptive(
                    title: Text(
                      'Public Profile Visibility',
                      style: TextStyle(
                        color: isDark ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                    subtitle: const Text('Allow classmates to see your courses'),
                    value: _publicProfile,
                    onChanged: (val) {
                      setDialogState(() => _publicProfile = val);
                      setState(() => _publicProfile = val);
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy settings saved!')),
                    );
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLanguageDialog(bool isDark) {
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Language changed to $lang')),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showAboutDialog(bool isDark) {
    showAboutDialog(
      context: context,
      applicationName: 'Students Task Tracker',
      applicationVersion: 'v1.0.0 (Build 1)',
      applicationIcon: const Icon(Icons.school_rounded, size: 48, color: AppColors.primary),
      children: const [
        Text(
          'Students Task Tracker is an all-in-one productivity app designed to help university and college students manage assignments, track deadlines, monitor course progress, and stay organized.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, currentLang, child) {
        final bool isDark = themeNotifier.value == ThemeMode.dark;

        return ValueListenableBuilder<UserModel?>(
          valueListenable: AuthService.currentUserNotifier,
          builder: (context, user, child) {
            final userName = user?.name ?? 'Sir William';
            final userEmail = user?.email ?? 'SirWilliam@gmail.com';

            return Scaffold(
              backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Bar with Back Button
                      Row(
                        children: [
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
                          ),
                          const SizedBox(width: 16),
                          Text(
                            AppStrings.get('settings'),
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: isDark ? AppColors.textLight : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // User Profile Info Card
                      GestureDetector(
                        onTap: () => _showEditProfileDialog(isDark),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardBgDark : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 34,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? AppColors.textLight
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      userEmail,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: isDark
                                            ? AppColors.textMutedDark
                                            : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.backgroundDark
                                      : AppColors.background,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section 1: Account & Security
                      _buildSectionTitle('ACCOUNT & SECURITY', isDark),
                      const SizedBox(height: 10),
                      _buildSettingsGroup([
                        _buildSettingsTile(
                          isDark: isDark,
                          icon: Icons.lock_outline_rounded,
                          title: AppStrings.get('change_password'),
                          subtitle: 'Requires security password confirmation',
                          onTap: () => _showIdentificationCheckDialog(isDark),
                        ),
                        _buildSettingsTile(
                          isDark: isDark,
                          icon: Icons.shield_outlined,
                          title: AppStrings.get('privacy_permissions'),
                          subtitle: 'Manage data & account privacy',
                          onTap: () => _showPrivacyDialog(isDark),
                        ),
                      ], isDark),
                      const SizedBox(height: 24),

                      // Section 2: Preferences
                      _buildSectionTitle('APP PREFERENCES', isDark),
                      const SizedBox(height: 10),
                      _buildSettingsGroup([
                        _buildSettingsTile(
                          isDark: isDark,
                          icon: Icons.notifications_none_outlined,
                          title: AppStrings.get('push_notifications'),
                          subtitle: 'Deadline reminders & task alerts',
                          trailing: Switch.adaptive(
                            value: _pushNotifications,
                            activeTrackColor: AppColors.primary,
                            onChanged: (val) {
                              setState(() {
                                _pushNotifications = val;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    val
                                        ? 'Push notifications enabled'
                                        : 'Push notifications disabled',
                                  ),
                                ),
                              );
                            },
                          ),
                          onTap: () {
                            setState(() {
                              _pushNotifications = !_pushNotifications;
                            });
                          },
                        ),
                        _buildSettingsTile(
                          isDark: isDark,
                          icon: Icons.dark_mode_outlined,
                          title: AppStrings.get('dark_theme'),
                          subtitle: 'Toggle dark mode layout',
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
                        _buildSettingsTile(
                          isDark: isDark,
                          icon: Icons.language_outlined,
                          title: AppStrings.get('language'),
                          subtitle: languageNotifier.value,
                          onTap: () => _showLanguageDialog(isDark),
                        ),
                      ], isDark),
                      const SizedBox(height: 24),

                      // Section 3: Help & Info
                      _buildSectionTitle('SUPPORT & ABOUT', isDark),
                      const SizedBox(height: 10),
                      _buildSettingsGroup([
                        _buildSettingsTile(
                          isDark: isDark,
                          icon: Icons.help_outline_rounded,
                          title: AppStrings.get('help_faqs'),
                          subtitle: 'Get assistance and answers',
                          onTap: () => showHelpFaqsModal(context),
                        ),
                        _buildSettingsTile(
                          isDark: isDark,
                          icon: Icons.info_outline_rounded,
                          title: AppStrings.get('about_app'),
                          subtitle: 'Version 1.0.0 (Build 1)',
                          onTap: () => _showAboutDialog(isDark),
                        ),
                      ], isDark),
                      const SizedBox(height: 28),

                      // Sign Out Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(AppStrings.get('sign_out')),
                                  content: const Text('Are you sure you want to sign out?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(AppStrings.get('cancel')),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                      ),
                                      onPressed: () {
                                        AuthService.clearSession();
                                        Navigator.pop(context);
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const SignInScreen(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      child: Text(
                                        AppStrings.get('sign_out'),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.logout_rounded, color: Colors.white),
                          label: Text(
                            AppStrings.get('sign_out'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.8,
        color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBgDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsTile({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.backgroundDark
                    : AppColors.background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textLight
                          : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textMutedDark
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null)
              trailing
            else
              Icon(
                Icons.chevron_right_rounded,
                color: isDark
                    ? AppColors.textMutedDark
                    : const Color(0xFF94A3B8),
              ),
          ],
        ),
      ),
    );
  }
}
