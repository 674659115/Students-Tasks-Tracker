import 'dart:math';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 180});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF0D66C2),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D66C2).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: LogoPainter(),
      ),
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer circle border inside logo
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02;

    canvas.drawCircle(center, radius * 0.9, borderPaint);

    // Center graphics (Book, Grad Cap, Checkmark, Student)
    final double iconScale = size.width / 180;
    
    // Draw open book
    final bookPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5 * iconScale;

    final bookFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    // Left page
    final leftPage = Path()
      ..moveTo(center.dx, center.dy + 35 * iconScale)
      ..quadraticBezierTo(
        center.dx - 25 * iconScale, center.dy + 25 * iconScale,
        center.dx - 45 * iconScale, center.dy + 30 * iconScale,
      )
      ..lineTo(center.dx - 45 * iconScale, center.dy - 10 * iconScale)
      ..quadraticBezierTo(
        center.dx - 25 * iconScale, center.dy - 15 * iconScale,
        center.dx, center.dy - 5 * iconScale,
      )
      ..close();

    // Right page
    final rightPage = Path()
      ..moveTo(center.dx, center.dy + 35 * iconScale)
      ..quadraticBezierTo(
        center.dx + 25 * iconScale, center.dy + 25 * iconScale,
        center.dx + 45 * iconScale, center.dy + 30 * iconScale,
      )
      ..lineTo(center.dx + 45 * iconScale, center.dy - 10 * iconScale)
      ..quadraticBezierTo(
        center.dx + 25 * iconScale, center.dy - 15 * iconScale,
        center.dx, center.dy - 5 * iconScale,
      )
      ..close();

    canvas.drawPath(leftPage, bookFill);
    canvas.drawPath(leftPage, bookPaint);
    canvas.drawPath(rightPage, bookFill);
    canvas.drawPath(rightPage, bookPaint);

    // Horizontal lines in book
    for (int i = 0; i < 4; i++) {
      double yOffset = (i * 7 - 5) * iconScale;
      canvas.drawLine(
        Offset(center.dx - 38 * iconScale, center.dy + yOffset),
        Offset(center.dx - 10 * iconScale, center.dy + yOffset - 3 * iconScale),
        bookPaint..strokeWidth = 2.0 * iconScale,
      );
      canvas.drawLine(
        Offset(center.dx + 10 * iconScale, center.dy + yOffset - 3 * iconScale),
        Offset(center.dx + 38 * iconScale, center.dy + yOffset),
        bookPaint..strokeWidth = 2.0 * iconScale,
      );
    }

    // Student Head & Cap
    final headCenter = Offset(center.dx, center.dy - 25 * iconScale);
    final headPaint = Paint()..color = Colors.white;
    canvas.drawCircle(headCenter, 10 * iconScale, headPaint);

    // Graduation Cap
    final capPath = Path()
      ..moveTo(center.dx - 18 * iconScale, center.dy - 33 * iconScale)
      ..lineTo(center.dx, center.dy - 40 * iconScale)
      ..lineTo(center.dx + 18 * iconScale, center.dy - 33 * iconScale)
      ..lineTo(center.dx, center.dy - 26 * iconScale)
      ..close();
    canvas.drawPath(capPath, headPaint);

    // Large Checkmark overlay across book
    final checkPath = Path()
      ..moveTo(center.dx - 15 * iconScale, center.dy + 5 * iconScale)
      ..lineTo(center.dx + 2 * iconScale, center.dy + 22 * iconScale)
      ..lineTo(center.dx + 35 * iconScale, center.dy - 20 * iconScale);

    final checkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0 * iconScale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(checkPath, checkPaint);

    // Curved Text: Top Arc "STUDENTS TASK TRACKER", Bottom Arc "EFFICIENCY THROUGH EDUCATION"
    _drawArcText(canvas, size, "STUDENTS TASK TRACKER", isTop: true);
    _drawArcText(canvas, size, "EFFICIENCY THROUGH EDUCATION", isTop: false);
  }

  void _drawArcText(Canvas canvas, Size size, String text, {required bool isTop}) {
    final double radius = (size.width / 2) * 0.77;
    final center = Offset(size.width / 2, size.height / 2);
    final double fontSize = size.width * (isTop ? 0.075 : 0.045);

    double startAngle = isTop ? -pi * 0.75 : pi * 0.75;
    double totalSweep = isTop ? pi * 0.5 : -pi * 0.5;
    double anglePerChar = totalSweep / (text.length - 1);

    for (int i = 0; i < text.length; i++) {
      double angle = startAngle + i * anglePerChar;
      canvas.save();
      double x = center.dx + radius * cos(angle);
      double y = center.dy + radius * sin(angle);
      canvas.translate(x, y);
      canvas.rotate(angle + (isTop ? pi / 2 : -pi / 2));

      TextSpan span = TextSpan(
        text: text[i],
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      );
      TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
