import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/onboarding_provider.dart';
import '../data/models/onboarding_status_model.dart';
import '../../../ui/primitives/card_x.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../navigation/screens/main_navigation_screen.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/watermark_background.dart';
import '../../auth/providers/auth_provider.dart';

/// Onboarding status screen for tenant app
class OnboardingStatusScreen extends StatefulWidget {
  const OnboardingStatusScreen({super.key});

  @override
  State<OnboardingStatusScreen> createState() => _OnboardingStatusScreenState();
}

class _OnboardingStatusScreenState extends State<OnboardingStatusScreen> {
  Timer? _pollingTimer;
  static const int _pollingIntervalSeconds = 15;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    // Load immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingProvider>().loadOnboardingStatus();
    });

    // Then poll every 15 seconds
    _pollingTimer = Timer.periodic(
      const Duration(seconds: _pollingIntervalSeconds),
      (timer) async {
        if (!mounted) {
          timer.cancel();
          return;
        }

        final provider = context.read<OnboardingProvider>();
        await provider.loadOnboardingStatus();

        // Check if onboarding is completed
        if (provider.onboardingStatus?.isCompleted == true) {
          timer.cancel();
          if (mounted) {
            CustomSnackbar.showSuccess(
              context,
              message: 'Onboarding completed! Welcome to Just Laundrette.',
            );
            await Future.delayed(const Duration(milliseconds: 500));
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const MainNavigationScreen(),
                ),
                (route) => false,
              );
            }
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WatermarkBackgroundBuilder.bottomRight(
      icon: FontAwesomeIcons.store,
      iconColor: AppColors.primary.withOpacity(0.08),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Consumer<OnboardingProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.onboardingStatus == null) {
                // Only show full screen loader on initial load
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                );
              }

              if (provider.error != null) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: AppSpacing.l),
                      Text(
                        'Error loading onboarding status',
                        style: AppTypography.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.s),
                      Text(
                        provider.error!,
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AnimatedButton(
                        onPressed: () {
                          provider.loadOnboardingStatus();
                        },
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final status = provider.onboardingStatus;
              if (status == null) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Center(
                    child: Text(
                      'No onboarding data available',
                      style: AppTypography.textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header Section
                    _buildHeader(status),

                    const SizedBox(height: AppSpacing.xxl),

                    // Progress Carousel Card
                    _buildProgressCarousel(status),

                    const SizedBox(height: AppSpacing.xl),

                    // Timeline
                    _buildTimeline(status),

                    const SizedBox(height: AppSpacing.xl),

                    // Action Buttons
                    _buildActionButtons(status, provider),

                    const SizedBox(height: AppSpacing.xl),

                    // Logout Button
                    AnimatedButton(
                      onPressed: () => _showLogoutConfirmation(context),
                      backgroundColor: AppColors.surfaceVariant,
                      foregroundColor: AppColors.onSurfaceVariant,
                      height: 56,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.logout,
                            size: 20,
                            color: AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppSpacing.s),
                          Text(
                            'Logout',
                            style: AppTypography.textTheme.labelLarge?.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(OnboardingStatusModel status) {
    return Column(
      children: [
        // Header Icon
        Container(
          padding: const EdgeInsets.all(AppSpacing.l),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            FontAwesomeIcons.clipboardList,
            color: AppColors.primary,
            size: 32,
          ),
        ),
        const SizedBox(height: AppSpacing.l),

        // Title
        Text(
          'Setup Your Business',
          style: AppTypography.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.s),

        // Subtitle
        Text(
          status.isCompleted
              ? 'Your account is ready to use'
              : 'Complete these steps to get started with Just Laundrette',
          style: AppTypography.textTheme.bodyLarge?.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressCarousel(OnboardingStatusModel status) {
    return Container(
      height: 240,
      child: PageView.builder(
        controller: PageController(
          initialPage: status.currentStep - 1,
          viewportFraction: 0.8,
        ),
        itemCount: status.steps.length,
        itemBuilder: (context, index) {
          final step = status.steps[index];
          final isCompleted = status.completedSteps.contains(step.id);
          final isCurrent =
              !isCompleted && status.completedSteps.length == index;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
            child: CardsX.elevated(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Step Icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            isCompleted
                                ? AppColors.success.withOpacity(0.1)
                                : isCurrent
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.surfaceVariant,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child:
                            isCompleted
                                ? const Icon(
                                  Icons.check,
                                  color: AppColors.success,
                                  size: 24,
                                )
                                : Icon(
                                  _getIconForStep(step.icon),
                                  color:
                                      isCurrent
                                          ? AppColors.primary
                                          : AppColors.onSurfaceVariant,
                                  size: 20,
                                ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s),

                    // Step Title
                    Text(
                      step.title,
                      style: AppTypography.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            isCompleted
                                ? AppColors.success
                                : isCurrent
                                ? AppColors.primary
                                : AppColors.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Step Description
                    Text(
                      step.description,
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeline(OnboardingStatusModel status) {
    return CardsX.elevated(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress Overview',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.l),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: status.progressPercentage / 100,
                minHeight: 8,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  status.isCompleted ? AppColors.success : AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.m),

            // Progress Text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${status.completedSteps.length} of ${status.totalSteps} steps completed',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${status.progressPercentage.toInt()}%',
                  style: AppTypography.textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    OnboardingStatusModel status,
    OnboardingProvider provider,
  ) {
    if (status.isCompleted) {
      return AnimatedButton(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainNavigationScreen(),
            ),
            (route) => false,
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 20, color: AppColors.onPrimary),
            const SizedBox(width: AppSpacing.s),
            Text(
              'Go to Dashboard',
              style: AppTypography.textTheme.labelLarge?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        AnimatedButton(
          onPressed: () => _openWebOnboarding(status.webUrl),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.open_in_browser,
                size: 20,
                color: AppColors.onPrimary,
              ),
              const SizedBox(width: AppSpacing.s),
              Text(
                'Complete on Website',
                style: AppTypography.textTheme.labelLarge?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        AnimatedButton(
          onPressed: provider.isLoading ? null : () => provider.loadOnboardingStatus(),
          backgroundColor: AppColors.surfaceVariant,
          foregroundColor: AppColors.onSurfaceVariant,
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (provider.isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.onSurfaceVariant),
                  ),
                )
              else
                const Icon(
                  Icons.refresh,
                  size: 20,
                  color: AppColors.onSurfaceVariant,
                ),
              const SizedBox(width: AppSpacing.s),
              Text(
                provider.isLoading ? 'Refreshing...' : 'Refresh Status',
                style: AppTypography.textTheme.labelLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getIconForStep(String iconName) {
    switch (iconName) {
      case 'user':
        return FontAwesomeIcons.user;
      case 'building':
        return FontAwesomeIcons.building;
      case 'file-text':
        return FontAwesomeIcons.fileLines;
      case 'credit-card':
        return FontAwesomeIcons.creditCard;
      case 'package':
        return FontAwesomeIcons.box;
      case 'map-pin':
        return FontAwesomeIcons.mapPin;
      case 'settings':
        return FontAwesomeIcons.gear;
      default:
        return FontAwesomeIcons.circle;
    }
  }

  Future<void> _openWebOnboarding(String url) async {
    try {
      final uri = Uri.parse(url);

      // Try to launch the URL
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (launched && mounted) {
        CustomSnackbar.showSuccess(
          context,
          message: 'Opening website to complete onboarding...',
        );
      } else if (mounted) {
        CustomSnackbar.showError(
          context,
          message:
              'Could not open website. Please visit justlaunder.co.uk manually.',
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          context,
          message:
              'Failed to open website. Please visit justlaunder.co.uk manually.',
        );
      }
    }
  }

  /// Show logout confirmation dialog
  void _showLogoutConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppSpacing.l),

                // Error icon
                Container(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: AppColors.error,
                    size: 32,
                  ),
                ),
                const SizedBox(height: AppSpacing.l),

                // Title
                Text(
                  'Logout',
                  style: AppTypography.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),

                // Message
                Text(
                  'Are you sure you want to logout? You will need to login again to access your account.',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: AnimatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        backgroundColor: AppColors.surfaceVariant,
                        foregroundColor: AppColors.onSurfaceVariant,
                        height: 48,
                        child: Text(
                          'Cancel',
                          style: AppTypography.textTheme.labelLarge?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: AnimatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await _performLogout(context);
                        },
                        backgroundColor: AppColors.error,
                        foregroundColor: AppColors.onPrimary,
                        height: 48,
                        child: Text(
                          'Logout',
                          style: AppTypography.textTheme.labelLarge?.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.l),
              ],
            ),
          ),
    );
  }

  /// Perform logout action
  Future<void> _performLogout(BuildContext context) async {
    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.logout();

      if (mounted) {
        CustomSnackbar.showSuccess(context, message: 'Logged out successfully');

        // Navigate back to login screen
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(context, message: 'Failed to logout: $e');
      }
    }
  }
}
