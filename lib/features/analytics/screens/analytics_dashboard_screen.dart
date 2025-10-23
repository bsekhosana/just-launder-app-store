import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/icons.dart';
import '../../../ui/primitives/card_x.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../design_system/widgets/app_action_sheet.dart';
import '../../../core/services/site_settings_service.dart';
import '../providers/analytics_provider.dart';
import '../../orders/providers/order_provider.dart';
import '../../branches/providers/branch_provider.dart';
import '../../staff/providers/staff_provider.dart';
import '../widgets/analytics_card_widget.dart';
import '../widgets/analytics_tab_card.dart';
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
  bool _isRefreshActive = false;
  bool _isFilterActive = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Load analytics after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAnalytics();
    });
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: colorScheme.surface.withOpacity(0.9),
        elevation: 0,
        title: Text(
          'Dashboard',
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedButton(
                  onPressed: () {
                    setState(() {
                      _isRefreshActive = true;
                    });
                    // Load analytics after the current frame
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _loadAnalytics();
                      setState(() {
                        _isRefreshActive = false;
                      });
                    });
                  },
                  backgroundColor: Colors.white,
                  width: 48,
                  height: 48,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white, width: 1),
                  tooltip: 'Refresh Data',
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      AppIcons.refresh,
                      color:
                          _isRefreshActive
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedButton(
                  onPressed: () {
                    setState(() {
                      _isFilterActive = !_isFilterActive;
                    });
                    _showFilters();
                  },
                  backgroundColor: Colors.white,
                  width: 48,
                  height: 48,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white, width: 1),
                  tooltip: 'Filter Data',
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      AppIcons.filter,
                      color:
                          _isFilterActive
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.9),
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTypography.textTheme.labelMedium,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Revenue'),
                Tab(text: 'Orders'),
                Tab(text: 'Performance'),
              ],
            ),
          ),
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
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SingleChildScrollView(
          padding: SpacingUtils.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildKeyMetricsGrid(),
              const SizedBox(height: AppSpacing.xl),
              _buildQuickStatsRow(),
              const SizedBox(height: AppSpacing.xl),
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
          padding: SpacingUtils.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRevenueOverview(),
              const SizedBox(height: AppSpacing.l),
              _buildRevenueChart(),
              const SizedBox(height: AppSpacing.l),
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
          padding: SpacingUtils.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrdersOverview(),
              const SizedBox(height: AppSpacing.l),
              _buildOrdersChart(),
              const SizedBox(height: AppSpacing.l),
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
          padding: SpacingUtils.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPerformanceOverview(),
              const SizedBox(height: AppSpacing.l),
              _buildStaffPerformance(),
              const SizedBox(height: AppSpacing.l),
              _buildTopServices(),
              const SizedBox(height: AppSpacing.l),
              _buildTopCustomers(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKeyMetricsGrid() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        final siteSettings = SiteSettingsService();

        return LayoutBuilder(
          builder: (context, constraints) {
            // Responsive grid based on screen width
            final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
            final childAspectRatio = constraints.maxWidth > 600 ? 1.6 : 1.4;

            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: AppSpacing.m,
              mainAxisSpacing: AppSpacing.m,
              children: [
                AnalyticsCardWidget(
                  title: 'Total Revenue',
                  value: siteSettings.formatCurrency(
                    analyticsProvider.totalRevenue,
                  ),
                  icon: AppIcons.dollar,
                  color: AppColors.success,
                  trend: '+12.5%',
                  onTap: () => _tabController.animateTo(1), // Go to Revenue tab
                ),
                AnalyticsCardWidget(
                  title: 'Total Orders',
                  value: analyticsProvider.totalOrders.toString(),
                  icon: AppIcons.orders,
                  color: AppColors.primary,
                  trend: '+8.2%',
                  onTap: () => _tabController.animateTo(2), // Go to Orders tab
                ),
                AnalyticsCardWidget(
                  title: 'Completion Rate',
                  value:
                      '${analyticsProvider.completionRate.toStringAsFixed(1)}%',
                  icon: AppIcons.check,
                  color: AppColors.secondary,
                  trend: '+2.1%',
                  onTap:
                      () =>
                          _tabController.animateTo(3), // Go to Performance tab
                ),
                AnalyticsCardWidget(
                  title: 'Avg Order Value',
                  value: siteSettings.formatCurrency(
                    analyticsProvider.averageOrderValue,
                  ),
                  icon: AppIcons.trendingUp,
                  color: AppColors.accent,
                  trend: '+5.3%',
                  onTap: () => _tabController.animateTo(1), // Go to Revenue tab
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildQuickStatsRow() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Responsive layout based on screen width
            if (constraints.maxWidth > 600) {
              // Desktop/tablet layout - horizontal row
              return Row(
                children: [
                  Expanded(
                    child: _buildQuickStatCard(
                      'Pending Orders',
                      analyticsProvider.pendingOrders.toString(),
                      AppIcons.pending,
                      AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: _buildQuickStatCard(
                      'New Customers',
                      analyticsProvider.newCustomers.toString(),
                      AppIcons.personAdd,
                      AppColors.primary,
                    ),
                  ),
                ],
              );
            } else {
              // Mobile layout - vertical stack
              return Row(
                    children: [
                      Expanded(
                        child: _buildQuickStatCard(
                          'Pending Orders',
                          analyticsProvider.pendingOrders.toString(),
                          AppIcons.pending,
                          AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: _buildQuickStatCard(
                          'New Customers',
                          analyticsProvider.newCustomers.toString(),
                          AppIcons.personAdd,
                          AppColors.primary,
                        ),
                  ),
                ],
              );
            }
          },
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
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.m),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: AppSpacing.s),
            Text(
              value,
              style: AppTypography.textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              style: AppTypography.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline, color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.s),
                Text(
                  'Recent Activity',
                  style: AppTypography.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            Consumer<AnalyticsProvider>(
              builder: (context, analyticsProvider, child) {
                if (analyticsProvider.recentActivity.isEmpty) {
                  return Text(
                    'No recent activity',
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  );
                }

                return Column(
                  children:
                      analyticsProvider.recentActivity.take(4).map((activity) {
                        return _buildActivityItem(
                          activity['title'] ?? 'Activity',
                          activity['description'] ?? '',
                          _formatTimeAgo(activity['created_at']),
                          _getActivityIcon(activity['type']),
                          _getActivityColor(activity['type']),
                        );
                      }).toList(),
                );
              },
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
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: SpacingUtils.symmetric(horizontal: 0, vertical: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            padding: SpacingUtils.all(AppSpacing.s),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            time,
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueOverview() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        final siteSettings = SiteSettingsService();

        return AnalyticsTabCard(
          title: 'Revenue Overview',
          child: Row(
                  children: [
                    Expanded(
                      child: _buildRevenueMetric(
                        'Total Revenue',
                  siteSettings.formatCurrency(analyticsProvider.totalRevenue),
                        AppColors.success,
                      ),
                    ),
              const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: _buildRevenueMetric(
                        'Avg Order Value',
                  siteSettings.formatCurrency(
                    analyticsProvider.averageOrderValue,
                  ),
                        AppColors.primary,
                      ),
                    ),
                  ],
          ),
        );
      },
    );
  }

  Widget _buildRevenueMetric(String title, String value, Color color) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
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
    return AnalyticsTabCard(
      title: 'Revenue Trend',
      child: const RevenueChartWidget(),
    );
  }

  Widget _buildRevenueByBranch() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        final siteSettings = SiteSettingsService();

        return AnalyticsTabCard(
          title: 'Revenue by Branch',
            child: Column(
            children:
                analyticsProvider.revenueByBranch.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: AppTypography.textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          siteSettings.formatCurrency(entry.value),
                          style: AppTypography.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildOrdersOverview() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return AnalyticsTabCard(
          title: 'Orders Overview',
          child: Row(
                  children: [
                    Expanded(
                      child: _buildOrderMetric(
                        'Total Orders',
                        analyticsProvider.totalOrders.toString(),
                        AppColors.primary,
                      ),
                    ),
              const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: _buildOrderMetric(
                        'Completed',
                        analyticsProvider.completedOrders.toString(),
                        AppColors.success,
                      ),
                    ),
              const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: _buildOrderMetric(
                        'Pending',
                        analyticsProvider.pendingOrders.toString(),
                        AppColors.accent,
                      ),
                    ),
              const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: _buildOrderMetric(
                        'Cancelled',
                        analyticsProvider.cancelledOrders.toString(),
                        AppColors.error,
                      ),
                    ),
                  ],
          ),
        );
      },
    );
  }

  Widget _buildOrderMetric(String title, String value, Color color) {
    final colorScheme = Theme.of(context).colorScheme;
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
          ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOrdersChart() {
    return AnalyticsTabCard(
      title: 'Orders Trend',
      child: const OrdersChartWidget(),
    );
  }

  Widget _buildOrdersByBranch() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return AnalyticsTabCard(
          title: 'Orders by Branch',
            child: Column(
            children:
                analyticsProvider.ordersByBranch.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: AppTypography.textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          entry.value.toString(),
                          style: AppTypography.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildPerformanceOverview() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return AnalyticsTabCard(
          title: 'Performance Overview',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildPerformanceMetric(
                        'Customer Satisfaction',
                        '${analyticsProvider.customerSatisfaction.toStringAsFixed(1)}/5.0',
                        AppColors.success,
                      ),
                    ),
                  const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: _buildPerformanceMetric(
                        'Staff Efficiency',
                        '${analyticsProvider.staffEfficiency.toStringAsFixed(1)}%',
                        AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: AppSpacing.m),
                Row(
                  children: [
                    Expanded(
                      child: _buildPerformanceMetric(
                        'Avg Delivery Time',
                        analyticsProvider.averageDeliveryTimeFormatted,
                        AppColors.primary,
                      ),
                    ),
                  const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: _buildPerformanceMetric(
                        'Total Deliveries',
                        analyticsProvider.totalDeliveries.toString(),
                        AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ],
          ),
        );
      },
    );
  }

  Widget _buildPerformanceMetric(String title, String value, Color color) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
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
        final colorScheme = Theme.of(context).colorScheme;
        return AnalyticsTabCard(
          title: 'Staff Performance',
            child: Column(
            children:
                analyticsProvider.staffPerformance.take(5).map((staff) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Text(
                            staff['name']
                                .toString()
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primary,
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
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
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
          ),
        );
      },
    );
  }

  Widget _buildTopServices() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return AnalyticsTabCard(
          title: 'Top Services',
            child: Column(
            children:
                analyticsProvider.topServices.take(5).map((service) {
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
          ),
        );
      },
    );
  }

  Widget _buildTopCustomers() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        final colorScheme = Theme.of(context).colorScheme;
        return AnalyticsTabCard(
          title: 'Top Customers',
            child: Column(
            children:
                analyticsProvider.topCustomers.take(5).map((customer) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.success.withOpacity(0.1),
                          child: Text(
                            customer['customerName']
                                .toString()
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.success,
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
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          SiteSettingsService().formatCurrency(
                            customer['totalSpent']?.toDouble() ?? 0.0,
                          ),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  void _showFilters() {
    AppActionSheet.show(
      context: context,
      title: 'Filter Analytics',
      subtitle: 'Customize your dashboard view',
      icon: AppIcons.filter,
      child: _buildFilterContent(),
            actions: [
        AppActionSheetAction(
          text: 'Reset',
          onPressed: () {
            Navigator.of(context).pop();
            _resetFilters();
          },
        ),
        AppActionSheetAction(
          text: 'Apply',
          isPrimary: true,
          onPressed: () {
            Navigator.of(context).pop();
            _applyFilters();
          },
        ),
      ],
    );
  }

  Widget _buildFilterContent() {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Period Filter
              _buildFilterSection(
                'Time Period',
                _buildTimePeriodFilter(analyticsProvider),
              ),
              const SizedBox(height: AppSpacing.l),

              // Branch Filter
              _buildFilterSection(
                'Branch',
                _buildBranchFilter(analyticsProvider),
              ),
              const SizedBox(height: AppSpacing.l),

              // Order Status Filter
              _buildFilterSection(
                'Order Status',
                _buildOrderStatusFilter(analyticsProvider),
              ),
              const SizedBox(height: AppSpacing.l),

              // Date Range Filter
              _buildFilterSection(
                'Date Range',
                _buildDateRangeFilter(analyticsProvider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.textTheme.titleMedium?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        content,
      ],
    );
  }

  Widget _buildTimePeriodFilter(AnalyticsProvider analyticsProvider) {
    return DropdownButtonFormField<String>(
      value: analyticsProvider.selectedPeriod,
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.xs,
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'day', child: Text('Today')),
        DropdownMenuItem(value: 'week', child: Text('This Week')),
        DropdownMenuItem(value: 'month', child: Text('This Month')),
        DropdownMenuItem(value: 'year', child: Text('This Year')),
      ],
      onChanged: (value) {
        if (value != null) {
          analyticsProvider.updateSelectedPeriod(value);
        }
      },
    );
  }

  Widget _buildBranchFilter(AnalyticsProvider analyticsProvider) {
    return Consumer<BranchProvider>(
      builder: (context, branchProvider, child) {
        return DropdownButtonFormField<String>(
          value: analyticsProvider.selectedBranchId,
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s,
              vertical: AppSpacing.xs,
            ),
          ),
          items: [
            const DropdownMenuItem(value: 'all', child: Text('All Branches')),
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
            }
          },
        );
      },
    );
  }

  Widget _buildOrderStatusFilter(AnalyticsProvider analyticsProvider) {
    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.s,
      children:
          ['All', 'Pending', 'In Progress', 'Completed', 'Cancelled'].map((
            status,
          ) {
            final isSelected =
                analyticsProvider.selectedOrderStatus == status.toLowerCase();
            return FilterChip(
              label: Text(status),
              selected: isSelected,
              onSelected: (selected) {
                analyticsProvider.updateSelectedOrderStatus(
                  selected ? status.toLowerCase() : 'all',
                );
              },
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
    );
  }

  Widget _buildDateRangeFilter(AnalyticsProvider analyticsProvider) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _selectStartDate(analyticsProvider),
            icon: Icon(AppIcons.time, size: 16),
            label: Text(
              analyticsProvider.startDate != null
                  ? '${analyticsProvider.startDate!.day}/${analyticsProvider.startDate!.month}/${analyticsProvider.startDate!.year}'
                  : 'Start Date',
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _selectEndDate(analyticsProvider),
            icon: Icon(AppIcons.time, size: 16),
            label: Text(
              analyticsProvider.endDate != null
                  ? '${analyticsProvider.endDate!.day}/${analyticsProvider.endDate!.month}/${analyticsProvider.endDate!.year}'
                  : 'End Date',
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectStartDate(AnalyticsProvider analyticsProvider) async {
    final date = await showDatePicker(
      context: context,
      initialDate: analyticsProvider.startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      analyticsProvider.updateStartDate(date);
    }
  }

  Future<void> _selectEndDate(AnalyticsProvider analyticsProvider) async {
    final date = await showDatePicker(
      context: context,
      initialDate: analyticsProvider.endDate ?? DateTime.now(),
      firstDate: analyticsProvider.startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      analyticsProvider.updateEndDate(date);
    }
  }

  void _resetFilters() {
    final analyticsProvider = Provider.of<AnalyticsProvider>(
      context,
      listen: false,
    );
    analyticsProvider.resetFilters();
    _loadAnalytics();
  }

  void _applyFilters() {
    _loadAnalytics();
  }

  String _formatTimeAgo(dynamic createdAt) {
    if (createdAt == null) return 'Unknown time';

    try {
      DateTime dateTime;
      if (createdAt is String) {
        dateTime = DateTime.parse(createdAt);
      } else if (createdAt is int) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(createdAt);
      } else {
        return 'Unknown time';
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }

  IconData _getActivityIcon(String? type) {
    switch (type) {
      case 'order_created':
        return Icons.shopping_bag;
      case 'order_completed':
        return Icons.check_circle;
      case 'customer_registered':
        return Icons.person_add;
      case 'staff_assigned':
        return Icons.assignment_ind;
      case 'payment_received':
        return Icons.payment;
      case 'order_cancelled':
        return Icons.cancel;
      default:
        return Icons.notifications;
    }
  }

  Color _getActivityColor(String? type) {
    switch (type) {
      case 'order_created':
        return AppColors.primary;
      case 'order_completed':
        return AppColors.success;
      case 'customer_registered':
        return AppColors.primary;
      case 'staff_assigned':
        return AppColors.secondary;
      case 'payment_received':
        return AppColors.success;
      case 'order_cancelled':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }
}
