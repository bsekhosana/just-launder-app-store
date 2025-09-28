import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../data/models/onboarding_status_model.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/custom_icon.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';

/// Onboarding status screen for tenant app
class OnboardingStatusScreen extends StatefulWidget {
  const OnboardingStatusScreen({super.key});

  @override
  State<OnboardingStatusScreen> createState() => _OnboardingStatusScreenState();
}

class _OnboardingStatusScreenState extends State<OnboardingStatusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingProvider>().loadOnboardingStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorSchemes.background,
      appBar: AppBar(
        title: const Text('Onboarding Status'),
        backgroundColor: AppColorSchemes.background,
        elevation: 0,
      ),
      body: Consumer<OnboardingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomIcon(
                    icon: Icons.error_outline,
                    size: 64,
                    color: AppColorSchemes.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading onboarding status',
                    style: AppTypography.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  CustomElevatedButton(
                    onPressed: () {
                      provider.loadOnboardingStatus();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final status = provider.onboardingStatus;
          if (status == null) {
            return const Center(child: Text('No onboarding data available'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status overview
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIcon(
                            icon:
                                status.isCompleted
                                    ? Icons.check_circle
                                    : Icons.pending,
                            color:
                                status.isCompleted
                                    ? AppColorSchemes.success
                                    : AppColorSchemes.warning,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              status.isCompleted
                                  ? 'Onboarding Complete'
                                  : 'Onboarding In Progress',
                              style: AppTypography.headlineSmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Current Step: ${status.currentStep}',
                        style: AppTypography.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: status.progress,
                        backgroundColor: AppColorSchemes.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          status.isCompleted
                              ? AppColorSchemes.success
                              : AppColorSchemes.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(status.progress * 100).toInt()}% Complete',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Steps list
                Text('Onboarding Steps', style: AppTypography.headlineSmall),
                const SizedBox(height: 16),

                ...status.steps.map((step) => _buildStepCard(step)),

                const SizedBox(height: 24),

                // Action buttons
                if (!status.isCompleted) ...[
                  CustomElevatedButton(
                    onPressed: () {
                      _showGoToWebDialog(context);
                    },
                    child: const Text('Complete Onboarding on Web'),
                  ),
                  const SizedBox(height: 12),
                ],

                if (status.isCompleted && status.summary != null) ...[
                  CustomElevatedButton(
                    onPressed: () {
                      _showSummaryDialog(context, status.summary!);
                    },
                    child: const Text('View Summary'),
                  ),
                  const SizedBox(height: 12),
                ],

                if (status.isCompleted) ...[
                  CustomElevatedButton(
                    onPressed: () {
                      context.read<OnboardingProvider>().submitOnboarding();
                    },
                    child: const Text('Submit for Review'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepCard(OnboardingStepModel step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Row(
          children: [
            CustomIcon(
              icon:
                  step.isCompleted
                      ? Icons.check_circle
                      : step.isCurrent
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
              color:
                  step.isCompleted
                      ? AppColorSchemes.success
                      : step.isCurrent
                      ? AppColorSchemes.primary
                      : AppColorSchemes.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight:
                          step.isCurrent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (step.description != null) ...[
                    const SizedBox(height: 4),
                    Text(step.description!, style: AppTypography.bodySmall),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGoToWebDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Complete Onboarding'),
            content: const Text(
              'To complete your onboarding, please visit our website to upload documents and complete the required steps.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Open web browser or in-app web view
                  _openWebOnboarding();
                },
                child: const Text('Go to Website'),
              ),
            ],
          ),
    );
  }

  void _showSummaryDialog(BuildContext context, Map<String, dynamic> summary) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Onboarding Summary'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children:
                    summary.entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${entry.key}: ',
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    entry.value.toString(),
                                    style: AppTypography.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            actions: [
              CustomElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _openWebOnboarding() {
    // TODO: Implement web browser opening or in-app web view
    // This could use url_launcher or webview_flutter
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Opening web browser...')));
  }
}
