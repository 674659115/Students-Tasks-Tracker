import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';

String formatFriendlyDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);
  final difference = target.difference(today).inDays;

  if (difference == 0) {
    return AppStrings.get('due_today');
  } else if (difference == 1) {
    return AppStrings.get('due_tomorrow');
  } else if (difference == -1) {
    return AppStrings.get('due_yesterday');
  } else if (difference < 0) {
    return '${AppStrings.get('overdue')} (${date.day}/${date.month}/${date.year})';
  } else {
    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayName = daysOfWeek[date.weekday - 1];
    return '${AppStrings.get('due')} $dayName ${date.day}/${date.month}/${date.year}';
  }
}

class AddTaskDialog extends StatefulWidget {
  final Function(TaskModel) onTaskCreated;
  final List<String>? customCourses;

  const AddTaskDialog({
    super.key,
    required this.onTaskCreated,
    this.customCourses,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  late String _selectedCourse;
  DateTime _selectedDate = DateTime.now();
  TaskPriority _selectedPriority = TaskPriority.high;

  static const List<String> _defaultCourses = [
    'IoT & Mobile App Dev',
    'English Comm. A+',
    'Control System Engineering',
    'Electronic Engineering',
    'Data Structures & Algorithms',
    'Database Management',
    'Artificial Intelligence',
    'Physics II: Electricity',
  ];

  late List<String> _availableCourses;

  @override
  void initState() {
    super.initState();
    _availableCourses = widget.customCourses ?? _defaultCourses;
    if (_availableCourses.isEmpty) {
      _availableCourses = _defaultCourses;
    }
    _selectedCourse = _availableCourses.first;
  }

  Color _getCourseColor(String course) {
    if (course.contains('IoT') || course.contains('Mobile')) return AppColors.courseBlue;
    if (course.contains('English') || course.contains('Eng')) return AppColors.courseOrange;
    if (course.contains('Control')) return AppColors.courseGreen;
    if (course.contains('Electronic')) return AppColors.courseBrown;
    if (course.contains('Data Structures') || course.contains('Algo')) return AppColors.coursePurple;
    if (course.contains('Database')) return AppColors.courseTeal;
    if (course.contains('Artificial') || course.contains('AI')) return AppColors.courseIndigo;
    if (course.contains('Physics')) return AppColors.courseRose;
    return AppColors.primary;
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
        child: SingleChildScrollView(
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
                      AppStrings.get('add_task'),
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
                AppStrings.get('task_title'),
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
                    hintText: 'Task Title (e.g. Lab 3 Report)',
                    hintStyle: TextStyle(color: Color(0xFFA0AEC0)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Courses Label & Dropdown
              Text(
                AppStrings.get('courses_label'),
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
                  borderRadius: BorderRadius.circular(12),
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
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    items: _availableCourses.map((String course) {
                      return DropdownMenuItem<String>(
                        value: course,
                        child: Text(
                          course,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                AppStrings.get('date_label'),
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
                AppStrings.get('priority'),
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
                      label: AppStrings.get('low'),
                      activeColor: const Color(0xFF4CAF50),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildPriorityButton(
                      priority: TaskPriority.medium,
                      label: AppStrings.get('medium'),
                      activeColor: const Color(0xFFFFB300),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildPriorityButton(
                      priority: TaskPriority.high,
                      label: AppStrings.get('high'),
                      activeColor: const Color(0xFFFF3B30),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Create Task Button
              PrimaryButton(
                text: AppStrings.get('create_task'),
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
                  child: Text(
                    AppStrings.get('cancel'),
                    style: const TextStyle(
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
