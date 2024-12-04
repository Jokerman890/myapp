import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double opacity;
  final double blur;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;

  const GlassContainer({
    super.key,
    required this.child,
    this.opacity = 0.1,
    this.blur = 10,
    this.width,
    this.height,
    this.padding,
    this.decoration,
    this.boxShadow,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: decoration?.borderRadius as BorderRadius? ?? BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: decoration?.copyWith(
            color: Colors.white.withOpacity(opacity),
            boxShadow: boxShadow,
            gradient: gradient,
          ) ?? BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: boxShadow,
            gradient: gradient,
          ),
          child: child,
        ),
      ),
    );
  }
}
