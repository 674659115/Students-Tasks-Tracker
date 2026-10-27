import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_quick_header.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'forgot_password_email_screen.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordPhoneScreen extends StatefulWidget {
  const ForgotPasswordPhoneScreen({super.key});

  @override
  State<ForgotPasswordPhoneScreen> createState() => _ForgotPasswordPhoneScreenState();
}

class _ForgotPasswordPhoneScreenState extends State<ForgotPasswordPhoneScreen> {
  final _phoneController = TextEditingController(text: '061XXXXX93');

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
                      AppStrings.get('forgot_password_title'),
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
                      AppStrings.get('forgot_password_subtitle'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? AppColors.textMutedDark : const Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Phone Number Input
                  CustomTextField(
                    label: AppStrings.get('phone_number'),
                    hintText: '061XXXXX93',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 28),

                  // Send Code Button
                  PrimaryButton(
                    text: AppStrings.get('send_code'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OTPVerificationScreen(
                            targetAddress: _phoneController.text,
                            isEmail: false,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Try another method link
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordEmailScreen(),
                          ),
                        );
                      },
                      child: Text(
                        AppStrings.get('try_another_method'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B5CF6),
                        ),
                      ),
                    ),
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
