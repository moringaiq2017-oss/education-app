import 'dart:math';
import 'package:flutter/material.dart';

// ==========================================
// 🎉 كونفيتي - يظهر عند الإجابة الصحيحة
// ==========================================

class ConfettiOverlay extends StatefulWidget {
  final Widget child;
  final bool trigger;
  const ConfettiOverlay({super.key, required this.child, this.trigger = false});

  @override
  State<ConfettiOverlay> createState() => ConfettiOverlayState();
}

class ConfettiOverlayState extends State<ConfettiOverlay> with TickerProviderStateMixin {
  final List<_ConfettiParticle> _particles = [];
  AnimationController? _controller;
  final _random = Random();

  void fire() {
    _particles.clear();
    for (int i = 0; i < 40; i++) {
      _particles.add(_ConfettiParticle(
        x: _random.nextDouble(),
        y: -0.1,
        vx: (_random.nextDouble() - 0.5) * 0.02,
        vy: _random.nextDouble() * 0.01 + 0.005,
        color: [
          const Color(0xFFFF6B6B), const Color(0xFFFFD93D), const Color(0xFF6BCB77),
          const Color(0xFF4D96FF), const Color(0xFFFF6BA3), const Color(0xFFA66CFF),
        ][_random.nextInt(6)],
        size: _random.nextDouble() * 8 + 4,
        rotation: _random.nextDouble() * pi * 2,
      ));
    }
    _controller?.dispose();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..addListener(() {
        setState(() {
          for (var p in _particles) {
            p.x += p.vx;
            p.y += p.vy;
            p.vy += 0.0003; // جاذبية
            p.rotation += 0.05;
          }
          _particles.removeWhere((p) => p.y > 1.2);
        });
      })
      ..forward();
  }

  @override
  void didUpdateWidget(ConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) fire();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_particles.isNotEmpty)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _ConfettiPainter(_particles)),
            ),
          ),
      ],
    );
  }
}

class _ConfettiParticle {
  double x, y, vx, vy, size, rotation;
  Color color;
  _ConfettiParticle({required this.x, required this.y, required this.vx, required this.vy, required this.color, required this.size, required this.rotation});
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  _ConfettiPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()..color = p.color;
      canvas.save();
      canvas.translate(p.x * size.width, p.y * size.height);
      canvas.rotate(p.rotation);
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ==========================================
// ⭐ نجوم تطير - عند النجاح
// ==========================================

class FlyingStars extends StatefulWidget {
  final bool trigger;
  final int count;
  const FlyingStars({super.key, this.trigger = false, this.count = 5});

  @override
  State<FlyingStars> createState() => FlyingStarsState();
}

class FlyingStarsState extends State<FlyingStars> with TickerProviderStateMixin {
  final List<_StarData> _stars = [];
  AnimationController? _controller;
  final _random = Random();

  void fire() {
    _stars.clear();
    for (int i = 0; i < widget.count; i++) {
      _stars.add(_StarData(
        startX: 0.3 + _random.nextDouble() * 0.4,
        startY: 0.8,
        endX: _random.nextDouble(),
        endY: _random.nextDouble() * 0.3,
        delay: i * 0.1,
      ));
    }
    _controller?.dispose();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..forward();
    setState(() {});
  }

  @override
  void didUpdateWidget(FlyingStars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) fire();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _stars.isEmpty) return const SizedBox.shrink();
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, _) {
        return Stack(
          children: _stars.map((star) {
            final t = ((_controller!.value - star.delay) / (1.0 - star.delay)).clamp(0.0, 1.0);
            final curve = Curves.easeOutCubic.transform(t);
            final x = star.startX + (star.endX - star.startX) * curve;
            final y = star.startY + (star.endY - star.startY) * curve;
            final opacity = t < 0.8 ? 1.0 : (1.0 - (t - 0.8) / 0.2);
            final scale = t < 0.3 ? t / 0.3 : 1.0;
            return Positioned(
              left: x * MediaQuery.of(context).size.width - 16,
              top: y * MediaQuery.of(context).size.height - 16,
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: const Text('⭐', style: TextStyle(fontSize: 32)),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _StarData {
  final double startX, startY, endX, endY, delay;
  _StarData({required this.startX, required this.startY, required this.endX, required this.endY, required this.delay});
}

// ==========================================
// 🎈 زر متحرك (bounce)
// ==========================================

class BounceButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const BounceButton({super.key, required this.child, this.onTap});

  @override
  State<BounceButton> createState() => _BounceButtonState();
}

class _BounceButtonState extends State<BounceButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(scale: _scale.value, child: child),
        child: widget.child,
      ),
    );
  }
}

// ==========================================
// 🌟 شاشة النتيجة (صح/غلط) مع أنيميشن
// ==========================================

class ResultPopup {
  static void showCorrect(BuildContext context, {String message = 'أحسنت! 🎉'}) {
    _show(context, message, const Color(0xFF6BCB77), '✅', true);
  }

  static void showWrong(BuildContext context, {String message = 'حاول مرة ثانية 💪'}) {
    _show(context, message, const Color(0xFFFF6B6B), '❌', false);
  }

  static void _show(BuildContext context, String message, Color color, String emoji, bool isCorrect) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ResultDialog(message: message, color: color, emoji: emoji, isCorrect: isCorrect),
    );
    // إغلاق تلقائي بعد 2 ثانية
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    });
  }
}

class _ResultDialog extends StatefulWidget {
  final String message, emoji;
  final Color color;
  final bool isCorrect;
  const _ResultDialog({required this.message, required this.color, required this.emoji, required this.isCorrect});

  @override
  State<_ResultDialog> createState() => _ResultDialogState();
}

class _ResultDialogState extends State<_ResultDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _scale = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(40),
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [BoxShadow(color: widget.color.withValues(alpha: 0.3), blurRadius: 30, spreadRadius: 5)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.emoji, style: const TextStyle(fontSize: 64)),
                    const SizedBox(height: 16),
                    Text(
                      widget.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: widget.color),
                    ),
                    if (widget.isCorrect) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: Duration(milliseconds: 400 + (i * 200)),
                            curve: Curves.elasticOut,
                            builder: (_, value, child) => Transform.scale(scale: value, child: child),
                            child: const Text('⭐', style: TextStyle(fontSize: 32)),
                          ),
                        )),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ==========================================
// 🎨 خلفية فقاعات متحركة للشاشات
// ==========================================

class AnimatedBubbleBackground extends StatefulWidget {
  final Widget child;
  final Color color;
  const AnimatedBubbleBackground({super.key, required this.child, this.color = const Color(0xFF6C63FF)});

  @override
  State<AnimatedBubbleBackground> createState() => _AnimatedBubbleBackgroundState();
}

class _AnimatedBubbleBackgroundState extends State<AnimatedBubbleBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _random = Random();
  late List<_Bubble> _bubbles;

  @override
  void initState() {
    super.initState();
    _bubbles = List.generate(8, (_) => _Bubble(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 60 + 20,
      speed: _random.nextDouble() * 0.3 + 0.1,
      opacity: _random.nextDouble() * 0.08 + 0.02,
    ));
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..addListener(() {
        setState(() {
          for (var b in _bubbles) {
            b.y -= b.speed * 0.002;
            if (b.y < -0.1) {
              b.y = 1.1;
              b.x = _random.nextDouble();
            }
          }
        });
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الفقاعات
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _BubblePainter(_bubbles, widget.color),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _Bubble {
  double x, y, size, speed, opacity;
  _Bubble({required this.x, required this.y, required this.size, required this.speed, required this.opacity});
}

class _BubblePainter extends CustomPainter {
  final List<_Bubble> bubbles;
  final Color color;
  _BubblePainter(this.bubbles, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    for (var b in bubbles) {
      final paint = Paint()..color = color.withValues(alpha: b.opacity);
      canvas.drawCircle(Offset(b.x * size.width, b.y * size.height), b.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ==========================================
// 💫 ويدجت إيموجي متحرك
// ==========================================

class AnimatedEmoji extends StatefulWidget {
  final String emoji;
  final double size;
  const AnimatedEmoji({super.key, required this.emoji, this.size = 48});

  @override
  State<AnimatedEmoji> createState() => _AnimatedEmojiState();
}

class _AnimatedEmojiState extends State<AnimatedEmoji> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final bounce = sin(_controller.value * pi) * 8;
        return Transform.translate(
          offset: Offset(0, -bounce),
          child: Text(widget.emoji, style: TextStyle(fontSize: widget.size)),
        );
      },
    );
  }
}

// ==========================================
// 🏆 شريط التقدم المتحرك
// ==========================================

class AnimatedProgressBar extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final Color color;
  final double height;
  const AnimatedProgressBar({super.key, required this.progress, this.color = const Color(0xFF6C63FF), this.height = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Stack(
        children: [
          AnimatedFractionallySizedBox(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            widthFactor: progress.clamp(0.0, 1.0),
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
                borderRadius: BorderRadius.circular(height / 2),
                boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 6)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
