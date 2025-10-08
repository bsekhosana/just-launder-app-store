import 'package:flutter/material.dart';
import '../../design_system/color_schemes.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../design_system/radii.dart';
import '../../design_system/motion.dart';
import '../../design_system/icons.dart';
import '../../design_system/elevations.dart';
import '../../design_system/spacing_utils.dart';
import 'animated_button.dart';

/// Modern accordion widget with smooth animations
class AccordionX extends StatefulWidget {
  final String title;
  final Widget content;
  final bool isExpanded;
  final VoidCallback? onToggle;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? titleColor;
  final IconData? icon;
  final bool showIcon;

  const AccordionX({
    super.key,
    required this.title,
    required this.content,
    this.isExpanded = false,
    this.onToggle,
    this.padding,
    this.backgroundColor,
    this.titleColor,
    this.icon,
    this.showIcon = true,
  });

  @override
  State<AccordionX> createState() => _AccordionXState();
}

class _AccordionXState extends State<AccordionX>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
    _controller = AnimationController(duration: AppMotion.normal, vsync: this);
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AccordionX oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != _isExpanded) {
      _toggle();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    widget.onToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveBackgroundColor =
        widget.backgroundColor ?? colorScheme.surface;
    final effectiveTitleColor = widget.titleColor ?? colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(Radii.card),
        boxShadow: Shadows.card,
      ),
      child: Column(
        children: [
          // Header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggle,
              borderRadius: BorderRadius.circular(Radii.card),
              child: Container(
                padding: widget.padding ?? SpacingUtils.all(AppSpacing.l),
                child: Row(
                  children: [
                    if (widget.showIcon && widget.icon != null) ...[
                      Icon(widget.icon, color: effectiveTitleColor, size: 20),
                      const SizedBox(width: AppSpacing.s),
                    ],
                    Expanded(
                      child: Text(
                        widget.title,
                        style: AppTypography.textTheme.titleMedium?.copyWith(
                          color: effectiveTitleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _rotateAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotateAnimation.value * 3.14159,
                          child: Icon(
                            AppIcons.down,
                            color: effectiveTitleColor,
                            size: 20,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  heightFactor: _expandAnimation.value,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: widget.padding ?? SpacingUtils.all(AppSpacing.l),
              child: widget.content,
            ),
          ),
        ],
      ),
    );
  }
}

/// Demo account item for the accordion
class DemoAccountItem extends StatelessWidget {
  final String accountType;
  final String email;
  final String password;
  final VoidCallback? onEmailCopy;
  final VoidCallback? onPasswordCopy;

  const DemoAccountItem({
    super.key,
    required this.accountType,
    required this.email,
    required this.password,
    this.onEmailCopy,
    this.onPasswordCopy,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: SpacingUtils.all(AppSpacing.m),
      margin: const EdgeInsets.only(bottom: AppSpacing.s),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(Radii.m),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Account Type Title
          Row(
            children: [
              Icon(AppIcons.branch, size: 16, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                accountType,
                style: AppTypography.textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          // Email Row (Right aligned)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Email:',
                style: AppTypography.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Row(
                children: [
                  Text(
                    email,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  AnimatedButton(
                    onPressed: onEmailCopy,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    foregroundColor: AppColors.primary,
                    child: Icon(
                      AppIcons.copy,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    tooltip: 'Copy email',
                    width: 32,
                    height: 32,
                    borderRadius: BorderRadius.circular(Radii.lg),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // Password Row (Right aligned)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Password:',
                style: AppTypography.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Row(
                children: [
                  Text(
                    password,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  AnimatedButton(
                    onPressed: onPasswordCopy,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    foregroundColor: AppColors.primary,
                    child: Icon(
                      AppIcons.copy,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    tooltip: 'Copy password',
                    width: 32,
                    height: 32,
                    borderRadius: BorderRadius.circular(Radii.lg),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
