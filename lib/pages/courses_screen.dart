import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/course_model.dart';
import '../theme/app_theme.dart';
import '../widgets/header_bar.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final List<CourseModel> _courses = [
    CourseModel(
      id: '1',
      name: 'IoT & Mobile\nApp Dev',
      classId: 'Class ID: CS-401',
      completedAssignments: 7,
      totalAssignments: 10,
      completedTests: 1,
      totalTests: 2,
      themeColor: AppColors.courseBlue,
    ),
    CourseModel(
      id: '2',
      name: 'English\nComm. A+',
      classId: 'Class ID: ENG-102',
      completedAssignments: 8,
      totalAssignments: 11,
      completedTests: 2,
      totalTests: 3,
      themeColor: AppColors.courseOrange,
    ),
    CourseModel(
      id: '3',
      name: 'Control System\nEngineering',
      classId: 'Class ID: EE-304',
      completedAssignments: 5,
      totalAssignments: 8,
      completedTests: 1,
      totalTests: 2,
      themeColor: AppColors.courseGreen,
    ),
    CourseModel(
      id: '4',
      name: 'Electronic\nEngineering',
      classId: 'Class ID: EE-201',
      completedAssignments: 6,
      totalAssignments: 10,
      completedTests: 1,
      totalTests: 2,
      themeColor: AppColors.courseBrown,
    ),
    CourseModel(
      id: '5',
      name: 'Data Structures\n& Algorithms',
      classId: 'Class ID: CS-202',
      completedAssignments: 9,
      totalAssignments: 12,
      completedTests: 2,
      totalTests: 2,
      themeColor: AppColors.coursePurple,
    ),
    CourseModel(
      id: '6',
      name: 'Database\nManagement',
      classId: 'Class ID: CS-305',
      completedAssignments: 4,
      totalAssignments: 6,
      completedTests: 1,
      totalTests: 1,
      themeColor: AppColors.courseTeal,
    ),
    CourseModel(
      id: '7',
      name: 'Artificial\nIntelligence',
      classId: 'Class ID: AI-410',
      completedAssignments: 3,
      totalAssignments: 5,
      completedTests: 1,
      totalTests: 2,
      themeColor: AppColors.courseIndigo,
    ),
    CourseModel(
      id: '8',
      name: 'Physics II:\nElectricity',
      classId: 'Class ID: PHY-102',
      completedAssignments: 7,
      totalAssignments: 9,
      completedTests: 2,
      totalTests: 2,
      themeColor: AppColors.courseRose,
    ),
  ];

  void _showAddCourseDialog() {
    final nameController = TextEditingController();
    final classIdController = TextEditingController();
    final assignController = TextEditingController(text: '5');
    final testController = TextEditingController(text: '2');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppStrings.get('add_course')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Course Name'),
                ),
                TextField(
                  controller: classIdController,
                  decoration: const InputDecoration(labelText: 'Class ID (e.g. CS-101)'),
                ),
                TextField(
                  controller: assignController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Total Assignments'),
                ),
                TextField(
                  controller: testController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Total Tests'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.get('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    _courses.add(
                      CourseModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameController.text.trim(),
                        classId: classIdController.text.isEmpty
                            ? 'Class ID: GEN-100'
                            : 'Class ID: ${classIdController.text.trim()}',
                        completedAssignments: 1,
                        totalAssignments:
                            int.tryParse(assignController.text) ?? 5,
                        completedTests: 0,
                        totalTests: int.tryParse(testController.text) ?? 2,
                        themeColor: AppColors.primary,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(AppStrings.get('add_course')),
            ),
          ],
        );
      },
    );
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
            child: Column(
              children: [
                HeaderBar(title: AppStrings.get('courses')),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_courses.length} ${AppStrings.get('active_courses')}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textMutedDark
                              : const Color(0xFF64748B),
                        ),
                      ),
                      GestureDetector(
                        onTap: _showAddCourseDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.add, color: Colors.white, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                AppStrings.get('add_course'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      return _buildCourseCard(_courses[index], isDark);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCourseCard(CourseModel course, bool isDark) {
    final cardBg = isDark ? AppColors.cardBgDark : Colors.white;
    final textPrimary = isDark ? AppColors.textLight : const Color(0xFF0F172A);

    return Container(
      decoration: BoxDecoration(
        color: course.themeColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Header title inside top color block
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                if (course.classId != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    course.classId!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // White/Dark overlay card for stats
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: course.classId != null ? 72 : 64,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.get('progress'),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: course.progress,
                      minHeight: 8,
                      backgroundColor: course.themeColor.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(course.themeColor),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Current Completed Stats
                  Text(
                    '${course.completedAssignments} ${AppStrings.get('assignment')}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  Text(
                    '${course.completedTests} ${AppStrings.get('test')}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textMutedDark
                          : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),

                  Divider(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    thickness: 1,
                  ),
                  const SizedBox(height: 2),

                  // Total Stats
                  Text(
                    AppStrings.get('total'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: textPrimary,
                    ),
                  ),
                  Text(
                    '${course.totalAssignments} ${AppStrings.get('assignment')}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  Text(
                    '${course.totalTests} ${AppStrings.get('test')}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textMutedDark
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
