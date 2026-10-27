import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../theme/app_theme.dart';

void showHelpFaqsModal(BuildContext context) {
  final isDark = AppColors.isDarkMode(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDark ? AppColors.cardBgDark : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return const HelpFaqsModalContent();
    },
  );
}

class HelpFaqsModalContent extends StatelessWidget {
  const HelpFaqsModalContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
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

            // Header Title
            Text(
              AppStrings.get('help_faqs'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),

            // FAQ Items
            _buildFaqItem(
              'How do I add a new task?',
              'Tap the orange + button on the Home tab. Enter the task title, select your course, choose a due date and priority level, then tap Create Task.',
              isDark,
            ),
            _buildFaqItem(
              'How do I add deadlines to the Calendar?',
              'Go to the Calendar tab and tap "+ Add Event". Select any day of the month, course, time, and priority level to show a deadline dot on the grid.',
              isDark,
            ),
            _buildFaqItem(
              'How do I track course progress?',
              'Visit the Courses tab to view progress bars, assignment completions, and test metrics for all your enrolled subjects. You can also add custom courses using "+ Add Course".',
              isDark,
            ),
            _buildFaqItem(
              'How do I switch languages or enable Dark Mode?',
              'You can toggle Dark Mode and change languages in Settings, or by tapping your Profile Picture or the top header quick controls on Sign In & Sign Up.',
              isDark,
            ),
            _buildFaqItem(
              'Can I delete tasks or calendar items?',
              'Yes! Every task card on Home and deadline card on Calendar features a red trash icon. Tapping it instantly removes the item and updates your stats.',
              isDark,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
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
}
