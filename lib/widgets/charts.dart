import 'dart:math';
import 'package:flutter/material.dart';
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
  const WeeklyProductivityChart({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDarkMode(context);

    return Column(
      children: [
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(const Color(0xFF3B82F6), 'On-Time Submission', isDark),
            const SizedBox(width: 12),
            _buildLegendItem(const Color(0xFFFFD54F), 'Late Submission', isDark),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(const Color(0xFFC63D2F), 'Not Submitted', isDark),
          ],
        ),
        const SizedBox(height: 16),
        // Chart Area
        SizedBox(
          height: 140,
          child: CustomPaint(
            size: const Size(double.infinity, 140),
            painter: StackedBarChartPainter(isDark: isDark),
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

  StackedBarChartPainter({required this.isDark});

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

    // Days & Bar Data
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    final data = [
      [65.0, 20.0, 15.0],
      [60.0, 25.0, 15.0],
      [70.0, 30.0, 0.0],
      [60.0, 20.0, 20.0],
      [70.0, 15.0, 15.0],
    ];

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

      // X Label
      final tp = TextPainter(
        text: TextSpan(text: days[i], style: textStyle),
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- Pie Chart Widget ---
class TaskByCoursePieChart extends StatelessWidget {
  const TaskByCoursePieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Pie Chart
        SizedBox(
          width: 140,
          height: 140,
          child: CustomPaint(
            painter: PieChartPainter(),
          ),
        ),
        const SizedBox(width: 16),
        // Legend List
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCourseLegend(const Color(0xFF3B82F6), 'IoT & Mobile App'),
              const SizedBox(height: 10),
              _buildCourseLegend(const Color(0xFFF5A623), 'Eng A+'),
              const SizedBox(height: 10),
              _buildCourseLegend(const Color(0xFF4CAF50), 'Control System'),
              const SizedBox(height: 10),
              _buildCourseLegend(
                const Color(0xFF8B5CF6),
                'Electronic Engineering',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCourseLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
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
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final slices = [
      {'percent': 0.40, 'color': const Color(0xFF3B82F6)},
      {'percent': 0.25, 'color': const Color(0xFFF5A623)},
      {'percent': 0.20, 'color': const Color(0xFF4CAF50)},
      {'percent': 0.15, 'color': const Color(0xFF8B5CF6)},
    ];

    double startAngle = -pi / 2;

    for (var slice in slices) {
      double sweepAngle = 2 * pi * (slice['percent'] as double);
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
