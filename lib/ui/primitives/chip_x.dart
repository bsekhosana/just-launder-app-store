import 'package:flutter/material.dart';
import '../../design_system/color_schemes.dart';
import '../../design_system/radii.dart';
import '../../design_system/spacing.dart';
import '../../design_system/motion.dart';
import '../../design_system/typography.dart';
import '../../design_system/icons.dart';
import '../../design_system/elevations.dart';

/// Enhanced chip widget with selection states and animations
/// Provides smooth micro-interactions and visual feedback
class ChipX extends StatefulWidget {
  final Widget label;
  final Widget? avatar;
  final IconData? icon;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final VoidCallback? onLongPress;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final Color? disabledBackgroundColor;
  final Color? foregroundColor;
  final Color? selectedForegroundColor;
  final Color? disabledForegroundColor;
  final Color? borderColor;
  final Color? selectedBorderColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadows;
  final Duration animationDuration;
  final Curve animationCurve;
  final double scaleOnPress;
  final bool enableHover;
  final bool enablePress;

  const ChipX({
    super.key,
    required this.label,
    this.avatar,
    this.icon,
    this.isSelected = false,
    this.isDisabled = false,
    this.onTap,
    this.onDeleted,
    this.onLongPress,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.disabledBackgroundColor,
    this.foregroundColor,
    this.selectedForegroundColor,
    this.disabledForegroundColor,
    this.borderColor,
    this.selectedBorderColor,
    this.borderWidth = 1.0,
    this.padding,
    this.margin,
    this.borderRadius,
    this.shadows,
    this.animationDuration = AppMotion.fast,
    this.animationCurve = AppCurves.standard,
    this.scaleOnPress = 0.95,
    this.enableHover = true,
    this.enablePress = true,
  });

  @override
  State<ChipX> createState() => _ChipXState();
}

class _ChipXState extends State<ChipX> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<Color?> _foregroundColorAnimation;
  late Animation<Color?> _borderColorAnimation;

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
    _backgroundColorAnimation = ColorTween(
      begin: widget.backgroundColor,
      end: widget.selectedBackgroundColor,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );
    _foregroundColorAnimation = ColorTween(
      begin: widget.foregroundColor,
      end: widget.selectedForegroundColor,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );
    _borderColorAnimation = ColorTween(
      begin: widget.borderColor,
      end: widget.selectedBorderColor,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ChipX oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enablePress && !widget.isDisabled && widget.onTap != null) {
      // Handle tap down
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enablePress && !widget.isDisabled && widget.onTap != null) {
      // Handle tap up
    }
  }

  void _handleTapCancel() {
    if (widget.enablePress && !widget.isDisabled && widget.onTap != null) {
      // Handle tap cancel
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isInteractive = widget.onTap != null || widget.onLongPress != null;

    // Determine effective colors
    final effectiveBackgroundColor =
        widget.isDisabled
            ? (widget.disabledBackgroundColor ?? colorScheme.surfaceVariant)
            : (widget.isSelected
                ? (widget.selectedBackgroundColor ??
                    colorScheme.primaryContainer)
                : (widget.backgroundColor ?? colorScheme.surfaceVariant));

    final effectiveForegroundColor =
        widget.isDisabled
            ? (widget.disabledForegroundColor ?? colorScheme.onSurfaceVariant)
            : (widget.isSelected
                ? (widget.selectedForegroundColor ??
                    colorScheme.onPrimaryContainer)
                : (widget.foregroundColor ?? colorScheme.onSurfaceVariant));

    final effectiveBorderColor =
        widget.isSelected
            ? (widget.selectedBorderColor ?? colorScheme.primary)
            : (widget.borderColor ?? colorScheme.outline);

    final effectiveShadows = widget.shadows ?? Shadows.chip;

    Widget chip = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding:
                widget.padding ??
                SpacingUtils.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.s,
                ),
            margin: widget.margin,
            decoration: BoxDecoration(
              color:
                  _backgroundColorAnimation.value ?? effectiveBackgroundColor,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(Radii.chip),
              border: Border.all(
                color: _borderColorAnimation.value ?? effectiveBorderColor,
                width: widget.borderWidth,
              ),
              boxShadow: effectiveShadows,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.avatar != null) ...[
                  widget.avatar!,
                  const SizedBox(width: AppSpacing.s),
                ] else if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 16,
                    color:
                        _foregroundColorAnimation.value ??
                        effectiveForegroundColor,
                  ),
                  const SizedBox(width: AppSpacing.s),
                ],
                DefaultTextStyle(
                  style: (AppTypography.textTheme.labelMedium ??
                          const TextStyle())
                      .copyWith(
                        color:
                            _foregroundColorAnimation.value ??
                            effectiveForegroundColor,
                      ),
                  child: widget.label,
                ),
                if (widget.onDeleted != null) ...[
                  const SizedBox(width: AppSpacing.s),
                  GestureDetector(
                    onTap: widget.onDeleted,
                    child: Icon(
                      AppIcons.close,
                      size: 16,
                      color:
                          _foregroundColorAnimation.value ??
                          effectiveForegroundColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );

    if (isInteractive && !widget.isDisabled) {
      chip = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: chip,
      );
    }

    if (widget.enableHover && isInteractive && !widget.isDisabled) {
      chip = MouseRegion(onEnter: (_) {}, onExit: (_) {}, child: chip);
    }

    return chip;
  }
}

/// Predefined chip variants
class ChipsX {
  /// Standard chip
  static Widget standard({
    required Widget label,
    Widget? avatar,
    IconData? icon,
    bool isSelected = false,
    bool isDisabled = false,
    VoidCallback? onTap,
    VoidCallback? onDeleted,
    VoidCallback? onLongPress,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return ChipX(
      label: label,
      avatar: avatar,
      icon: icon,
      isSelected: isSelected,
      isDisabled: isDisabled,
      onTap: onTap,
      onDeleted: onDeleted,
      onLongPress: onLongPress,
      padding: padding,
      margin: margin,
    );
  }

  /// Filter chip for selection
  static Widget filter({
    required String label,
    bool isSelected = false,
    bool isDisabled = false,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return ChipX(
      label: Text(label),
      isSelected: isSelected,
      isDisabled: isDisabled,
      onTap: onTap,
      padding: padding,
      margin: margin,
    );
  }

  /// Choice chip for single selection
  static Widget choice({
    required String label,
    bool isSelected = false,
    bool isDisabled = false,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return ChipX(
      label: Text(label),
      isSelected: isSelected,
      isDisabled: isDisabled,
      onTap: onTap,
      padding: padding,
      margin: margin,
    );
  }

  /// Action chip for actions
  static Widget action({
    required String label,
    IconData? icon,
    bool isDisabled = false,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return ChipX(
      label: Text(label),
      icon: icon,
      isDisabled: isDisabled,
      onTap: onTap,
      padding: padding,
      margin: margin,
    );
  }

  /// Input chip with delete functionality
  static Widget input({
    required String label,
    Widget? avatar,
    IconData? icon,
    bool isDisabled = false,
    VoidCallback? onTap,
    VoidCallback? onDeleted,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return ChipX(
      label: Text(label),
      avatar: avatar,
      icon: icon,
      isDisabled: isDisabled,
      onTap: onTap,
      onDeleted: onDeleted,
      padding: padding,
      margin: margin,
    );
  }

  /// Status chip with color coding
  static Widget status({
    required String label,
    required ChipStatus status,
    bool isDisabled = false,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    Color backgroundColor;
    Color foregroundColor;
    Color borderColor;

    switch (status) {
      case ChipStatus.success:
        backgroundColor = AppColors.successContainer;
        foregroundColor = AppColors.onSuccessContainer;
        borderColor = AppColors.success;
        break;
      case ChipStatus.warning:
        backgroundColor = AppColors.warningContainer;
        foregroundColor = AppColors.onWarningContainer;
        borderColor = AppColors.warning;
        break;
      case ChipStatus.error:
        backgroundColor = AppColors.errorContainer;
        foregroundColor = AppColors.onErrorContainer;
        borderColor = AppColors.error;
        break;
      case ChipStatus.info:
        backgroundColor = AppColors.infoContainer;
        foregroundColor = AppColors.onInfo;
        borderColor = AppColors.info;
        break;
      case ChipStatus.neutral:
        backgroundColor = AppColors.surfaceVariant;
        foregroundColor = AppColors.onSurfaceVariant;
        borderColor = AppColors.outline;
        break;
    }

    return ChipX(
      label: Text(label),
      isDisabled: isDisabled,
      onTap: onTap,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
      padding: padding,
      margin: margin,
    );
  }

  /// Tag chip for categorization
  static Widget tag({
    required String label,
    Color? color,
    bool isSelected = false,
    bool isDisabled = false,
    VoidCallback? onTap,
    VoidCallback? onDeleted,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return ChipX(
      label: Text(label),
      isSelected: isSelected,
      isDisabled: isDisabled,
      onTap: onTap,
      onDeleted: onDeleted,
      backgroundColor: color?.withOpacity(0.1),
      selectedBackgroundColor: color?.withOpacity(0.2),
      foregroundColor: color,
      selectedForegroundColor: color,
      borderColor: color,
      selectedBorderColor: color,
      padding: padding,
      margin: margin,
    );
  }
}

/// Chip status for color coding
enum ChipStatus { success, warning, error, info, neutral }
