import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../design_system/color_schemes.dart';
import '../../design_system/radii.dart';
import '../../design_system/spacing.dart';
import '../../design_system/motion.dart';
import '../../design_system/typography.dart';
import '../../design_system/icons.dart';
import '../../design_system/elevations.dart';

/// Enhanced snackbar with multiple variants and animations
/// Provides modern feedback with smooth transitions
class SnackX extends StatelessWidget {
  final String message;
  final SnackVariant variant;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration duration;
  final Duration animationDuration;
  final Curve animationCurve;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? actionColor;
  final List<BoxShadow>? shadows;
  final bool showProgressIndicator;
  final double? width;
  final TextAlign textAlign;

  const SnackX({
    super.key,
    required this.message,
    this.variant = SnackVariant.info,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.duration = const Duration(seconds: 4),
    this.animationDuration = AppMotion.normal,
    this.animationCurve = AppCurves.standard,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.actionColor,
    this.shadows,
    this.showProgressIndicator = false,
    this.width,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    // Determine effective colors based on variant
    Color effectiveBackgroundColor;
    Color effectiveForegroundColor;
    Color effectiveActionColor;
    IconData effectiveIcon;

    switch (variant) {
      case SnackVariant.success:
        effectiveBackgroundColor =
            backgroundColor ?? AppColors.successContainer;
        effectiveForegroundColor =
            foregroundColor ?? AppColors.onSuccessContainer;
        effectiveActionColor = actionColor ?? AppColors.success;
        effectiveIcon = icon ?? AppIcons.success;
        break;
      case SnackVariant.warning:
        effectiveBackgroundColor =
            backgroundColor ?? AppColors.warningContainer;
        effectiveForegroundColor =
            foregroundColor ?? AppColors.onWarningContainer;
        effectiveActionColor = actionColor ?? AppColors.warning;
        effectiveIcon = icon ?? AppIcons.warning;
        break;
      case SnackVariant.error:
        effectiveBackgroundColor = backgroundColor ?? AppColors.errorContainer;
        effectiveForegroundColor =
            foregroundColor ?? AppColors.onErrorContainer;
        effectiveActionColor = actionColor ?? AppColors.error;
        effectiveIcon = icon ?? AppIcons.error;
        break;
      case SnackVariant.info:
        effectiveBackgroundColor = backgroundColor ?? AppColors.infoContainer;
        effectiveForegroundColor = foregroundColor ?? AppColors.onInfo;
        effectiveActionColor = actionColor ?? AppColors.info;
        effectiveIcon = icon ?? AppIcons.info;
        break;
    }

    final effectiveShadows = shadows ?? Shadows.snackBar;

    return Container(
          width: width,
          margin: margin ?? const EdgeInsets.all(16),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: padding ?? SpacingUtils.all(AppSpacing.m),
              decoration: BoxDecoration(
                color: effectiveBackgroundColor,
                borderRadius: borderRadius ?? BorderRadius.circular(Radii.m),
                boxShadow: effectiveShadows,
              ),
              child: Row(
                children: [
                  // Icon
                  Icon(
                    effectiveIcon,
                    color: effectiveForegroundColor,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.m),

                  // Message
                  Expanded(
                    child: Text(
                      message,
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: effectiveForegroundColor,
                      ),
                      textAlign: textAlign,
                    ),
                  ),

                  // Action Button
                  if (actionLabel != null && onAction != null) ...[
                    const SizedBox(width: AppSpacing.m),
                    TextButton(
                      onPressed: onAction,
                      style: TextButton.styleFrom(
                        foregroundColor: effectiveActionColor,
                        padding: SpacingUtils.symmetric(
                          horizontal: AppSpacing.s,
                          vertical: AppSpacing.xs,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        actionLabel!,
                        style: AppTypography.textTheme.labelMedium?.copyWith(
                          color: effectiveActionColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: animationDuration, curve: animationCurve)
        .slideX(
          begin: 1.0,
          end: 0.0,
          duration: animationDuration,
          curve: animationCurve,
        );
  }
}

/// Snackbar variants
enum SnackVariant { success, warning, error, info }

/// SnackX utility class for showing snackbars
class SnackXUtils {
  /// Show a success snackbar
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    _showSnackBar(
      context,
      SnackX(
        message: message,
        variant: SnackVariant.success,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration ?? const Duration(seconds: 4),
      ),
    );
  }

  /// Show a warning snackbar
  static void showWarning(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    _showSnackBar(
      context,
      SnackX(
        message: message,
        variant: SnackVariant.warning,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration ?? const Duration(seconds: 4),
      ),
    );
  }

  /// Show an error snackbar
  static void showError(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    _showSnackBar(
      context,
      SnackX(
        message: message,
        variant: SnackVariant.error,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration ?? const Duration(seconds: 6),
      ),
    );
  }

  /// Show an info snackbar
  static void showInfo(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    _showSnackBar(
      context,
      SnackX(
        message: message,
        variant: SnackVariant.info,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration ?? const Duration(seconds: 4),
      ),
    );
  }

  /// Show a custom snackbar
  static void showCustom(BuildContext context, {required SnackX snackBar}) {
    _showSnackBar(context, snackBar);
  }

  /// Internal method to show snackbar
  static void _showSnackBar(BuildContext context, SnackX snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: snackBar,
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: snackBar.duration,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

/// Predefined snackbar variants
class SnacksX {
  /// Success snackbar
  static Widget success({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return SnackX(
      message: message,
      variant: SnackVariant.success,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration ?? const Duration(seconds: 4),
      padding: padding,
      margin: margin,
    );
  }

  /// Warning snackbar
  static Widget warning({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return SnackX(
      message: message,
      variant: SnackVariant.warning,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration ?? const Duration(seconds: 4),
      padding: padding,
      margin: margin,
    );
  }

  /// Error snackbar
  static Widget error({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return SnackX(
      message: message,
      variant: SnackVariant.error,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration ?? const Duration(seconds: 6),
      padding: padding,
      margin: margin,
    );
  }

  /// Info snackbar
  static Widget info({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return SnackX(
      message: message,
      variant: SnackVariant.info,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration ?? const Duration(seconds: 4),
      padding: padding,
      margin: margin,
    );
  }
}
