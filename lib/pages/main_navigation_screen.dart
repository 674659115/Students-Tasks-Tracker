import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'home_screen.dart';
import 'courses_screen.dart';
import 'calendar_screen.dart';
import 'analytical_screen.dart';

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
      title: 'IoT & Mobile App',
      course: 'IoT & Mobile App',
      dueText: 'Due Tomorrow 23:59',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: TaskPriority.high,
      courseColor: AppColors.courseBlue,
      isCompleted: true,
    ),
    TaskModel(
      id: '2',
      title: 'Eng A+',
      course: 'Eng A+',
      dueText: 'Due Today 23:59',
      dueDate: DateTime.now(),
      priority: TaskPriority.medium,
      courseColor: AppColors.courseOrange,
      isCompleted: true,
    ),
    TaskModel(
      id: '3',
      title: 'Control System',
      course: 'Control System',
      dueText: 'Due Fri 13:00',
      dueDate: DateTime.now().add(const Duration(days: 4)),
      priority: TaskPriority.low,
      courseColor: AppColors.courseGreen,
      isCompleted: true,
    ),
    TaskModel(
      id: '4',
      title: 'Electronics Engineering',
      course: 'Electronics Engineering',
      dueText: 'Due Thu 16:00',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      priority: TaskPriority.medium,
      courseColor: AppColors.courseBrown,
      isCompleted: true,
    ),
  ];

  void _addNewTask(TaskModel newTask) {
    setState(() {
      _tasks.add(newTask);
    });
  }

  void _toggleTask(String taskId) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == taskId);
      task.isCompleted = !task.isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        tasks: _tasks,
        onTaskAdded: _addNewTask,
        onTaskToggled: _toggleTask,
      ),
      const CoursesScreen(),
      const CalendarScreen(),
      const AnalyticalScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
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
  }
}
