import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../design_system/theme.dart';
import '../../../core/widgets/animated_button.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/watermark_background.dart';
import '../providers/branch_configuration_provider.dart';

/// Screen for Stripe Connect setup and management
class StripeConnectScreen extends StatefulWidget {
  const StripeConnectScreen({super.key});

  @override
  State<StripeConnectScreen> createState() => _StripeConnectScreenState();
}

class _StripeConnectScreenState extends State<StripeConnectScreen> {
  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final provider = context.read<BranchConfigurationProvider>();
    await provider.loadStripeConnectStatus();
  }

  Future<void> _setupStripeConnect() async {
    final provider = context.read<BranchConfigurationProvider>();

    final url = await provider.createStripeConnectLink();

    if (url != null) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        
        if (mounted) {
          CustomSnackbar.showSuccess(
            context,
            'Opening Stripe Connect setup...',
          );
        }
      } else {
        if (mounted) {
          CustomSnackbar.showError(
            context,
            'Could not open Stripe Connect',
          );
        }
      }
    } else if (mounted) {
      CustomSnackbar.showError(
        context,
        provider.errorMessage ?? 'Failed to create setup link',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Stripe Connect'),
        elevation: 0,
      ),
      body: WatermarkBackground(
        icon: FontAwesomeIcons.stripe,
        child: Consumer<BranchConfigurationProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingStripe) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final isConnected = provider.isStripeConnected;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Status card
                  CardX(
                    elevation: AppElevations.card,
                    borderRadius: AppRadii.l,
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    backgroundColor: isConnected
                        ? AppColors.successContainer
                        : AppColors.warningContainer,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.l),
                          decoration: BoxDecoration(
                            color: isConnected
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.warning.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isConnected
                                ? FontAwesomeIcons.circleCheck
                                : FontAwesomeIcons.triangleExclamation,
                            size: 48,
                            color: isConnected
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        Text(
                          isConnected
                              ? 'Stripe Connected'
                              : 'Stripe Not Connected',
                          style: AppTypography.textTheme.headlineMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isConnected
                                ? AppColors.onSuccessContainer
                                : AppColors.onWarningContainer,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s),
                        Text(
                          isConnected
                              ? 'Your account is connected and ready to receive payouts'
                              : 'Connect your Stripe account to receive direct payouts',
                          style: AppTypography.textTheme.bodyMedium?.copyWith(
                            color: isConnected
                                ? AppColors.onSuccessContainer
                                : AppColors.onWarningContainer,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (isConnected && provider.stripeAccountId != null) ...[
                          const SizedBox(height: AppSpacing.m),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.m,
                              vertical: AppSpacing.s,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppRadii.m),
                            ),
                            child: Text(
                              'Account: ${provider.stripeAccountId}',
                              style: AppTypography.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppColors.onSuccessContainer,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Benefits section
                  CardX(
                    elevation: AppElevations.card,
                    borderRadius: AppRadii.l,
                    padding: const EdgeInsets.all(AppSpacing.l),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.lightbulb,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.m),
                            Text(
                              'Benefits',
                              style: AppTypography.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.l),
                        _buildBenefitItem(
                          'Instant payouts directly to your bank account',
                        ),
                        _buildBenefitItem('No transfer fees for direct payouts'),
                        _buildBenefitItem('Automatic payout scheduling'),
                        _buildBenefitItem('Secure and PCI compliant'),
                        _buildBenefitItem('Real-time balance tracking'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Action button
                  if (!isConnected)
                    AnimatedButton(
                      onPressed: provider.isLoadingStripe
                          ? null
                          : _setupStripeConnect,
                      backgroundColor: AppColors.primary,
                      child: provider.isLoadingStripe
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.stripe,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                SizedBox(width: AppSpacing.m),
                                Text(
                                  'Connect with Stripe',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                    )
                  else
                    AnimatedButton(
                      onPressed: _loadStatus,
                      backgroundColor: AppColors.success,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.arrowRotateRight,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: AppSpacing.m),
                          Text(
                            'Refresh Status',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            FontAwesomeIcons.circleCheck,
            size: 16,
            color: AppColors.success,
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Text(
              text,
              style: AppTypography.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

