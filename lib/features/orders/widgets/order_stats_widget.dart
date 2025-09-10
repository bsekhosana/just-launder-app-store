import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/laundrette_order.dart';

class OrderStatsWidget extends StatelessWidget {
  final List<LaundretteOrder> orders;

  const OrderStatsWidget({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final stats = _calculateStats();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Statistics',
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
                    'Total Orders',
                    stats.totalOrders.toString(),
                    Icons.shopping_bag,
                    AppTheme.primaryBlue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Pending',
                    stats.pendingOrders.toString(),
                    Icons.pending,
                    AppTheme.warningOrange,
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
                    'Completed',
                    stats.completedOrders.toString(),
                    Icons.check_circle,
                    AppTheme.successGreen,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Revenue',
                    '\$${stats.totalRevenue.toStringAsFixed(2)}',
                    Icons.attach_money,
                    AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatusBreakdown(context, stats),
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

  Widget _buildStatusBreakdown(BuildContext context, OrderStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status Breakdown',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        _buildStatusItem(
          context,
          'Approved',
          stats.approvedOrders,
          AppTheme.infoBlue,
        ),
        _buildStatusItem(
          context,
          'In Progress',
          stats.inProgressOrders,
          AppTheme.primaryGreen,
        ),
        _buildStatusItem(
          context,
          'Ready',
          stats.readyOrders,
          AppTheme.secondaryOrange,
        ),
        _buildStatusItem(
          context,
          'Delivered',
          stats.deliveredOrders,
          AppTheme.successGreen,
        ),
        _buildStatusItem(
          context,
          'Declined',
          stats.declinedOrders,
          AppTheme.errorRed,
        ),
      ],
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    String status,
    int count,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(status, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  OrderStats _calculateStats() {
    int totalOrders = orders.length;
    int pendingOrders =
        orders.where((o) => o.status == LaundretteOrderStatus.pending).length;
    int approvedOrders =
        orders.where((o) => o.status == LaundretteOrderStatus.approved).length;
    int inProgressOrders =
        orders
            .where((o) => o.status == LaundretteOrderStatus.inProgress)
            .length;
    int readyOrders =
        orders.where((o) => o.status == LaundretteOrderStatus.ready).length;
    int deliveredOrders =
        orders.where((o) => o.status == LaundretteOrderStatus.delivered).length;
    int declinedOrders =
        orders.where((o) => o.status == LaundretteOrderStatus.declined).length;
    int completedOrders = deliveredOrders;

    double totalRevenue = orders
        .where((o) => o.paymentStatus == PaymentStatus.paid)
        .fold(0.0, (sum, order) => sum + order.total);

    return OrderStats(
      totalOrders: totalOrders,
      pendingOrders: pendingOrders,
      approvedOrders: approvedOrders,
      inProgressOrders: inProgressOrders,
      readyOrders: readyOrders,
      deliveredOrders: deliveredOrders,
      declinedOrders: declinedOrders,
      completedOrders: completedOrders,
      totalRevenue: totalRevenue,
    );
  }
}

class OrderStats {
  final int totalOrders;
  final int pendingOrders;
  final int approvedOrders;
  final int inProgressOrders;
  final int readyOrders;
  final int deliveredOrders;
  final int declinedOrders;
  final int completedOrders;
  final double totalRevenue;

  OrderStats({
    required this.totalOrders,
    required this.pendingOrders,
    required this.approvedOrders,
    required this.inProgressOrders,
    required this.readyOrders,
    required this.deliveredOrders,
    required this.declinedOrders,
    required this.completedOrders,
    required this.totalRevenue,
  });
}
