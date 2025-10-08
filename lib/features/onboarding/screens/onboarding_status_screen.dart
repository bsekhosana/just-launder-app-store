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
          title: const Text('Onboarding Status'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Consumer<OnboardingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card with Progress
                CardsX.elevated(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.l),
                    child: Column(
                      children: [
                        // Status Icon and Title
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.m),
                              decoration: BoxDecoration(
                                color:
                                    status.isCompleted
                                        ? AppColors.success.withOpacity(0.1)
                                        : AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                status.isCompleted
                                    ? Icons.check_circle
                                    : Icons.pending_actions,
                                color:
                                    status.isCompleted
                                        ? AppColors.success
                                        : AppColors.primary,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.m),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    status.isCompleted
                                        ? 'Onboarding Complete!'
                                        : 'Setup Your Business',
                                    style: AppTypography.textTheme.headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    status.isCompleted
                                        ? 'Your account is ready to use'
                                        : '${status.completedSteps.length} of ${status.totalSteps} steps completed',
                                    style: AppTypography.textTheme.bodyMedium
                                        ?.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.l),

                        // Progress Bar
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Progress',
                                  style: AppTypography.textTheme.labelLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${status.progressPercentage.toInt()}%',
                                  style: AppTypography.textTheme.labelLarge
                                      ?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.s),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: status.progressPercentage / 100,
                                minHeight: 8,
                                backgroundColor: AppColors.surfaceVariant,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  status.isCompleted
                                      ? AppColors.success
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Steps Section
                Text(
                  'Onboarding Steps',
                  style: AppTypography.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.m),

                // Steps List
                ...status.steps.asMap().entries.map((entry) {
                  final index = entry.key;
                  final step = entry.value;
                  final isCompleted = status.completedSteps.contains(step.id);
                  final isCurrent =
                      !isCompleted && status.completedSteps.length == index;

                  return _buildStepCard(step, isCompleted, isCurrent);
                }),

                const SizedBox(height: AppSpacing.xl),

                // Action Buttons
                if (!status.isCompleted) ...[
                  AnimatedButton(
                    onPressed: () => _openWebOnboarding(status.webUrl),
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    height: 56,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.open_in_browser, size: 20),
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
                    onPressed: () => provider.loadOnboardingStatus(),
                    height: 56,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.refresh, size: 20),
                        const SizedBox(width: AppSpacing.s),
                        Text(
                          'Refresh Status',
                          style: AppTypography.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

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

  Widget _buildStepCard(OnboardingStep step, bool isCompleted, bool isCurrent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: CardsX.elevated(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Row(
            children: [
              // Step Icon
              Container(
                width: 48,
                height: 48,
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

              const SizedBox(width: AppSpacing.m),

              // Step Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            step.title,
                            style: AppTypography.textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight:
                                      isCurrent
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                  color:
                                      isCompleted
                                          ? AppColors.success
                                          : isCurrent
                                          ? AppColors.primary
                                          : AppColors.onSurface,
                                ),
                          ),
                        ),
                        if (step.webOnly)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Web Only',
                              style: AppTypography.textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step.description,
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Current Step',
                            style: AppTypography.textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (mounted) {
          CustomSnackbar.showSuccess(
            context,
            message: 'Opening website to complete onboarding...',
          );
        }
      } else {
        if (mounted) {
          CustomSnackbar.showError(
            context,
            message:
                'Could not open website. Please visit justlaunder.co.uk manually.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          context,
          message: 'Failed to open website: $e',
        );
      }
    }
  }
}
