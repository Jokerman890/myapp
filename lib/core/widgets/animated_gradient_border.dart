import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedGradientBorder extends StatefulWidget {
  final Widget child;
  final double borderWidth;
  final double borderRadius;
  final List<Color> gradientColors;
  final Duration duration;

  const AnimatedGradientBorder({
    super.key,
    required this.child,
    this.borderWidth = 1.5,
    this.borderRadius = 20,
    this.gradientColors = const [
      Color(0xFF6750A4),
      Color(0xFF03DAC6),
      Color(0xFF6750A4),
    ],
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
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
      builder: (_, child) {
        return CustomPaint(
          painter: _GradientBorderPainter(
            progress: _controller.value,
            borderWidth: widget.borderWidth,
            borderRadius: widget.borderRadius,
            gradientColors: widget.gradientColors,
          ),
          child: child,
        );
      },
      child: Container(
        padding: EdgeInsets.all(widget.borderWidth),
        child: widget.child,
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final double progress;
  final double borderWidth;
  final double borderRadius;
  final List<Color> gradientColors;

  _GradientBorderPainter({
    required this.progress,
    required this.borderWidth,
    required this.borderRadius,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..shader = SweepGradient(
        colors: gradientColors,
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(progress * 2 * math.pi),
      ).createShader(rect);

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect.deflate(borderWidth / 2),
          Radius.circular(borderRadius),
        ),
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_GradientBorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
