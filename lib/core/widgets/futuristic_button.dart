import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

class FuturisticButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final Color? color;
  final Color? glowColor;
  final BorderRadius? borderRadius;

  const FuturisticButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height = 56,
    this.color,
    this.glowColor,
    this.borderRadius,
  });

  @override
  State<FuturisticButton> createState() => _FuturisticButtonState();
}

class _FuturisticButtonState extends State<FuturisticButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                (widget.color ?? AppColors.turquoise).withOpacity(_isPressed ? 0.3 : _isHovered ? 0.2 : 0.1),
                (widget.color ?? AppColors.turquoise).withOpacity(_isPressed ? 0.4 : _isHovered ? 0.3 : 0.2),
              ],
            ),
            border: Border.all(
              color: (widget.color ?? AppColors.turquoise).withOpacity(_isPressed ? 0.5 : _isHovered ? 0.4 : 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: (widget.glowColor ?? widget.color ?? AppColors.turquoise).withOpacity(_isPressed ? 0.3 : _isHovered ? 0.2 : 0.1),
                blurRadius: 8,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Center(
            child: widget.child,
          ),
        ).animate(
          target: _isHovered ? 1 : 0,
        ).scale(
          begin: const Offset(1, 1),
          end: const Offset(1.02, 1.02),
          duration: 200.ms,
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }
}
