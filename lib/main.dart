import 'package:flutter/material.dart';
import 'localization/app_localizations.dart';
import 'theme/app_theme.dart';
import 'pages/splash_screen.dart';

void main() {
  runApp(const StudentTaskTrackerApp());
}

class StudentTaskTrackerApp extends StatelessWidget {
  const StudentTaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return ValueListenableBuilder<String>(
          valueListenable: languageNotifier,
          builder: (context, currentLang, child) {
            return MaterialApp(
              title: 'Students Task Tracker',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: currentMode,
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
