import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../theme/app_theme.dart';
import '../widgets/header_bar.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  List<CourseModel> get _sampleCourses => [
        CourseModel(
          id: '1',
          name: 'IoT & Mobile\nApp',
          completedAssignments: 7,
          totalAssignments: 10,
          completedTests: 1,
          totalTests: 2,
          themeColor: const Color(0xFF1D61E7),
        ),
        CourseModel(
          id: '2',
          name: 'Eng A+',
          classId: 'Class ID: 1u34t',
          completedAssignments: 8,
          totalAssignments: 11,
          completedTests: 2,
          totalTests: 3,
          themeColor: const Color(0xFFE07A48),
        ),
        CourseModel(
          id: '3',
          name: 'Control\nSystem',
          completedAssignments: 5,
          totalAssignments: 8,
          completedTests: 1,
          totalTests: 2,
          themeColor: const Color(0xFF4CAF50),
        ),
        CourseModel(
          id: '4',
          name: 'Electronic\nEngineering',
          completedAssignments: 6,
          totalAssignments: 10,
          completedTests: 1,
          totalTests: 2,
          themeColor: const Color(0xFF8D3C2A),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final courses = _sampleCourses;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderBar(title: 'COURSES'),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.76,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return _buildCourseCard(courses[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(CourseModel course) {
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
                    fontSize: 18,
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

          // White overlay card for stats
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: course.classId != null ? 70 : 64,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progress',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
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
                    '${course.completedAssignments} Assignment',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    '${course.completedTests} Test',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Divider(color: Color(0xFFE2E8F0), thickness: 1),
                  const SizedBox(height: 4),

                  // Total Stats
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    '${course.totalAssignments} Assignment',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    '${course.totalTests} Test',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
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
