import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

class FuturisticIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final Color? glowColor;
  final double size;
  final String? tooltip;
  final bool isActive;

  const FuturisticIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.glowColor,
    this.size = 48,
    this.tooltip,
    this.isActive = false,
  });

  @override
  State<FuturisticIconButton> createState() => _FuturisticIconButtonState();
}

class _FuturisticIconButtonState extends State<FuturisticIconButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.color ?? AppColors.turquoise;
    final glowColor = widget.glowColor ?? buttonColor;

    Widget button = MouseRegion(
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
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                buttonColor.withOpacity(widget.isActive ? 0.3 : _isPressed ? 0.25 : _isHovered ? 0.2 : 0.1),
                buttonColor.withOpacity(widget.isActive ? 0.4 : _isPressed ? 0.35 : _isHovered ? 0.3 : 0.2),
              ],
            ),
            border: Border.all(
              color: buttonColor.withOpacity(widget.isActive ? 0.5 : _isPressed ? 0.4 : _isHovered ? 0.3 : 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: glowColor.withOpacity(widget.isActive ? 0.3 : _isPressed ? 0.25 : _isHovered ? 0.2 : 0.1),
                blurRadius: 8,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            color: AppColors.white.withOpacity(widget.isActive ? 1 : 0.7),
            size: widget.size * 0.5,
          ),
        ),
      ),
    ).animate(
      target: _isHovered || widget.isActive ? 1 : 0,
    ).scale(
      begin: const Offset(1, 1),
      end: const Offset(1.05, 1.05),
      duration: 200.ms,
      curve: Curves.easeOutCubic,
    );

    if (widget.tooltip != null) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }
}
