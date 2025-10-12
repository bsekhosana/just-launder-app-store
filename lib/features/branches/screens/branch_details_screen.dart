import 'package:flutter/material.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../ui/primitives/card_x.dart';
import '../../../ui/primitives/animated_button.dart';
import '../data/models/laundrette_branch.dart';
import 'add_edit_branch_screen.dart';
import '../widgets/branch_stats_widget.dart';

class BranchDetailsScreen extends StatelessWidget {
  final LaundretteBranch branch;

  const BranchDetailsScreen({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          branch.name,
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: AnimatedButton(
              onPressed: () => _editBranch(context),
              backgroundColor: Colors.white,
              width: 48,
              height: 48,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white, width: 1),
              tooltip: 'Edit Branch',
              child: Align(
                alignment: Alignment.center,
                child: Icon(Icons.edit, color: AppColors.primary, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BranchStatsWidget(branch: branch),
            const SizedBox(height: AppSpacing.m),
            _buildStatusCard(context),
            const SizedBox(height: AppSpacing.m),
            _buildBasicInfoCard(context),
            const SizedBox(height: AppSpacing.m),
            _buildOperatingHoursCard(context),
            const SizedBox(height: AppSpacing.m),
            _buildPricingCard(context),
            const SizedBox(height: AppSpacing.m),
            _buildSettingsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status',
                  style: AppTypography.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        branch.isCurrentlyOpen
                            ? AppColors.successGreen.withOpacity(0.1)
                            : AppColors.errorRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          branch.isCurrentlyOpen
                              ? AppColors.successGreen
                              : AppColors.errorRed,
                    ),
                  ),
                  child: Text(
                    branch.isCurrentlyOpen ? 'OPEN' : 'CLOSED',
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color:
                          branch.isCurrentlyOpen
                              ? AppColors.successGreen
                              : AppColors.errorRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatusItem(
                  context,
                  'Branch Status',
                  branch.status.name.toUpperCase(),
                  _getStatusColor(branch.status),
                ),
                const SizedBox(width: 24),
                _buildStatusItem(
                  context,
                  'Orders',
                  '${branch.currentOrderCount}/${branch.maxConcurrentOrders}',
                  AppColors.primaryBlue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.mediumGrey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoCard(BuildContext context) {
    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.m),
            _buildInfoRow(context, 'Name', branch.name),
            if (branch.description != null)
              _buildInfoRow(context, 'Description', branch.description!),
            _buildInfoRow(context, 'Address', branch.fullAddress),
            if (branch.phoneNumber != null)
              _buildInfoRow(context, 'Phone', branch.phoneNumber!),
            if (branch.email != null)
              _buildInfoRow(context, 'Email', branch.email!),
            _buildInfoRow(
              context,
              'Max Orders',
              branch.maxConcurrentOrders.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatingHoursCard(BuildContext context) {
    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Operating Hours',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.m),
            ...branch.operatingHours.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      entry.value,
                      style: TextStyle(
                        color:
                            entry.value.toLowerCase() == 'closed'
                                ? AppColors.errorRed
                                : AppColors.darkGrey,
                        fontWeight:
                            entry.value.toLowerCase() == 'closed'
                                ? FontWeight.w600
                                : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCard(BuildContext context) {
    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'Bag Pricing',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...branch.bagPricing.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key.replaceAll('_', ' ').toUpperCase()),
                    Text(
                      '£${entry.value.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: AppSpacing.m),
            Text(
              'Service Pricing',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...branch.servicePricing.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key.replaceAll('_', ' ').toUpperCase()),
                    Text(
                      '£${entry.value.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.m),
            _buildSettingItem(
              context,
              'Auto Accept Orders',
              branch.autoAcceptOrders,
              'Automatically accept incoming orders',
            ),
            _buildSettingItem(
              context,
              'Priority Delivery',
              branch.supportsPriorityDelivery,
              'Support priority delivery service',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    bool value,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? AppColors.successGreen : AppColors.errorRed,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.mediumGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.mediumGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.darkGrey),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BranchStatus status) {
    switch (status) {
      case BranchStatus.active:
        return AppColors.successGreen;
      case BranchStatus.inactive:
        return AppColors.mediumGrey;
      case BranchStatus.maintenance:
        return AppColors.warningOrange;
    }
  }

  void _editBranch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditBranchScreen(branch: branch, isEdit: true),
      ),
    );
  }
}
