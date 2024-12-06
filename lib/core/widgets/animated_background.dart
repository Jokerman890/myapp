import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
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
        // Animated gradient background
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.darkBlue,
                    AppColors.darkPurple,
                  ],
                  transform: GradientRotation(_animation.value * 2 * 3.14159),
                ),
              ),
            );
          },
        ),

        // Animated overlay pattern
        Opacity(
          opacity: 0.05,
          child: CustomPaint(
            painter: GridPainter(
              animation: _animation,
            ),
            size: Size.infinite,
          ),
        ),

        // Content
        widget.child,
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  final Animation<double> animation;

  GridPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const spacing = 50.0;
    final xCount = (size.width / spacing).ceil() + 1;
    final yCount = (size.height / spacing).ceil() + 1;
    final offset = animation.value * spacing;

    // Draw vertical lines
    for (var i = 0; i < xCount; i++) {
      final x = i * spacing + offset;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (var i = 0; i < yCount; i++) {
      final y = i * spacing + offset;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw glowing dots at intersections
    final dotPaint = Paint()
      ..color = AppColors.turquoise.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < xCount; i++) {
      for (var j = 0; j < yCount; j++) {
        final x = i * spacing + offset;
        final y = j * spacing + offset;
        canvas.drawCircle(
          Offset(x, y),
          2,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => true;
}
