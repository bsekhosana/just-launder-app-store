import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/analytics_provider.dart';
import '../../orders/providers/order_provider.dart';
import '../../branches/providers/branch_provider.dart';
import '../../staff/providers/staff_provider.dart';
import '../widgets/analytics_card_widget.dart';
import '../widgets/revenue_chart_widget.dart';
import '../widgets/orders_chart_widget.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAnalytics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAnalytics() async {
    final analyticsProvider = Provider.of<AnalyticsProvider>(
      context,
      listen: false,
    );
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    final staffProvider = Provider.of<StaffProvider>(context, listen: false);

    await analyticsProvider.loadAnalytics(
      orders: orderProvider.orders,
      branches: branchProvider.branches,
      staff: staffProvider.staff,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalytics,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
            tooltip: 'Filter Data',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Revenue'),
            Tab(text: 'Orders'),
            Tab(text: 'Performance'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildRevenueTab(),
          _buildOrdersTab(),
          _buildPerformanceTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        if (analyticsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPeriodSelector(),
              const SizedBox(height: 16),
              _buildKeyMetricsGrid(),
              const SizedBox(height: 24),
              _buildQuickStatsRow(),
              const SizedBox(height: 24),
              _buildRecentActivityCard(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRevenueTab() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRevenueOverview(),
              const SizedBox(height: 24),
              _buildRevenueChart(),
              const SizedBox(height: 24),
              _buildRevenueByBranch(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrdersTab() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrdersOverview(),
              const SizedBox(height: 24),
              _buildOrdersChart(),
              const SizedBox(height: 24),
              _buildOrdersByBranch(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPerformanceTab() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPerformanceOverview(),
              const SizedBox(height: 24),
              _buildStaffPerformance(),
              const SizedBox(height: 24),
              _buildTopServices(),
              const SizedBox(height: 24),
              _buildTopCustomers(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPeriodSelector() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Period:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String>(
                    value: analyticsProvider.selectedPeriod,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'day', child: Text('Today')),
                      DropdownMenuItem(value: 'week', child: Text('This Week')),
                      DropdownMenuItem(
                        value: 'month',
                        child: Text('This Month'),
                      ),
                      DropdownMenuItem(value: 'year', child: Text('This Year')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        analyticsProvider.updateSelectedPeriod(value);
                        _loadAnalytics();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Consumer<BranchProvider>(
                    builder: (context, branchProvider, child) {
                      return DropdownButton<String>(
                        value: analyticsProvider.selectedBranchId,
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(
                            value: 'all',
                            child: Text('All Branches'),
                          ),
                          ...branchProvider.branches.map((branch) {
                            return DropdownMenuItem(
                              value: branch.id,
                              child: Text(branch.name),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            analyticsProvider.updateSelectedBranch(value);
                            _loadAnalytics();
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKeyMetricsGrid() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            AnalyticsCardWidget(
              title: 'Total Revenue',
              value: '\$${analyticsProvider.totalRevenue.toStringAsFixed(2)}',
              icon: Icons.attach_money,
              color: AppTheme.successGreen,
              trend: '+12.5%',
            ),
            AnalyticsCardWidget(
              title: 'Total Orders',
              value: analyticsProvider.totalOrders.toString(),
              icon: Icons.shopping_bag,
              color: AppTheme.primaryBlue,
              trend: '+8.2%',
            ),
            AnalyticsCardWidget(
              title: 'Completion Rate',
              value: '${analyticsProvider.completionRate.toStringAsFixed(1)}%',
              icon: Icons.check_circle,
              color: AppTheme.primaryGreen,
              trend: '+2.1%',
            ),
            AnalyticsCardWidget(
              title: 'Avg Order Value',
              value:
                  '\$${analyticsProvider.averageOrderValue.toStringAsFixed(2)}',
              icon: Icons.trending_up,
              color: AppTheme.warningOrange,
              trend: '+5.3%',
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickStatsRow() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return Row(
          children: [
            Expanded(
              child: _buildQuickStatCard(
                'Pending Orders',
                analyticsProvider.pendingOrders.toString(),
                Icons.pending,
                AppTheme.warningOrange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickStatCard(
                'New Customers',
                analyticsProvider.newCustomers.toString(),
                Icons.person_add,
                AppTheme.infoBlue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickStatCard(
                'Avg Delivery Time',
                analyticsProvider.averageDeliveryTimeFormatted,
                Icons.local_shipping,
                AppTheme.primaryTeal,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGrey),
              textAlign: TextAlign.center,
            ),
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
              'New order received',
              'Order #12345',
              '2 min ago',
              Icons.shopping_bag,
              AppTheme.primaryBlue,
            ),
            _buildActivityItem(
              'Order completed',
              'Order #12344',
              '15 min ago',
              Icons.check_circle,
              AppTheme.successGreen,
            ),
            _buildActivityItem(
              'New customer registered',
              'John Doe',
              '1 hour ago',
              Icons.person_add,
              AppTheme.infoBlue,
            ),
            _buildActivityItem(
              'Driver assigned',
              'Order #12343',
              '2 hours ago',
              Icons.local_shipping,
              AppTheme.primaryTeal,
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

  Widget _buildRevenueOverview() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revenue Overview',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildRevenueMetric(
                        'Total Revenue',
                        '\$${analyticsProvider.totalRevenue.toStringAsFixed(2)}',
                        AppTheme.successGreen,
                      ),
                    ),
                    Expanded(
                      child: _buildRevenueMetric(
                        'Avg Order Value',
                        '\$${analyticsProvider.averageOrderValue.toStringAsFixed(2)}',
                        AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRevenueMetric(String title, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGrey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Trend',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const RevenueChartWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueByBranch() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revenue by Branch',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...analyticsProvider.revenueByBranch.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key),
                        Text(
                          '\$${entry.value.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrdersOverview() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Orders Overview',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildOrderMetric(
                        'Total Orders',
                        analyticsProvider.totalOrders.toString(),
                        AppTheme.primaryBlue,
                      ),
                    ),
                    Expanded(
                      child: _buildOrderMetric(
                        'Completed',
                        analyticsProvider.completedOrders.toString(),
                        AppTheme.successGreen,
                      ),
                    ),
                    Expanded(
                      child: _buildOrderMetric(
                        'Pending',
                        analyticsProvider.pendingOrders.toString(),
                        AppTheme.warningOrange,
                      ),
                    ),
                    Expanded(
                      child: _buildOrderMetric(
                        'Cancelled',
                        analyticsProvider.cancelledOrders.toString(),
                        AppTheme.errorRed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderMetric(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGrey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOrdersChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orders Trend',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const OrdersChartWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersByBranch() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Orders by Branch',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...analyticsProvider.ordersByBranch.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key),
                        Text(
                          entry.value.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPerformanceOverview() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance Overview',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildPerformanceMetric(
                        'Customer Satisfaction',
                        '${analyticsProvider.customerSatisfaction.toStringAsFixed(1)}/5.0',
                        AppTheme.successGreen,
                      ),
                    ),
                    Expanded(
                      child: _buildPerformanceMetric(
                        'Driver Efficiency',
                        '${analyticsProvider.driverEfficiency.toStringAsFixed(1)}%',
                        AppTheme.primaryTeal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildPerformanceMetric(
                        'Avg Delivery Time',
                        analyticsProvider.averageDeliveryTimeFormatted,
                        AppTheme.primaryBlue,
                      ),
                    ),
                    Expanded(
                      child: _buildPerformanceMetric(
                        'Total Deliveries',
                        analyticsProvider.totalDeliveries.toString(),
                        AppTheme.warningOrange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPerformanceMetric(String title, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGrey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStaffPerformance() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Staff Performance',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...analyticsProvider.staffPerformance.take(5).map((staff) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppTheme.primaryBlue.withOpacity(
                            0.1,
                          ),
                          child: Text(
                            staff['name']
                                .toString()
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                staff['name'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${staff['completionRate'].toStringAsFixed(1)}% completion rate',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppTheme.mediumGrey),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${staff['totalOrders']} orders',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopServices() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Services',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...analyticsProvider.topServices.take(5).map((service) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(service['service'].toString()),
                        Text(
                          '${service['count']} orders',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopCustomers() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Customers',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...analyticsProvider.topCustomers.take(5).map((customer) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppTheme.successGreen.withOpacity(
                            0.1,
                          ),
                          child: Text(
                            customer['customerName']
                                .toString()
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                              color: AppTheme.successGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer['customerName'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${customer['orderCount']} orders',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppTheme.mediumGrey),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${customer['totalSpent'].toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilters() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter Analytics'),
            content: const Text('Filter options coming soon'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
