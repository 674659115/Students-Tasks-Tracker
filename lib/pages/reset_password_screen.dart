import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_quick_header.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'password_changed_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, currentLang, child) {
        final isDark = AppColors.isDarkMode(context);

        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthQuickHeader(),
                  const SizedBox(height: 20),

                  // Lock Icon Header
                  Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E67C6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.white,
                        size: 46,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Center(
                    child: Text(
                      AppStrings.get('reset_password_title'),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      AppStrings.get('reset_password_subtitle'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? AppColors.textMutedDark : const Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // New Password
                  CustomTextField(
                    label: AppStrings.get('new_password'),
                    hintText: '••••••••',
                    controller: _newPasswordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  CustomTextField(
                    label: AppStrings.get('confirm_password'),
                    hintText: '••••••••',
                    controller: _confirmPasswordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 28),

                  // Save Button
                  PrimaryButton(
                    text: AppStrings.get('save'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PasswordChangedScreen(),
                        ),
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
}
