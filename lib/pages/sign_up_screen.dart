import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Center Logo
              const Center(
                child: AppLogo(size: 150),
              ),
              const SizedBox(height: 24),

              // Full Name*
              CustomTextField(
                label: 'Full Name*',
                hintText: 'Name',
                controller: _nameController,
              ),
              const SizedBox(height: 14),

              // Email Address*
              CustomTextField(
                label: 'Email Address*',
                hintText: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),

              // Password*
              CustomTextField(
                label: 'Password*',
                hintText: '••••••••',
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 24),

              // Sign Up Button
              PrimaryButton(
                text: 'Sign Up',
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainNavigationScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 28),

              // Sign up with Social
              const SocialLoginRow(title: 'Sign up with'),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
