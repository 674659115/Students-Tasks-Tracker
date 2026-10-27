import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_quick_header.dart';
import '../widgets/primary_button.dart';
import 'reset_password_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String targetAddress;
  final bool isEmail;

  const OTPVerificationScreen({
    super.key,
    required this.targetAddress,
    this.isEmail = true,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    if (widget.isEmail) {
      _controllers[0].text = '1';
      _controllers[1].text = '7';
      _controllers[2].text = '9';
    } else {
      _controllers[0].text = '7';
      _controllers[1].text = '5';
      _controllers[2].text = '9';
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

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

                  // Envelope Icon Header
                  Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E67C6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.isEmail
                            ? Icons.mail_outline_rounded
                            : Icons.phone_android_rounded,
                        color: Colors.white,
                        size: 46,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Center(
                    child: Text(
                      widget.isEmail
                          ? AppStrings.get('check_your_email')
                          : AppStrings.get('check_your_phone'),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: '${AppStrings.get('verification_sent_to')}\n',
                          style: TextStyle(
                            fontSize: 15,
                            color: isDark
                                ? AppColors.textMutedDark
                                : const Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: widget.targetAddress,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8B5CF6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 6 OTP Box Inputs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) => _buildOtpBox(index, isDark)),
                  ),
                  const SizedBox(height: 36),

                  // Verify Button
                  PrimaryButton(
                    text: AppStrings.get('verify'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPasswordScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Resend Code Link
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: AppStrings.get('resend_code_question'),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textMutedDark
                              : const Color(0xFF6B7280),
                        ),
                        children: [
                          TextSpan(
                            text: '${AppStrings.get('resend_it')} (7)',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B5CF6),
                            ),
                          ),
                        ],
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

  Widget _buildOtpBox(int index, bool isDark) {
    return Container(
      width: 48,
      height: 56,
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
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.textLight : Colors.black,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (val) {
          if (val.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (val.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
