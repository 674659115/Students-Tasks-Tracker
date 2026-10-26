import 'package:flutter/material.dart';

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
        return 'LOW';
      case TaskPriority.medium:
        return 'MEDIUM';
      case TaskPriority.high:
        return 'HIGH';
    }
  }
}
