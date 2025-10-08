import 'package:flutter/material.dart';
import '../../design_system/color_schemes.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../design_system/motion.dart';

/// An animated wrapper for auth screens with smooth transitions
class AnimatedAuthScreen extends StatefulWidget {
  final Widget child;
  final String title;
  final String subtitle;
  final Widget? icon;
  final bool showAppBar;

  const AnimatedAuthScreen({
    super.key,
    required this.child,
    required this.title,
    required this.subtitle,
    this.icon,
    this.showAppBar = false,
  });

  @override
  State<AnimatedAuthScreen> createState() => _AnimatedAuthScreenState();
}

class _AnimatedAuthScreenState extends State<AnimatedAuthScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: AppMotion.normal,
      vsync: this,
    );

    _slideController = AnimationController(
      duration: AppMotion.normal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          widget.showAppBar
              ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
              : null,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.xl),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with icon and text
                  _buildHeader(),

                  SizedBox(height: AppSpacing.xxl),

                  // Main content
                  widget.child,

                  SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(height: AppSpacing.l),
        // Icon
        if (widget.icon != null) ...[
          widget.icon!,
          SizedBox(height: AppSpacing.xxl),
        ],

        // Title
        Text(
          widget.title,
          style: AppTypography.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: AppSpacing.l),

        // Subtitle
        Text(
          widget.subtitle,
          style: AppTypography.textTheme.bodyLarge?.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Animated button with loading state and smooth transitions
class AnimatedAuthButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final double? width;

  const AnimatedAuthButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.width,
  });

  @override
  State<AnimatedAuthButton> createState() => _AnimatedAuthButtonState();
}

class _AnimatedAuthButtonState extends State<AnimatedAuthButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: AppMotion.fast, vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown:
                widget.isEnabled && !widget.isLoading
                    ? (_) => _controller.forward()
                    : null,
            onTapUp:
                widget.isEnabled && !widget.isLoading
                    ? (_) => _controller.reverse()
                    : null,
            onTapCancel:
                widget.isEnabled && !widget.isLoading
                    ? () => _controller.reverse()
                    : null,
            onTap:
                widget.isEnabled && !widget.isLoading ? widget.onPressed : null,
            child: Container(
              width: widget.width ?? double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color:
                    widget.isEnabled && !widget.isLoading
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                boxShadow:
                    widget.isEnabled && !widget.isLoading
                        ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                        : null,
              ),
              child: Center(
                child:
                    widget.isLoading
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.onPrimary, // Always white loader
                            ),
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                widget.icon,
                                color:
                                    widget.isEnabled
                                        ? AppColors.onPrimary
                                        : AppColors.onSurfaceVariant,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              widget.text,
                              style: AppTypography.textTheme.labelLarge
                                  ?.copyWith(
                                    color:
                                        widget.isEnabled
                                            ? AppColors.onPrimary
                                            : AppColors.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
              ),
            ),
          ),
        );
      },
    );
  }
}
