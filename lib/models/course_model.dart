import 'package:flutter/material.dart';

class CourseModel {
  final String id;
  final String name;
  final String? classId;
  final int completedAssignments;
  final int totalAssignments;
  final int completedTests;
  final int totalTests;
  final Color themeColor;

  CourseModel({
    required this.id,
    required this.name,
    this.classId,
    required this.completedAssignments,
    required this.totalAssignments,
    required this.completedTests,
    required this.totalTests,
    required this.themeColor,
  });

  double get progress {
    int totalItems = totalAssignments + totalTests;
    if (totalItems == 0) return 0.0;
    int completedItems = completedAssignments + completedTests;
    return completedItems / totalItems;
  }
}
