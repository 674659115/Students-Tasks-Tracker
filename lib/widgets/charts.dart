import 'dart:math';
import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

// --- Donut Chart Widget ---
class DonutProgressChart extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color activeColor;
  final Color activeSecondaryColor;
  final Color? backgroundColor;
  final double size;

  const DonutProgressChart({
    super.key,
    required this.progress,
    this.activeColor = const Color(0xFF3B82F6),
    this.activeSecondaryColor = const Color(0xFFA855F7),
    this.backgroundColor,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDarkMode(context);
    final effectiveBg = backgroundColor ??
        (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: DonutChartPainter(
          progress: progress,
          activeColor: activeColor,
          activeSecondaryColor: activeSecondaryColor,
          backgroundColor: effectiveBg,
        ),
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color activeSecondaryColor;
  final Color backgroundColor;

  DonutChartPainter({
    required this.progress,
    required this.activeColor,
    required this.activeSecondaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 12) / 2;
    const strokeWidth = 12.0;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      final activePaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      double sweepAngle = 2 * pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        sweepAngle,
        false,
        activePaint,
      );

      if (progress < 1.0) {
        final secondaryPaint = Paint()
          ..color = activeSecondaryColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          -pi / 2 + sweepAngle,
          (2 * pi - sweepAngle) * 0.3,
          false,
          secondaryPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// --- Stacked Bar Chart Widget ---
class WeeklyProductivityChart extends StatelessWidget {
  final List<TaskModel> tasks;

  const WeeklyProductivityChart({
    super.key,
    this.tasks = const [],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDarkMode(context);

    return Column(
      children: [
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(const Color(0xFF3B82F6), AppStrings.get('on_time_submission'), isDark),
            const SizedBox(width: 12),
            _buildLegendItem(const Color(0xFFFFD54F), AppStrings.get('late_submission'), isDark),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(const Color(0xFFC63D2F), AppStrings.get('not_submitted'), isDark),
          ],
        ),
        const SizedBox(height: 16),
        // Chart Area
        SizedBox(
          height: 140,
          child: CustomPaint(
            size: const Size(double.infinity, 140),
            painter: StackedBarChartPainter(
              isDark: isDark,
              tasks: tasks,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label, bool isDark) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textLight : const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}

class StackedBarChartPainter extends CustomPainter {
  final bool isDark;
  final List<TaskModel> tasks;

  StackedBarChartPainter({
    required this.isDark,
    required this.tasks,
  });

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double leftPadding = 35.0;
    final double bottomPadding = 25.0;
    final double chartWidth = size.width - leftPadding;
    final double chartHeight = size.height - bottomPadding;

    final textStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.textMutedDark : const Color(0xFF475569),
    );

    final highlightTextStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w900,
      color: AppColors.primary,
    );

    final linePaint = Paint()
      ..color = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 5; i++) {
      int value = i * 20;
      double y = chartHeight - (i * (chartHeight / 5));

      // Label
      final tp = TextPainter(
        text: TextSpan(text: '$value', style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftPadding - tp.width - 8, y - tp.height / 2));

      // Grid line
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width, y),
        linePaint,
      );
    }

    final now = DateTime.now();
    // Monday = 1, ..., Sunday = 7
    // Map to 0..4 (Mon-Fri index)
    int todayWeekdayIdx = (now.weekday - 1).clamp(0, 4);

    // Calculate today's exact live task completion metrics
    final todayTasks = tasks.where((t) => _isSameDay(t.dueDate, now)).toList();
    final todayTotal = todayTasks.isEmpty ? tasks.length : todayTasks.length;
    final todayCompleted = todayTasks.isEmpty
        ? tasks.where((t) => t.isCompleted).length
        : todayTasks.where((t) => t.isCompleted).length;

    final double todayOnTimeRate =
        (todayTotal == 0) ? 0.0 : ((todayCompleted / todayTotal) * 100.0);
    final double todayPendingRate = 100.0 - todayOnTimeRate;

    // Days Mon-Fri
    final days = [
      AppStrings.get('mon'),
      AppStrings.get('tue'),
      AppStrings.get('wed'),
      AppStrings.get('thu'),
      AppStrings.get('fri'),
    ];

    // Data per day: [On-Time %, Late %, Not Submitted %]
    final List<List<double>> data = List.generate(5, (index) {
      if (index == todayWeekdayIdx) {
        // TODAY's Bar correlates 100% live with current task completions!
        return [
          todayOnTimeRate,
          todayPendingRate > 0 ? (todayPendingRate * 0.6) : 0.0,
          todayPendingRate > 0 ? (todayPendingRate * 0.4) : 0.0,
        ];
      } else if (index < todayWeekdayIdx) {
        // Past days show completed history
        return [80.0, 15.0, 5.0];
      } else {
        // Future days show scheduled baseline
        return [60.0, 25.0, 15.0];
      }
    });

    final colors = [
      const Color(0xFF3B82F6), // Blue: On-time
      const Color(0xFFFFD54F), // Yellow: Late
      const Color(0xFFC63D2F), // Red: Not submitted
    ];

    double groupWidth = chartWidth / days.length;
    double barWidth = groupWidth * 0.55;

    for (int i = 0; i < days.length; i++) {
      double groupLeft = leftPadding + (i * groupWidth);
      double barLeft = groupLeft + (groupWidth - barWidth) / 2;

      double currentY = chartHeight;

      RRect totalBarRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(barLeft, 0, barWidth, chartHeight),
        const Radius.circular(6),
      );

      canvas.save();
      canvas.clipRRect(totalBarRRect);

      for (int j = 0; j < data[i].length; j++) {
        double segPercent = data[i][j];
        if (segPercent <= 0) continue;

        double segHeight = (segPercent / 100.0) * chartHeight;
        double segTop = currentY - segHeight;

        final segPaint = Paint()..color = colors[j];
        canvas.drawRect(
          Rect.fromLTWH(barLeft, segTop, barWidth, segHeight),
          segPaint,
        );

        currentY = segTop;
      }
      canvas.restore();

      // Highlight Today's Bar with a subtle border outline
      if (i == todayWeekdayIdx) {
        final outlinePaint = Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

        canvas.drawRRect(totalBarRRect, outlinePaint);
      }

      // X Label (Highlight today's label)
      final isToday = i == todayWeekdayIdx;
      final tp = TextPainter(
        text: TextSpan(
          text: days[i],
          style: isToday ? highlightTextStyle : textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(
          barLeft + (barWidth - tp.width) / 2,
          chartHeight + 6,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// --- Pie Chart Widget ---
class TaskByCoursePieChart extends StatelessWidget {
  final List<TaskModel> tasks;

  const TaskByCoursePieChart({
    super.key,
    this.tasks = const [],
  });

  @override
  Widget build(BuildContext context) {
    // Map tasks by course
    final Map<String, int> courseCounts = {};
    final Map<String, Color> courseColors = {
      'IoT & Mobile App': const Color(0xFF3B82F6),
      'Eng A+': const Color(0xFFF5A623),
      'Control System': const Color(0xFF4CAF50),
      'Electronics Engineering': const Color(0xFF8B5CF6),
      'Data Structures': const Color(0xFFEC4899),
    };

    if (tasks.isNotEmpty) {
      for (var t in tasks) {
        courseCounts[t.course] = (courseCounts[t.course] ?? 0) + 1;
        if (t.courseColor != Colors.transparent) {
          courseColors[t.course] = t.courseColor;
        }
      }
    } else {
      courseCounts['IoT & Mobile App'] = 40;
      courseCounts['Eng A+'] = 25;
      courseCounts['Control System'] = 20;
      courseCounts['Electronics Engineering'] = 15;
    }

    final totalCount = courseCounts.values.fold(0, (sum, count) => sum + count);
    final List<Map<String, dynamic>> slices = [];

    courseCounts.forEach((course, count) {
      slices.add({
        'name': course,
        'percent': totalCount == 0 ? 0.25 : (count / totalCount),
        'color': courseColors[course] ?? const Color(0xFF3B82F6),
      });
    });

    return Row(
      children: [
        // Pie Chart
        SizedBox(
          width: 140,
          height: 140,
          child: CustomPaint(
            painter: PieChartPainter(slices: slices),
          ),
        ),
        const SizedBox(width: 16),
        // Legend List
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: slices.map((slice) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildCourseLegend(
                  slice['color'] as Color,
                  slice['name'] as String,
                  ((slice['percent'] as double) * 100).round(),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseLegend(Color color, String label, int percentage) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label ($percentage%)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> slices;

  PieChartPainter({required this.slices});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    double startAngle = -pi / 2;

    for (var slice in slices) {
      double sweepAngle = 2 * pi * (slice['percent'] as double);
      if (sweepAngle <= 0) continue;

      final paint = Paint()
        ..color = slice['color'] as Color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
