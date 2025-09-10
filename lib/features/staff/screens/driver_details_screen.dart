import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/staff_member.dart';
import '../../orders/providers/order_provider.dart';
import '../../../data/models/laundrette_order.dart';

class DriverDetailsScreen extends StatefulWidget {
  final StaffMember driver;

  const DriverDetailsScreen({super.key, required this.driver});

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.driver.fullName),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _editDriver),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Deliveries'),
            Tab(text: 'Performance'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildDeliveriesTab(),
          _buildPerformanceTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDriverInfoCard(),
          const SizedBox(height: 16),
          _buildStatusCard(),
          const SizedBox(height: 16),
          _buildWorkingHoursCard(),
          const SizedBox(height: 16),
          _buildRecentActivityCard(),
        ],
      ),
    );
  }

  Widget _buildDeliveriesTab() {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final driverOrders =
            orderProvider.orders
                .where((order) => order.driverId == widget.driver.id)
                .toList();

        if (driverOrders.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_shipping, size: 64, color: AppTheme.lightGrey),
                SizedBox(height: 16),
                Text(
                  'No deliveries yet',
                  style: TextStyle(fontSize: 18, color: AppTheme.mediumGrey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: driverOrders.length,
          itemBuilder: (context, index) {
            final order = driverOrders[index];
            return _buildDeliveryCard(order);
          },
        );
      },
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPerformanceStatsCard(),
          const SizedBox(height: 16),
          _buildRatingCard(),
          const SizedBox(height: 16),
          _buildEarningsCard(),
        ],
      ),
    );
  }

  Widget _buildDriverInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                  child:
                      widget.driver.profileImageUrl != null
                          ? ClipOval(
                            child: Image.network(
                              widget.driver.profileImageUrl!,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color: AppTheme.primaryBlue,
                                  size: 32,
                                );
                              },
                            ),
                          )
                          : Icon(
                            Icons.person,
                            color: AppTheme.primaryBlue,
                            size: 32,
                          ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.driver.fullName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.driver.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.mediumGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 16,
                            color: AppTheme.mediumGrey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.driver.phoneNumber ?? 'No phone',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTheme.mediumGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Driver ID', widget.driver.id),
            _buildInfoRow('Status', widget.driver.statusDisplayText),
            _buildInfoRow(
              'Joined',
              _formatDate(widget.driver.hireDate ?? widget.driver.createdAt),
            ),
            if (widget.driver.hourlyRate != null)
              _buildInfoRow(
                'Hourly Rate',
                '\$${widget.driver.hourlyRate!.toStringAsFixed(2)}/hr',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final isOnDelivery = _isDriverOnDelivery();
    final statusColor =
        isOnDelivery ? AppTheme.primaryGreen : AppTheme.successGreen;
    final statusText = isOnDelivery ? 'On Delivery' : 'Available';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Status',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor),
              ),
              child: Row(
                children: [
                  Icon(
                    isOnDelivery ? Icons.local_shipping : Icons.check_circle,
                    color: statusColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    statusText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (isOnDelivery) ...[
              const SizedBox(height: 12),
              Text(
                'ETA: 15 minutes',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGrey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWorkingHoursCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Working Hours',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...widget.driver.workingHours.entries.map((entry) {
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
                                ? AppTheme.errorRed
                                : AppTheme.darkGrey,
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

  Widget _buildRecentActivityCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              'Completed delivery',
              'Order #12345',
              '2 hours ago',
              Icons.check_circle,
              AppTheme.successGreen,
            ),
            _buildActivityItem(
              'Started delivery',
              'Order #12344',
              '4 hours ago',
              Icons.local_shipping,
              AppTheme.primaryBlue,
            ),
            _buildActivityItem(
              'Accepted delivery',
              'Order #12343',
              '6 hours ago',
              Icons.thumb_up,
              AppTheme.infoBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGrey),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard(LaundretteOrder order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getStatusColor(order.status)),
                  ),
                  child: Text(
                    order.statusDisplayText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              order.customerName,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGrey),
            ),
            const SizedBox(height: 4),
            Text(
              'Total: \$${order.total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate(order.createdAt),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGrey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Stats',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Deliveries',
                    '24',
                    AppTheme.primaryBlue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'This Week',
                    '8',
                    AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Success Rate',
                    '98%',
                    AppTheme.successGreen,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Avg. Time',
                    '25 min',
                    AppTheme.warningOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Rating',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.star, color: AppTheme.warningOrange, size: 32),
                const SizedBox(width: 8),
                Text(
                  '4.8',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '/ 5.0',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppTheme.mediumGrey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Based on 24 reviews',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGrey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Earnings',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'This Week',
                    '\$320',
                    AppTheme.primaryBlue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'This Month',
                    '\$1,250',
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
                    'Total',
                    '\$5,680',
                    AppTheme.primaryGreen,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Avg. per Delivery',
                    '\$25',
                    AppTheme.warningOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGrey),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
                color: AppTheme.mediumGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppTheme.darkGrey),
            ),
          ),
        ],
      ),
    );
  }

  bool _isDriverOnDelivery() {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    return orderProvider.orders.any(
      (order) =>
          order.driverId == widget.driver.id &&
          (order.status == LaundretteOrderStatus.outForDelivery ||
              order.status == LaundretteOrderStatus.pickedUp),
    );
  }

  Color _getStatusColor(LaundretteOrderStatus status) {
    switch (status) {
      case LaundretteOrderStatus.pending:
        return AppTheme.warningOrange;
      case LaundretteOrderStatus.approved:
        return AppTheme.infoBlue;
      case LaundretteOrderStatus.declined:
        return AppTheme.errorRed;
      case LaundretteOrderStatus.confirmed:
        return AppTheme.primaryBlue;
      case LaundretteOrderStatus.pickedUp:
        return AppTheme.primaryTeal;
      case LaundretteOrderStatus.inProgress:
        return AppTheme.primaryGreen;
      case LaundretteOrderStatus.ready:
        return AppTheme.secondaryOrange;
      case LaundretteOrderStatus.outForDelivery:
        return AppTheme.secondaryPurple;
      case LaundretteOrderStatus.delivered:
        return AppTheme.successGreen;
      case LaundretteOrderStatus.cancelled:
        return AppTheme.mediumGrey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _editDriver() {
    // TODO: Implement edit driver functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit driver functionality coming soon'),
        backgroundColor: AppTheme.infoBlue,
      ),
    );
  }
}
