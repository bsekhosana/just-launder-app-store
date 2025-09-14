import 'package:flutter/material.dart';
import '../../design_system/color_schemes.dart';
import '../../design_system/radii.dart';
import '../../design_system/spacing.dart';
import '../../design_system/elevations.dart';
import '../../design_system/motion.dart';
import 'glass_surface.dart';

/// Enhanced card widget with multiple variants and animations
/// Supports flat, elevated, and glass variants with smooth transitions
class CardX extends StatefulWidget {
  final Widget child;
  final CardVariant variant;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enableHover;
  final bool enablePress;
  final Duration animationDuration;
  final Curve animationCurve;
  final double scaleOnPress;
  final double hoverElevation;
  final double pressElevation;

  const CardX({
    super.key,
    required this.child,
    this.variant = CardVariant.elevated,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0.0,
    this.shadows,
    this.onTap,
    this.onLongPress,
    this.enableHover = true,
    this.enablePress = true,
    this.animationDuration = AppMotion.fast,
    this.animationCurve = AppCurves.standard,
    this.scaleOnPress = 0.98,
    this.hoverElevation = 2.0,
    this.pressElevation = 4.0,
  });

  @override
  State<CardX> createState() => _CardXState();
}

class _CardXState extends State<CardX> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleOnPress,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enablePress && widget.onTap != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enablePress && widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enablePress && widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isInteractive = widget.onTap != null || widget.onLongPress != null;

    // Determine effective styling based on variant
    Color effectiveBackgroundColor;
    List<BoxShadow> effectiveShadows;

    switch (widget.variant) {
      case CardVariant.flat:
        effectiveBackgroundColor =
            widget.backgroundColor ?? colorScheme.surface;
        effectiveShadows = widget.shadows ?? [];
        break;
      case CardVariant.elevated:
        effectiveBackgroundColor =
            widget.backgroundColor ?? colorScheme.surface;
        effectiveShadows = widget.shadows ?? Shadows.card;
        break;
      case CardVariant.glass:
        return GlassSurface(
          width: widget.width,
          height: widget.height,
          padding: widget.padding,
          margin: widget.margin,
          borderRadius: widget.borderRadius,
          backgroundColor: widget.backgroundColor,
          borderColor: widget.borderColor,
          borderWidth: widget.borderWidth,
          shadows: widget.shadows,
          onTap: widget.onTap,
          child: widget.child,
        );
      case CardVariant.outlined:
        effectiveBackgroundColor =
            widget.backgroundColor ?? colorScheme.surface;
        effectiveShadows = widget.shadows ?? [];
        break;
    }

    Widget card = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: widget.padding ?? SpacingUtils.all(AppSpacing.cardPadding),
            margin: widget.margin,
            decoration: BoxDecoration(
              color: effectiveBackgroundColor,
              borderRadius: widget.borderRadius ?? Radii.card,
              border:
                  widget.variant == CardVariant.outlined
                      ? Border.all(
                        color: widget.borderColor ?? colorScheme.outline,
                        width:
                            widget.borderWidth > 0 ? widget.borderWidth : 1.0,
                      )
                      : null,
              boxShadow: effectiveShadows,
            ),
            child: widget.child,
          ),
        );
      },
    );

    if (isInteractive) {
      card = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: card,
      );
    }

    if (widget.enableHover && isInteractive) {
      card = MouseRegion(onEnter: (_) {}, onExit: (_) {}, child: card);
    }

    return card;
  }
}

/// Card variants
enum CardVariant { flat, elevated, glass, outlined }

/// Predefined card variants
class CardsX {
  /// Flat card with no elevation
  static Widget flat({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return CardX(
      child: child,
      variant: CardVariant.flat,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  /// Elevated card with shadow
  static Widget elevated({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return CardX(
      child: child,
      variant: CardVariant.elevated,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  /// Glass card with backdrop blur
  static Widget glass({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return CardX(
      child: child,
      variant: CardVariant.glass,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  /// Outlined card with border
  static Widget outlined({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    Color? borderColor,
    double borderWidth = 1.0,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return CardX(
      child: child,
      variant: CardVariant.outlined,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  /// Info card with accent styling
  static Widget info({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return CardX(
      child: child,
      variant: CardVariant.elevated,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: AppColors.infoContainer,
      borderColor: AppColors.info,
      borderWidth: 1.0,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  /// Success card with green styling
  static Widget success({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return CardX(
      child: child,
      variant: CardVariant.elevated,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: AppColors.successContainer,
      borderColor: AppColors.success,
      borderWidth: 1.0,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  /// Warning card with orange styling
  static Widget warning({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return CardX(
      child: child,
      variant: CardVariant.elevated,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: AppColors.warningContainer,
      borderColor: AppColors.warning,
      borderWidth: 1.0,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  /// Error card with red styling
  static Widget error({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return CardX(
      child: child,
      variant: CardVariant.elevated,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: AppColors.errorContainer,
      borderColor: AppColors.error,
      borderWidth: 1.0,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
