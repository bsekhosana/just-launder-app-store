import 'package:flutter/material.dart';
import '../color_schemes.dart';
import '../typography.dart';
import '../spacing.dart';
import '../radii.dart';
import '../icons.dart';

/// Reusable action sheet component with 90% screen coverage
/// Uses design system theming for consistent look and feel
/// Replaces popup modals throughout the app
class AppActionSheet extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? titleWidget;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final Widget child;
  final List<AppActionSheetAction>? actions;
  final bool showCloseButton;
  final bool isDismissible;
  final EdgeInsets? contentPadding;
  final Color? backgroundColor;
  final double? heightFraction; // Fraction of screen height (default 0.9)

  const AppActionSheet({
    super.key,
    this.title,
    this.subtitle,
    this.titleWidget,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    required this.child,
    this.actions,
    this.showCloseButton = true,
    this.isDismissible = true,
    this.contentPadding,
    this.backgroundColor,
    this.heightFraction = 0.9,
  });

  /// Show the action sheet
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? subtitle,
    Widget? titleWidget,
    IconData? icon,
    Color? iconColor,
    Color? iconBackgroundColor,
    required Widget child,
    List<AppActionSheetAction>? actions,
    bool showCloseButton = true,
    bool isDismissible = true,
    EdgeInsets? contentPadding,
    Color? backgroundColor,
    double? heightFraction = 0.9,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      backgroundColor: Colors.transparent,
      builder:
          (context) => AppActionSheet(
            title: title,
            subtitle: subtitle,
            titleWidget: titleWidget,
            icon: icon,
            iconColor: iconColor,
            iconBackgroundColor: iconBackgroundColor,
            actions: actions,
            showCloseButton: showCloseButton,
            isDismissible: isDismissible,
            contentPadding: contentPadding,
            backgroundColor: backgroundColor,
            heightFraction: heightFraction,
            child: child,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final effectiveHeight = screenHeight * (heightFraction ?? 0.9);

    return Container(
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Radii.l),
          topRight: Radius.circular(Radii.l),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          if (isDismissible)
            Container(
              margin: const EdgeInsets.only(top: AppSpacing.s),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.onSurfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

          // Header
          if (title != null || titleWidget != null || showCloseButton)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.l,
                vertical: AppSpacing.m,
              ),
              child: Row(
                children: [
                  // Icon
                  if (icon != null)
                    Container(
                      margin: const EdgeInsets.only(right: AppSpacing.s),
                      padding: const EdgeInsets.all(AppSpacing.s),
                      decoration: BoxDecoration(
                        color:
                            iconBackgroundColor ??
                            AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Radii.s),
                      ),
                      child: Icon(
                        icon,
                        color: iconColor ?? AppColors.primary,
                        size: 20,
                      ),
                    ),

                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (titleWidget != null)
                          titleWidget!
                        else if (title != null)
                          Text(
                            title!,
                            style: AppTypography.textTheme.titleLarge?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              subtitle!,
                              style: AppTypography.textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Close button
                  if (showCloseButton)
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        AppIcons.close,
                        color: AppColors.onSurfaceVariant,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.onSurfaceVariant.withOpacity(
                          0.1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Radii.s),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // Content
          Expanded(
            child: Container(
              width: double.infinity,
              padding:
                  contentPadding ??
                  const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l,
                    vertical: AppSpacing.s,
                  ),
              child: child,
            ),
          ),

          // Actions
          if (actions != null && actions!.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.l),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(
                    color: AppColors.outline.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children:
                    actions!.map((action) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                          ),
                          child: action,
                        ),
                      );
                    }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

/// Action button for the action sheet
class AppActionSheetAction extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isDestructive;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;

  const AppActionSheetAction({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        backgroundColor ??
        (isPrimary
            ? AppColors.primary
            : isDestructive
            ? AppColors.error
            : AppColors.surface);

    final effectiveTextColor =
        textColor ??
        (isPrimary || isDestructive
            ? AppColors.onPrimary
            : AppColors.onSurface);

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveTextColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.m,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.m),
          side:
              isPrimary || isDestructive
                  ? BorderSide.none
                  : BorderSide(
                    color: AppColors.outline.withOpacity(0.3),
                    width: 1,
                  ),
        ),
      ),
      child:
          isLoading
              ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                ),
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Text(
                    text,
                    style: AppTypography.textTheme.labelLarge?.copyWith(
                      color: effectiveTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
    );
  }
}
