import 'package:flutter/material.dart';
import '../../design_system/color_schemes.dart';
import '../../design_system/radii.dart';
import '../../design_system/spacing.dart';
import '../../design_system/motion.dart';
import '../../design_system/elevations.dart';

/// An animated button with scale, fade, and loading states
/// Provides smooth micro-interactions and visual feedback
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ButtonStyle? style;
  final bool isLoading;
  final bool isDisabled;
  final double scaleOnPress;
  final Duration animationDuration;
  final Curve animationCurve;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final List<BoxShadow>? shadows;
  final Border? border;
  final String? tooltip;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.style,
    this.isLoading = false,
    this.isDisabled = false,
    this.scaleOnPress = 0.95,
    this.animationDuration = AppMotion.fast,
    this.animationCurve = AppCurves.standard,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.shadows,
    this.border,
    this.tooltip,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

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
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (!widget.isDisabled && !widget.isLoading) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled =
        !widget.isDisabled && !widget.isLoading && widget.onPressed != null;

    final effectiveBackgroundColor =
        widget.isDisabled
            ? (widget.disabledBackgroundColor ?? colorScheme.surfaceVariant)
            : (widget.backgroundColor ?? colorScheme.primary);

    final effectiveForegroundColor =
        widget.isDisabled
            ? (widget.disabledForegroundColor ?? colorScheme.onSurfaceVariant)
            : (widget.foregroundColor ?? colorScheme.onPrimary);

    final effectiveShadows =
        widget.shadows ??
        (effectiveBackgroundColor == Colors.transparent ? [] : Shadows.button);

    Widget button = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              padding:
                  widget.padding ??
                  SpacingUtils.symmetric(
                    horizontal: AppSpacing.l,
                    vertical: AppSpacing.m,
                  ),
              decoration: BoxDecoration(
                color: effectiveBackgroundColor,
                borderRadius:
                    widget.borderRadius ?? BorderRadius.circular(Radii.button),
                border: widget.border,
                boxShadow: effectiveShadows,
              ),
              child: Center(
                child:
                    widget.isLoading
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              effectiveForegroundColor,
                            ),
                          ),
                        )
                        : widget.child,
              ),
            ),
          ),
        );
      },
    );

    if (isEnabled) {
      button = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onPressed,
        onLongPress: widget.onLongPress,
        child: button,
      );
    }

    if (widget.tooltip != null) {
      button = Tooltip(message: widget.tooltip!, child: button);
    }

    return button;
  }
}

/// Predefined animated button variants
class AnimatedButtons {
  /// Primary button with default styling
  static Widget primary({
    required Widget child,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isDisabled = false,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
    String? tooltip,
  }) {
    return AnimatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      isLoading: isLoading,
      isDisabled: isDisabled,
      padding: padding,
      width: width,
      height: height,
      tooltip: tooltip,
      child: child,
    );
  }

  /// Secondary button with outlined style
  static Widget secondary({
    required Widget child,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isDisabled = false,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
    String? tooltip,
  }) {
    return AnimatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      isLoading: isLoading,
      isDisabled: isDisabled,
      backgroundColor: Colors.transparent,
      foregroundColor: null, // Will use theme primary color
      padding: padding,
      width: width,
      height: height,
      tooltip: tooltip,
      child: child,
    );
  }

  /// Text button with minimal styling
  static Widget text({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isDisabled = false,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
    String? tooltip,
  }) {
    return AnimatedButton(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      isLoading: isLoading,
      isDisabled: isDisabled,
      backgroundColor: Colors.transparent,
      foregroundColor: null, // Will use theme primary color
      shadows: const [],
      padding: padding,
      width: width,
      height: height,
      tooltip: tooltip,
      child: child,
    );
  }

  /// Icon button with circular shape
  static Widget icon({
    required Widget child,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isDisabled = false,
    double? size,
    String? tooltip,
  }) {
    return AnimatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: size ?? 48,
      height: size ?? 48,
      borderRadius: BorderRadius.circular(Radii.lg),
      padding: EdgeInsets.zero,
      tooltip: tooltip,
      child: child,
    );
  }

  /// Floating action button style
  static Widget fab({
    required Widget child,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isDisabled = false,
    double? size,
    String? tooltip,
  }) {
    return AnimatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: size ?? 56,
      height: size ?? 56,
      borderRadius: BorderRadius.circular(Radii.lg),
      padding: EdgeInsets.zero,
      shadows: Shadows.floatingActionButton,
      tooltip: tooltip,
      child: child,
    );
  }

  /// Glass button with backdrop blur
  static Widget glass({
    required Widget child,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    bool isLoading = false,
    bool isDisabled = false,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
    String? tooltip,
  }) {
    return AnimatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      isLoading: isLoading,
      isDisabled: isDisabled,
      backgroundColor: AppColors.glassSurface,
      foregroundColor: null, // Will use theme colors
      padding: padding,
      width: width,
      height: height,
      tooltip: tooltip,
      child: child,
    );
  }
}
