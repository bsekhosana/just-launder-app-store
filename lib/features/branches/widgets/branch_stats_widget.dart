import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/laundrette_branch.dart';

class BranchStatsWidget extends StatelessWidget {
  final LaundretteBranch branch;

  const BranchStatsWidget({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Branch Statistics',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Orders Today',
                    '12',
                    Icons.shopping_bag,
                    AppTheme.primaryBlue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Revenue Today',
                    '\$245.50',
                    Icons.attach_money,
                    AppTheme.successGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Capacity',
                    '${branch.currentOrderCount}/${branch.maxConcurrentOrders}',
                    Icons.storage,
                    AppTheme.warningOrange,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Efficiency',
                    '85%',
                    Icons.trending_up,
                    AppTheme.primaryTeal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatusIndicator(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGrey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    final statusColor =
        branch.isCurrentlyOpen ? AppTheme.successGreen : AppTheme.errorRed;
    final statusText = branch.isCurrentlyOpen ? 'Open' : 'Closed';
    final statusIcon =
        branch.isCurrentlyOpen ? Icons.check_circle : Icons.cancel;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 8),
          Text(
            'Branch is $statusText',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (branch.autoAcceptOrders)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'AUTO ACCEPT',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
