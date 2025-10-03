import 'package:flutter/material.dart';
import '../../design_system/theme.dart';

/// Custom snackbar widget with consistent styling and various types
class CustomSnackbar {
  /// Show success snackbar
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context,
      message: message,
      type: SnackbarType.success,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Show error snackbar
  static void showError(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackbar(
      context,
      message: message,
      type: SnackbarType.error,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Show warning snackbar
  static void showWarning(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context,
      message: message,
      type: SnackbarType.warning,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Show info snackbar
  static void showInfo(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context,
      message: message,
      type: SnackbarType.info,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Show custom snackbar
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
  }) {
    _showSnackbar(
      context,
      message: message,
      type: type,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
    );
  }

  static void _showSnackbar(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
  }) {
    print('CustomSnackbar: Showing snackbar with message: $message');
    final theme = Theme.of(context);
    final snackbarConfig = _getSnackbarConfig(type);

    // Show animated snackbar
    _showAnimatedSnackbar(
      context,
      message: message,
      type: type,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      backgroundColor: backgroundColor ?? snackbarConfig.backgroundColor,
      textColor: textColor ?? snackbarConfig.textColor,
      icon: icon ?? snackbarConfig.icon,
    );
  }

  /// Show animated snackbar with slide up/down animation
  static void _showAnimatedSnackbar(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => _AnimatedSnackbar(
            message: message,
            backgroundColor: backgroundColor,
            textColor: textColor,
            icon: icon,
            actionLabel: actionLabel,
            onAction: onAction,
            onDismiss: () {
              overlayEntry.remove();
            },
            duration: duration,
          ),
    );

    overlay.insert(overlayEntry);
  }

  static _SnackbarConfig _getSnackbarConfig(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return _SnackbarConfig(
          backgroundColor: AppColors.success,
          textColor: AppColors.surface,
          icon: Icons.check_circle_outline,
        );
      case SnackbarType.error:
        return _SnackbarConfig(
          backgroundColor: AppColors.error,
          textColor: AppColors.surface,
          icon: Icons.error_outline,
        );
      case SnackbarType.warning:
        return _SnackbarConfig(
          backgroundColor: AppColors.tertiary,
          textColor: AppColors.surface,
          icon: Icons.warning_outlined,
        );
      case SnackbarType.info:
        return _SnackbarConfig(
          backgroundColor: AppColors.primary,
          textColor: AppColors.surface,
          icon: Icons.info_outline,
        );
    }
  }
}

/// Snackbar types
enum SnackbarType { success, error, warning, info }

/// Snackbar configuration
class _SnackbarConfig {
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  _SnackbarConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });
}

/// Custom snackbar widget for more complex layouts
class CustomSnackbarWidget extends StatelessWidget {
  final String message;
  final SnackbarType type;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final Widget? customIcon;

  const CustomSnackbarWidget({
    super.key,
    required this.message,
    this.type = SnackbarType.info,
    this.actionLabel,
    this.onAction,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = CustomSnackbar._getSnackbarConfig(type);

    return Container(
      padding: EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: backgroundColor ?? config.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadii.m),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (customIcon != null)
            customIcon!
          else
            Icon(
              icon ?? config.icon,
              color: textColor ?? config.textColor,
              size: 20,
            ),
          SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor ?? config.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(width: AppSpacing.s),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: textColor ?? config.textColor,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.s,
                  vertical: AppSpacing.xs,
                ),
              ),
              child: Text(
                actionLabel!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: textColor ?? config.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Animated snackbar widget with slide up/down animation
class _AnimatedSnackbar extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onDismiss;
  final Duration duration;

  const _AnimatedSnackbar({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    this.actionLabel,
    this.onAction,
    required this.onDismiss,
    required this.duration,
  });

  @override
  State<_AnimatedSnackbar> createState() => _AnimatedSnackbarState();
}

class _AnimatedSnackbarState extends State<_AnimatedSnackbar>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from bottom
      end: Offset.zero, // End at normal position
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    // Start animations
    _slideController.forward();
    _fadeController.forward();

    // Auto dismiss after duration
    Future.delayed(widget.duration, () {
      _dismiss();
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (!_isDisposed && mounted) {
      _slideController.reverse().then((_) {
        if (!_isDisposed && mounted) {
          _fadeController.reverse().then((_) {
            if (mounted) {
              widget.onDismiss();
            }
          });
        } else {
          widget.onDismiss();
        }
      });
    } else {
      widget.onDismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            margin: EdgeInsets.all(AppSpacing.l),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.l,
              vertical: AppSpacing.m,
            ),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(AppRadii.m),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(widget.icon, color: widget.textColor, size: 20),
                SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Text(
                    widget.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: widget.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (widget.actionLabel != null && widget.onAction != null) ...[
                  SizedBox(width: AppSpacing.s),
                  TextButton(
                    onPressed: () {
                      widget.onAction?.call();
                      _dismiss();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: widget.textColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.s,
                        vertical: AppSpacing.xs,
                      ),
                    ),
                    child: Text(
                      widget.actionLabel!,
                      style: TextStyle(
                        color: widget.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
