import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomProgressBar extends StatelessWidget {
  final double progress; // من 0.0 إلى 1.0
  final String? label;
  final Color? color;
  final double height;
  final bool showPercentage;

  const CustomProgressBar({
    super.key,
    required this.progress,
    this.label,
    this.color,
    this.height = 20,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt();
    final barColor = color ?? AppTheme.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (showPercentage)
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: barColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Stack(
          children: [
            // الخلفية
            Container(
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
            // شريط التقدم
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      barColor,
                      barColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(height / 2),
                  boxShadow: [
                    BoxShadow(
                      color: barColor.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            // النسبة المئوية داخل الشريط (اختياري)
            if (showPercentage && progress > 0.15)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '$percentage%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// شريط تقدم دائري
class CircularProgressBar extends StatelessWidget {
  final double progress; // من 0.0 إلى 1.0
  final double size;
  final double strokeWidth;
  final Color? color;
  final Widget? child;

  const CircularProgressBar({
    super.key,
    required this.progress,
    this.size = 100,
    this.strokeWidth = 8,
    this.color,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final barColor = color ?? AppTheme.primaryColor;
    final percentage = (progress * 100).toInt();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // الدائرة الكاملة (الخلفية)
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: strokeWidth,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[200]!),
          ),
          // دائرة التقدم
          CircularProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
            strokeCap: StrokeCap.round,
          ),
          // المحتوى في المنتصف
          Center(
            child: child ??
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: size * 0.2,
                    fontWeight: FontWeight.bold,
                    color: barColor,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
