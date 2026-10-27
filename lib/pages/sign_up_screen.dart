import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/auth_quick_header.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_button.dart';
import 'main_navigation_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleSignUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name, Email Address, and Password are all required.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Name & Surname Check (at least 2 words)
    final nameParts = name.split(RegExp(r'\s+'));
    if (nameParts.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both First Name and Surname (e.g. John Doe).'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService.register(
      name: name,
      email: email,
      password: password,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Welcome!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigationScreen(),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Registration failed.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Header
                  const AuthQuickHeader(),
                  const SizedBox(height: 10),

                  // Center Logo
                  const Center(
                    child: AppLogo(size: 140),
                  ),
                  const SizedBox(height: 20),

                  // Full Name* (Requires First Name & Surname)
                  CustomTextField(
                    label: AppStrings.get('full_name_required'),
                    hintText: 'First Name & Surname (e.g. John Doe)',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 14),

                  // Email Address*
                  CustomTextField(
                    label: AppStrings.get('email_address_required'),
                    hintText: 'Email (e.g. user@gmail.com)',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),

                  // Password*
                  CustomTextField(
                    label: AppStrings.get('password_required'),
                    hintText: '••••••••',
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 24),

                  // Sign Up Button
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : PrimaryButton(
                          text: AppStrings.get('sign_up'),
                          onPressed: _handleSignUp,
                        ),
                  const SizedBox(height: 24),

                  // Sign up with Social
                  SocialLoginRow(title: AppStrings.get('sign_up_with')),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
