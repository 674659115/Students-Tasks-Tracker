import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'reset_password_screen.dart';
import 'sign_in_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  String _userName = 'Sir William';
  String _userEmail = 'SirWilliam@gmail.com';
  String _selectedLanguage = 'English (US)';

  // Privacy toggles
  bool _locationAccess = false;
  bool _analyticsSharing = true;
  bool _publicProfile = false;

  void _showEditProfileDialog(bool isDark) {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.cardBgDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            'Edit Profile',
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
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _userName = nameController.text.trim().isEmpty
                      ? _userName
                      : nameController.text.trim();
                  _userEmail = emailController.text.trim().isEmpty
                      ? _userEmail
                      : emailController.text.trim();
                });
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
                'Privacy & Permissions',
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
      'Español (Spanish)',
      'Français (French)',
      'Deutsch (German)',
      'ภาษาไทย (Thai)',
      '中文 (Chinese)',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.cardBgDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            'Select App Language',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: languages.map((lang) {
                final isSelected = lang == _selectedLanguage;
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
                    setState(() => _selectedLanguage = lang);
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

  void _showHelpModal(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.cardBgDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Help & FAQs',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              _buildFaqItem(
                'How do I add a new task?',
                'Tap the orange + button on the Home tab. Enter the task title, select your course, choose a due date and priority level, then tap Create Task.',
                isDark,
              ),
              _buildFaqItem(
                'How do I add deadlines to the Calendar?',
                'Go to the Calendar tab and tap "+ Add Event". You can choose any day of the month, title, and priority to show a deadline dot on the grid.',
                isDark,
              ),
              _buildFaqItem(
                'How do I track course progress?',
                'Visit the Courses tab to view progress bars, assignment completions, and test metrics for all your enrolled subjects.',
                isDark,
              ),
              _buildFaqItem(
                'Can I delete tasks or calendar items?',
                'Yes! Every task card on Home and deadline card on Calendar features a red trash icon. Tapping it instantly removes the item.',
                isDark,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFaqItem(String question, String answer, bool isDark) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.textLight : AppColors.textDark,
          fontSize: 15,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            answer,
            style: TextStyle(
              color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
              fontSize: 14,
            ),
          ),
        ),
      ],
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
    final bool isDark = themeNotifier.value == ThemeMode.dark;

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
                    'Settings',
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
                              _userName,
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
                              _userEmail,
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
                  title: 'Change Password',
                  subtitle: 'Update your security credentials',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPasswordScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingsTile(
                  isDark: isDark,
                  icon: Icons.shield_outlined,
                  title: 'Privacy & Permissions',
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
                  title: 'Push Notifications',
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
                  title: 'Dark Theme',
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
                  title: 'Language',
                  subtitle: _selectedLanguage,
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
                  title: 'Help & FAQs',
                  subtitle: 'Get assistance and answers',
                  onTap: () => _showHelpModal(isDark),
                ),
                _buildSettingsTile(
                  isDark: isDark,
                  icon: Icons.info_outline_rounded,
                  title: 'About Students Task Tracker',
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
                          title: const Text('Sign Out'),
                          content: const Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                'Sign Out',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(
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
