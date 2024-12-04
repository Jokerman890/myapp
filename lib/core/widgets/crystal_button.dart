import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CrystalButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? color;
  final double width;
  final double height;

  const CrystalButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.width = 200,
    this.height = 50,
  });

  @override
  State<CrystalButton> createState() => _CrystalButtonState();
}

class _CrystalButtonState extends State<CrystalButton> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.color ?? Theme.of(context).primaryColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      baseColor.withOpacity(0.8),
                      baseColor.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: baseColor.withOpacity(_isHovered ? 0.8 : 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: baseColor.withOpacity(0.5 * _glowAnimation.value),
                      blurRadius: 20,
                      spreadRadius: -5,
                    ),
                    if (_isHovered)
                      BoxShadow(
                        color: baseColor.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 1,
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: Center(
                        child: widget.child.animate(target: _isPressed ? 1 : 0)
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(0.95, 0.95),
                            duration: 150.ms,
                          )
                          .shimmer(
                            duration: 1000.ms,
                            color: baseColor.withOpacity(0.5),
                          ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
