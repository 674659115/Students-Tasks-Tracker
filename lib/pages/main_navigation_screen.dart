import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'home_screen.dart';
import 'courses_screen.dart';
import 'calendar_screen.dart';
import 'analytical_screen.dart';
import 'add_task_dialog.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<TaskModel> _tasks = [
    TaskModel(
      id: '1',
      title: 'IoT & Mobile App Project',
      course: 'IoT & Mobile App',
      dueText: formatFriendlyDate(DateTime.now()),
      dueDate: DateTime.now(),
      priority: TaskPriority.high,
      courseColor: AppColors.courseBlue,
      isCompleted: false,
    ),
    TaskModel(
      id: '2',
      title: 'Eng A+ Essay Submission',
      course: 'Eng A+',
      dueText: formatFriendlyDate(DateTime.now()),
      dueDate: DateTime.now(),
      priority: TaskPriority.medium,
      courseColor: AppColors.courseOrange,
      isCompleted: true,
    ),
    TaskModel(
      id: '3',
      title: 'Control System Homework 3',
      course: 'Control System',
      dueText: formatFriendlyDate(DateTime.now()),
      dueDate: DateTime.now(),
      priority: TaskPriority.low,
      courseColor: AppColors.courseGreen,
      isCompleted: false,
    ),
    TaskModel(
      id: '4',
      title: 'Electronics Lab Preparation',
      course: 'Electronics Engineering',
      dueText: formatFriendlyDate(DateTime.now().add(const Duration(days: 2))),
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: TaskPriority.medium,
      courseColor: AppColors.courseBrown,
      isCompleted: false,
    ),
  ];

  void _addNewTask(TaskModel newTask) {
    setState(() {
      _tasks.insert(0, newTask);
    });
  }

  void _toggleTask(String taskId) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == taskId);
      task.isCompleted = !task.isCompleted;
    });
  }

  void _deleteTask(String taskId) {
    setState(() {
      _tasks.removeWhere((t) => t.id == taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, currentLang, child) {
        final isDark = AppColors.isDarkMode(context);

        final List<Widget> pages = [
          HomeScreen(
            key: ValueKey('home_$currentLang'),
            tasks: _tasks,
            onTaskAdded: _addNewTask,
            onTaskToggled: _toggleTask,
            onTaskDeleted: _deleteTask,
          ),
          CoursesScreen(key: ValueKey('courses_$currentLang')),
          CalendarScreen(key: ValueKey('calendar_$currentLang')),
          AnalyticalScreen(key: ValueKey('profile_$currentLang')),
        ];

        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
          body: IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}
