import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

enum TaskPriority { low, medium, high }

class TaskModel {
  final String id;
  final String title;
  final String course;
  final String dueText;
  final DateTime dueDate;
  final TaskPriority priority;
  final Color courseColor;
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.course,
    required this.dueText,
    required this.dueDate,
    required this.priority,
    required this.courseColor,
    this.isCompleted = false,
  });

  String get priorityText {
    switch (priority) {
      case TaskPriority.low:
        return AppStrings.get('low_priority');
      case TaskPriority.medium:
        return AppStrings.get('medium_priority');
      case TaskPriority.high:
        return AppStrings.get('high_priority');
    }
  }
}
