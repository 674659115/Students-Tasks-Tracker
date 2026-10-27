import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';

String formatFriendlyDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);
  final difference = target.difference(today).inDays;

  if (difference == 0) {
    return 'Due Today 23:59';
  } else if (difference == 1) {
    return 'Due Tomorrow 23:59';
  } else if (difference == -1) {
    return 'Due Yesterday';
  } else if (difference < 0) {
    return 'Overdue (${date.day}/${date.month}/${date.year})';
  } else {
    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayName = daysOfWeek[date.weekday - 1];
    return 'Due $dayName ${date.day}/${date.month}/${date.year}';
  }
}

class AddTaskDialog extends StatefulWidget {
  final Function(TaskModel) onTaskCreated;

  const AddTaskDialog({
    super.key,
    required this.onTaskCreated,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  String _selectedCourse = 'IoT & Mobile App';
  DateTime _selectedDate = DateTime.now();
  TaskPriority _selectedPriority = TaskPriority.high;

  final List<String> _courses = [
    'IoT & Mobile App',
    'Eng A+',
    'Control System',
    'Electronics Engineering',
  ];

  Color _getCourseColor(String course) {
    switch (course) {
      case 'IoT & Mobile App':
        return AppColors.courseBlue;
      case 'Eng A+':
        return AppColors.courseOrange;
      case 'Control System':
        return AppColors.courseGreen;
      case 'Electronics Engineering':
        return AppColors.courseBrown;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDarkMode(context);
    final cardBg = isDark ? AppColors.cardBgDark : AppColors.background;
    final textPrimary = isDark ? AppColors.textLight : const Color(0xFF0F172A);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row (Close 'X' icon + Title)
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 28,
                      color: isDark ? AppColors.textMutedDark : const Color(0xFF94A3B8),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Center(
                  child: Text(
                    'ADD TASK',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Task Title Label & Input
            Text(
              'TASK TITLE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _titleController,
                style: TextStyle(color: textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Task Title',
                  hintStyle: TextStyle(color: Color(0xFFA0AEC0)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Courses Label & Dropdown
            Text(
              'COURSES',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? const Color(0xFF475569) : Colors.black54,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCourse,
                  isExpanded: true,
                  dropdownColor: isDark ? const Color(0xFF334155) : Colors.white,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  items: _courses.map((String course) {
                    return DropdownMenuItem<String>(
                      value: course,
                      child: Text(course),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedCourse = val;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date Label & Picker
            Text(
              'DATE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_outlined,
                      color: textPrimary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Priority Label & Selection Buttons
            Text(
              'PRIORITY',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildPriorityButton(
                    priority: TaskPriority.low,
                    label: 'LOW',
                    activeColor: const Color(0xFF4CAF50),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPriorityButton(
                    priority: TaskPriority.medium,
                    label: 'MEDIUM',
                    activeColor: const Color(0xFFFFB300),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPriorityButton(
                    priority: TaskPriority.high,
                    label: 'HIGH',
                    activeColor: const Color(0xFFFF3B30),
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Create Task Button
            PrimaryButton(
              text: 'CREATE TASK',
              onPressed: () {
                final newTitle = _titleController.text.trim().isEmpty
                    ? 'New Task'
                    : _titleController.text.trim();
                final newTask = TaskModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: newTitle,
                  course: _selectedCourse,
                  dueText: formatFriendlyDate(_selectedDate),
                  dueDate: _selectedDate,
                  priority: _selectedPriority,
                  courseColor: _getCourseColor(_selectedCourse),
                );
                widget.onTaskCreated(newTask);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),

            // Cancel Text Button
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'CANCEL',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E67C6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityButton({
    required TaskPriority priority,
    required String label,
    required Color activeColor,
    required bool isDark,
  }) {
    final bool isSelected = _selectedPriority == priority;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : (isDark ? const Color(0xFF334155) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : activeColor,
            ),
          ),
        ),
      ),
    );
  }
}
