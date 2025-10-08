import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/onboarding_provider.dart';
import '../../../ui/primitives/card_x.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../navigation/screens/main_navigation_screen.dart';
import '../../../core/widgets/custom_snackbar.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Onboarding Status'),
        backgroundColor: AppColors.background,
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
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
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
                  AnimatedButton(
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
                CardsX.elevated(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              status.isCompleted
                                  ? Icons.check_circle
                                  : Icons.pending,
                              color:
                                  status.isCompleted
                                      ? AppColors.success
                                      : AppColors.warning,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                status.isCompleted
                                    ? 'Onboarding Complete'
                                    : 'Onboarding In Progress',
                                style: AppTypography.textTheme.headlineSmall,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Status: ${status.isCompleted ? "Completed" : "Pending"}',
                          style: AppTypography.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        if (status.progress.isNotEmpty) ...[
                          Text(
                            'Progress Details:',
                            style: AppTypography.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...status.progress.entries.map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Icon(
                                  entry.value == true ? Icons.check_circle : Icons.circle_outlined,
                                  size: 16,
                                  color: entry.value == true ? AppColors.success : AppColors.onSurfaceVariant,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    entry.key.replaceAll('_', ' ').toUpperCase(),
                                    style: AppTypography.textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Action buttons
                if (!status.isCompleted) ...[
                  AnimatedButton(
                    onPressed: () {
                      _showGoToWebDialog(context);
                    },
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    child: const Text('Complete Onboarding on Website'),
                  ),
                  const SizedBox(height: 12),
                  AnimatedButton(
                    onPressed: () {
                      provider.loadOnboardingStatus();
                    },
                    child: const Text('Refresh Status'),
                  ),
                ],
              ],
            ),
          );
        },
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
              AnimatedButton(
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


  Future<void> _openWebOnboarding() async {
    const url = 'https://justlaunder.co.uk/tenant/onboarding';

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
