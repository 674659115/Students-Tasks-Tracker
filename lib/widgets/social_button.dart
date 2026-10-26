import 'package:flutter/material.dart';

class SocialLoginRow extends StatelessWidget {
  final String title;

  const SocialLoginRow({
    super.key,
    this.title = 'Sign in with',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(
                color: Color(0xFF94A3B8),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E67C6),
                ),
              ),
            ),
            const Expanded(
              child: Divider(
                color: Color(0xFF94A3B8),
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(
              child: const CustomGoogleLogo(),
              onTap: () {},
            ),
            const SizedBox(width: 24),
            _buildSocialIcon(
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B5998),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: const Center(
                  child: Text(
                    'f',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              onTap: () {},
            ),
            const SizedBox(width: 24),
            _buildSocialIcon(
              child: const Icon(
                Icons.apple,
                size: 38,
                color: Colors.black,
              ),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon({required Widget child, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 56,
        height: 56,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: child),
      ),
    );
  }
}

class CustomGoogleLogo extends StatelessWidget {
  const CustomGoogleLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: CustomPaint(
        painter: GooglePainter(),
      ),
    );
  }
}

class GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);

    final redPaint = Paint()..color = const Color(0xFFEA4335);
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    final bluePaint = Paint()..color = const Color(0xFF4285F4);

    final rect = Rect.fromCircle(center: center, radius: w / 2);

    // Blue section (Right bar & arc)
    final bluePath = Path()
      ..addArc(rect, -0.4, 1.8)
      ..lineTo(w / 2, h / 2)
      ..close();
    canvas.drawPath(bluePath, bluePaint);

    // Green section (Bottom arc)
    final greenPath = Path()
      ..addArc(rect, 0.9, 1.6)
      ..lineTo(w / 2, h / 2)
      ..close();
    canvas.drawPath(greenPath, greenPaint);

    // Yellow section (Left arc)
    final yellowPath = Path()
      ..addArc(rect, 2.3, 1.2)
      ..lineTo(w / 2, h / 2)
      ..close();
    canvas.drawPath(yellowPath, yellowPaint);

    // Red section (Top arc)
    final redPath = Path()
      ..addArc(rect, 3.4, 1.4)
      ..lineTo(w / 2, h / 2)
      ..close();
    canvas.drawPath(redPath, redPaint);

    // Inner white cutout circle
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, w * 0.3, whitePaint);

    // Blue horizontal bar
    final barPath = Path()
      ..addRect(Rect.fromLTWH(w * 0.45, h * 0.38, w * 0.5, h * 0.24));
    canvas.drawPath(barPath, bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
