import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/motion.dart';
// Removed unused imports
import '../../../ui/primitives/card_x.dart';
import '../../../ui/primitives/snack_x.dart';
import '../../../data/models/subscription.dart';
import '../../profile/providers/laundrette_profile_provider.dart';

class SubscriptionManagementScreen extends StatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  State<SubscriptionManagementScreen> createState() =>
      _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState
    extends State<SubscriptionManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Subscription Management',
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
      body: Consumer<LaundretteProfileProvider>(
        builder: (context, profileProvider, child) {
          final profile = profileProvider.currentProfile;
          final subscription = profileProvider.currentSubscription;
          if (profile == null || subscription == null) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return SingleChildScrollView(
            padding: SpacingUtils.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCurrentPlanCard(subscription)
                    .animate()
                    .fadeIn(duration: AppMotion.normal)
                    .slideY(begin: 0.1, end: 0.0),
                const SizedBox(height: AppSpacing.l),
                _buildPlanComparison()
                    .animate()
                    .fadeIn(delay: AppMotion.fast, duration: AppMotion.normal)
                    .slideY(begin: 0.1, end: 0.0),
                const SizedBox(height: AppSpacing.l),
                _buildBillingHistory()
                    .animate()
                    .fadeIn(delay: AppMotion.normal, duration: AppMotion.normal)
                    .slideY(begin: 0.1, end: 0.0),
                const SizedBox(height: AppSpacing.l),
                _buildUpgradeOptions(subscription)
                    .animate()
                    .fadeIn(delay: AppMotion.slow, duration: AppMotion.normal)
                    .slideY(begin: 0.1, end: 0.0),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentPlanCard(Subscription subscription) {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: _getPlanColor(subscription.type),
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.s),
                Text(
                  'Current Plan: ${subscription.type.name.toUpperCase()}',
                  style: AppTypography.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            _buildPlanDetails(subscription),
            const SizedBox(height: AppSpacing.m),
            _buildUsageStats(subscription),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanDetails(Subscription subscription) {
    return Column(
      children: [
        _buildDetailRow(
          'Monthly Cost',
          '£${subscription.monthlyPrice.toStringAsFixed(2)}',
        ),
        _buildDetailRow('Plan Tier', subscription.currentTier),
        _buildDetailRow(
          'Max Branches',
          subscription.getFeature(SubscriptionFeatures.maxBranches).toString(),
        ),
        _buildDetailRow(
          'Max Staff',
          subscription.getFeature(SubscriptionFeatures.maxStaff).toString(),
        ),
        _buildDetailRow(
          'Analytics',
          subscription.hasFeature(SubscriptionFeatures.advancedAnalytics)
              ? 'Included'
              : 'Not Included',
        ),
        _buildDetailRow(
          'Priority Support',
          subscription.hasFeature(SubscriptionFeatures.prioritySupport)
              ? 'Yes'
              : 'No',
        ),
        _buildDetailRow('Next Billing', _formatDate(subscription.endDate)),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageStats(Subscription subscription) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: SpacingUtils.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Usage',
            style: AppTypography.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          _buildUsageBar(
            'Branches',
            2,
            subscription.getFeature(SubscriptionFeatures.maxBranches),
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildUsageBar(
            'Staff',
            5,
            subscription.getFeature(SubscriptionFeatures.maxStaff),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageBar(String label, int current, int max) {
    final colorScheme = Theme.of(context).colorScheme;
    final percentage = (current / max).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              '$current / $max',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: AppColors.surfaceVariant.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(
            percentage > 0.8 ? AppColors.error : AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanComparison() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Plans',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildPlanCard(
          'Starter',
          '£29.99/month',
          'Perfect for small laundrettes',
          ['1 Branch', 'Up to 3 Staff', 'Basic Analytics', 'Email Support'],
          SubscriptionType.private,
        ),
        const SizedBox(height: 12),
        _buildPlanCard(
          'Professional',
          '£79.99/month',
          'Ideal for growing businesses',
          [
            'Up to 5 Branches',
            'Up to 15 Staff',
            'Advanced Analytics',
            'Priority Support',
            'Custom Branding',
          ],
          SubscriptionType.business,
        ),
        const SizedBox(height: 12),
        _buildPlanCard(
          'Enterprise',
          '£199.99/month',
          'For large operations',
          [
            'Unlimited Branches',
            'Unlimited Staff',
            'Full Analytics Suite',
            '24/7 Support',
            'API Access',
            'Custom Integrations',
          ],
          SubscriptionType
              .business, // Using business as fallback since enterprise doesn't exist
        ),
      ],
    );
  }

  Widget _buildPlanCard(
    String name,
    String price,
    String description,
    List<String> features,
    SubscriptionType type,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getPlanColor(type),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.check, color: AppColors.success, size: 16),
                    const SizedBox(width: 8),
                    Text(feature),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showUpgradeDialog(type),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getPlanColor(type),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Upgrade Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Billing History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              _buildBillingItem(
                'December 2024',
                '£79.99',
                'Professional Plan',
                true,
              ),
              _buildBillingItem(
                'November 2024',
                '£79.99',
                'Professional Plan',
                true,
              ),
              _buildBillingItem('October 2024', '£29.99', 'Starter Plan', true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBillingItem(String date, String amount, String plan, bool paid) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                plan,
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                paid ? Icons.check_circle : Icons.pending,
                color: paid ? AppColors.success : AppColors.warning,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeOptions(Subscription currentSubscription) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Upgrade Plan',
                Icons.trending_up,
                AppColors.success,
                () => _showUpgradeDialog(SubscriptionType.business),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Download Invoice',
                Icons.download,
                AppColors.primary,
                () => _downloadInvoice(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Payment Method',
                Icons.payment,
                AppColors.warning,
                () => _managePaymentMethod(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Cancel Subscription',
                Icons.cancel,
                AppColors.error,
                () => _showCancelDialog(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPlanColor(SubscriptionType type) {
    switch (type) {
      case SubscriptionType.private:
        return AppColors.primary;
      case SubscriptionType.business:
        return AppColors.success;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showUpgradeDialog(SubscriptionType newType) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Upgrade Plan'),
            content: Text(
              'Are you sure you want to upgrade to the ${newType.name} plan?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _upgradePlan(newType);
                },
                child: const Text('Upgrade'),
              ),
            ],
          ),
    );
  }

  void _upgradePlan(SubscriptionType newType) {
    // TODO: Implement plan upgrade logic
    SnackXUtils.showSuccess(
      context,
      message: 'Plan upgrade initiated. You will be redirected to payment.',
    );
  }

  void _downloadInvoice() {
    // TODO: Implement invoice download
    SnackXUtils.showInfo(context, message: 'Invoice download started...');
  }

  void _managePaymentMethod() {
    // TODO: Implement payment method management
    SnackXUtils.showInfo(
      context,
      message: 'Redirecting to payment management...',
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancel Subscription'),
            content: const Text(
              'Are you sure you want to cancel your subscription? You will lose access to premium features at the end of your billing period.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Keep Subscription'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _cancelSubscription();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text('Cancel Subscription'),
              ),
            ],
          ),
    );
  }

  void _cancelSubscription() {
    // TODO: Implement subscription cancellation
    SnackXUtils.showError(
      context,
      message: 'Subscription cancellation requested.',
    );
  }
}
