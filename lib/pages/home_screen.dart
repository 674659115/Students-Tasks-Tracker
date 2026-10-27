import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/header_bar.dart';
import '../widgets/charts.dart';
import 'add_task_dialog.dart';

String formatHeaderDate() {
  final now = DateTime.now();
  final daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  String dayName = daysOfWeek[now.weekday - 1];
  String monthName = months[now.month - 1];

  int day = now.day;
  String suffix = 'th';
  if (day == 1 || day == 21 || day == 31) {
    suffix = 'st';
  } else if (day == 2 || day == 22) {
    suffix = 'nd';
  } else if (day == 3 || day == 23) {
    suffix = 'rd';
  }

  return '$dayName, $monthName $day$suffix';
}

class HomeScreen extends StatefulWidget {
  final List<TaskModel> tasks;
  final Function(TaskModel) onTaskAdded;
  final Function(String) onTaskToggled;
  final Function(String) onTaskDeleted;

  const HomeScreen({
    super.key,
    required this.tasks,
    required this.onTaskAdded,
    required this.onTaskToggled,
    required this.onTaskDeleted,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDarkMode(context);
    final cardBg = isDark ? AppColors.cardBgDark : Colors.white;
    final textPrimary = isDark ? AppColors.textLight : const Color(0xFF0F172A);

    // TODAY TASKS Calculations
    final now = DateTime.now();
    final todayTasks =
        widget.tasks.where((t) => _isSameDay(t.dueDate, now)).toList();
    final todayCompleted = todayTasks.where((t) => t.isCompleted).length;
    final todayTotal = todayTasks.length;
    final todayProgress =
        todayTotal == 0 ? 0.0 : (todayCompleted / todayTotal);

    // WEEKLY / TOTAL TASKS Calculations
    final weeklyCompleted = widget.tasks.where((t) => t.isCompleted).length;
    final weeklyTotal = widget.tasks.length;
    final weeklyProgress =
        weeklyTotal == 0 ? 0.0 : (weeklyCompleted / weeklyTotal);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header
                  HeaderBar(
                    subtitle: formatHeaderDate(),
                    title: AppStrings.get('welcome_user'),
                  ),
                  const SizedBox(height: 12),

                  // Stats Cards Row
                  SizedBox(
                    height: 124,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _buildStatCard(
                          context: context,
                          title: AppStrings.get('today_tasks'),
                          completed: todayCompleted,
                          total: todayTotal,
                          progress: todayProgress,
                          activeColor: const Color(0xFF3B82F6),
                          activeSecondaryColor: const Color(0xFFA855F7),
                          cardBg: cardBg,
                          textPrimary: textPrimary,
                        ),
                        const SizedBox(width: 14),
                        _buildStatCard(
                          context: context,
                          title: AppStrings.get('weekly_tasks'),
                          completed: weeklyCompleted,
                          total: weeklyTotal,
                          progress: weeklyProgress,
                          activeColor: const Color(0xFF3B82F6),
                          activeSecondaryColor: const Color(0xFFE07A48),
                          cardBg: cardBg,
                          textPrimary: textPrimary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // MY TASKS Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      AppStrings.get('my_tasks'),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Task Cards List
                  if (widget.tasks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      child: Center(
                        child: Text(
                          'No tasks yet! Click + to create one.',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: widget.tasks.length,
                      itemBuilder: (context, index) {
                        final task = widget.tasks[index];
                        return _buildTaskCard(task, cardBg, textPrimary, isDark);
                      },
                    ),
                ],
              ),
            ),

            // Floating Add Task '+' Button
            Positioned(
              right: 20,
              bottom: 20,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddTaskDialog(
                      onTaskCreated: (newTask) {
                        widget.onTaskAdded(newTask);
                      },
                    ),
                  );
                },
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE07A48),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE07A48).withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required int completed,
    required int total,
    required double progress,
    required Color activeColor,
    required Color activeSecondaryColor,
    required Color cardBg,
    required Color textPrimary,
  }) {
    return Container(
      width: 175,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: '$completed ',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B82F6),
                    ),
                    children: [
                      TextSpan(
                        text: '${AppStrings.get('out_of')} ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: '$total ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B5CF6),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  AppStrings.get('complete'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: activeColor,
                  ),
                ),
              ],
            ),
          ),
          DonutProgressChart(
            progress: progress,
            activeColor: activeColor,
            activeSecondaryColor: activeSecondaryColor,
            size: 52,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(
      TaskModel task, Color cardBg, Color textPrimary, bool isDark) {
    Color priorityColor;
    switch (task.priority) {
      case TaskPriority.low:
        priorityColor = AppColors.priorityLow;
        break;
      case TaskPriority.medium:
        priorityColor = AppColors.priorityMedium;
        break;
      case TaskPriority.high:
        priorityColor = AppColors.priorityHigh;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Checkbox Box
          GestureDetector(
            onTap: () => widget.onTaskToggled(task.id),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: task.courseColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Task Title & Due Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: task.isCompleted
                        ? (isDark ? AppColors.textMutedDark : const Color(0xFF94A3B8))
                        : task.courseColor,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: '${task.dueText} | ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textMutedDark : const Color(0xFF94A3B8),
                    ),
                    children: [
                      TextSpan(
                        text: task.priorityText,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: priorityColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Delete Task Button
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
              size: 24,
            ),
            onPressed: () {
              widget.onTaskDeleted(task.id);
            },
          ),
        ],
      ),
    );
  }
}
