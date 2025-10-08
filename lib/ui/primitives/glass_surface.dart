import 'package:flutter/material.dart';
import 'dart:ui';
import '../../design_system/radii.dart';
import '../../design_system/elevations.dart';

/// A glass surface widget with backdrop blur and transparency effects
/// Perfect for modern UI overlays, cards, and modals
class GlassSurface extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blurIntensity;
  final double opacity;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final bool enableBlur;

  const GlassSurface({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blurIntensity = 10.0,
    this.opacity = 0.1,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.shadows,
    this.onTap,
    this.enableBlur = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveBackgroundColor =
        backgroundColor ?? colorScheme.surface.withOpacity(opacity);
    final effectiveBorderColor =
        borderColor ?? colorScheme.outline.withOpacity(0.2);
    final effectiveShadows = shadows ?? Shadows.low;

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(Radii.card),
        border: Border.all(color: effectiveBorderColor, width: borderWidth),
        boxShadow: effectiveShadows,
      ),
      child: child,
    );

    if (enableBlur) {
      content = ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(Radii.card),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurIntensity,
            sigmaY: blurIntensity,
          ),
          child: content,
        ),
      );
    }

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(Radii.card),
        child: content,
      );
    }

    return content;
  }
}

/// Predefined glass surface variants
class GlassSurfaces {
  /// Light glass surface with subtle blur
  static Widget light({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
  }) {
    return GlassSurface(
      child: child,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      blurIntensity: 8.0,
      opacity: 0.05,
      onTap: onTap,
    );
  }

  /// Medium glass surface with moderate blur
  static Widget medium({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
  }) {
    return GlassSurface(
      child: child,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      blurIntensity: 12.0,
      opacity: 0.1,
      onTap: onTap,
    );
  }

  /// Heavy glass surface with strong blur
  static Widget heavy({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
  }) {
    return GlassSurface(
      child: child,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      blurIntensity: 16.0,
      opacity: 0.15,
      onTap: onTap,
    );
  }

  /// Card glass surface with standard styling
  static Widget card({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
  }) {
    return GlassSurface(
      child: child,
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      borderRadius: BorderRadius.circular(Radii.card),
      blurIntensity: 10.0,
      opacity: 0.08,
      onTap: onTap,
    );
  }

  /// Modal glass surface for overlays
  static Widget modal({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
  }) {
    return GlassSurface(
      child: child,
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(24),
      margin: margin,
      borderRadius: BorderRadius.circular(Radii.dialog),
      blurIntensity: 15.0,
      opacity: 0.12,
      onTap: onTap,
    );
  }

  /// App bar glass surface
  static Widget appBar({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return GlassSurface(
      child: child,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: BorderRadius.zero,
      blurIntensity: 8.0,
      opacity: 0.06,
      enableBlur: true,
    );
  }

  /// Bottom sheet glass surface
  static Widget bottomSheet({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return GlassSurface(
      child: child,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: BorderRadius.circular(Radii.bottomSheet),
      blurIntensity: 12.0,
      opacity: 0.1,
    );
  }
}
