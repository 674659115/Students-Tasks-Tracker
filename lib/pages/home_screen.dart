import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/header_bar.dart';
import '../widgets/charts.dart';
import 'add_task_dialog.dart';

class HomeScreen extends StatefulWidget {
  final List<TaskModel> tasks;
  final Function(TaskModel) onTaskAdded;
  final Function(String) onTaskToggled;

  const HomeScreen({
    super.key,
    required this.tasks,
    required this.onTaskAdded,
    required this.onTaskToggled,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    int completedCount = widget.tasks.where((t) => t.isCompleted).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header
                  const HeaderBar(
                    subtitle: 'Monday, Sep 7th',
                    title: 'Welcome, User!',
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
                          title: 'TODAY TASKS',
                          completed: completedCount > 0 ? 1 : 0,
                          total: 3,
                          progress: 0.33,
                          activeColor: const Color(0xFF3B82F6),
                          activeSecondaryColor: const Color(0xFFA855F7),
                        ),
                        const SizedBox(width: 14),
                        _buildStatCard(
                          title: 'WEEKLY TASKS',
                          completed: completedCount,
                          total: widget.tasks.length,
                          progress: widget.tasks.isEmpty
                              ? 0
                              : completedCount / widget.tasks.length,
                          activeColor: const Color(0xFF3B82F6),
                          activeSecondaryColor: const Color(0xFFE07A48),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // MY TASKS Header
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'MY TASKS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Task Cards List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: widget.tasks.length,
                    itemBuilder: (context, index) {
                      final task = widget.tasks[index];
                      return _buildTaskCard(task);
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
    required String title,
    required int completed,
    required int total,
    required double progress,
    required Color activeColor,
    required Color activeSecondaryColor,
  }) {
    return Container(
      width: 175,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
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
                      const TextSpan(
                        text: 'OUT\nOF ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
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
                  'Complete',
                  style: TextStyle(
                    fontSize: 14,
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

  Widget _buildTaskCard(TaskModel task) {
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
        color: Colors.white,
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
                color: task.isCompleted ? task.courseColor : task.courseColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  task.isCompleted ? Icons.check_box : Icons.check_rounded,
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
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: task.courseColor,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: '${task.dueText} | ',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8),
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
        ],
      ),
    );
  }
}
