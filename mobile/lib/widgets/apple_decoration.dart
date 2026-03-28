import 'dart:math';
import 'package:flutter/material.dart';

/// تفاحة زخرفية - مستوحاة من رسومات كتاب قراءتي
class AppleDecoration extends StatelessWidget {
  final double size;
  final Color color;

  const AppleDecoration({
    super.key,
    this.size = 40,
    this.color = const Color(0xFFE74C3C),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ApplePainter(color: color),
      ),
    );
  }
}

class _ApplePainter extends CustomPainter {
  final Color color;
  _ApplePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // جسم التفاحة
    final bodyPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // الجزء الأيسر
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - w * 0.1, h * 0.55),
        width: w * 0.6,
        height: h * 0.7,
      ),
      bodyPaint,
    );

    // الجزء الأيمن
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx + w * 0.1, h * 0.55),
        width: w * 0.6,
        height: h * 0.7,
      ),
      bodyPaint,
    );

    // لمعة (highlight)
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - w * 0.12, h * 0.4),
        width: w * 0.18,
        height: h * 0.22,
      ),
      highlightPaint,
    );

    // الساق
    final stemPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..strokeWidth = w * 0.06
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(cx, h * 0.22),
      Offset(cx + w * 0.04, h * 0.05),
      stemPaint,
    );

    // الورقة
    final leafPaint = Paint()
      ..color = const Color(0xFF27AE60)
      ..style = PaintingStyle.fill;
    final leafPath = Path()
      ..moveTo(cx + w * 0.04, h * 0.12)
      ..quadraticBezierTo(cx + w * 0.3, h * 0.02, cx + w * 0.35, h * 0.15)
      ..quadraticBezierTo(cx + w * 0.2, h * 0.15, cx + w * 0.04, h * 0.12);
    canvas.drawPath(leafPath, leafPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// مجموعة تفاحات زخرفية تُستخدم في زوايا البطاقات
class AppleCluster extends StatelessWidget {
  final int count;
  final double appleSize;

  const AppleCluster({
    super.key,
    this.count = 3,
    this.appleSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFE74C3C), // أحمر
      const Color(0xFF27AE60), // أخضر
      const Color(0xFFF39C12), // أصفر/برتقالي
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(min(count, 3), (i) => Padding(
        padding: EdgeInsets.only(right: i > 0 ? 2 : 0),
        child: AppleDecoration(
          size: appleSize,
          color: colors[i % colors.length],
        ),
      )),
    );
  }
}
