import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/motion.dart';
import '../../../design_system/icons.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../ui/primitives/card_x.dart';
import '../../../ui/primitives/chip_x.dart';
import '../providers/tenant_order_provider.dart';
import '../domain/models/tenant_order_model.dart';
import 'enhanced_order_details_screen.dart';
import '../widgets/order_filters_widget.dart';
import '../widgets/order_stats_widget.dart';
import '../widgets/order_analytics_widget.dart';

class EnhancedOrdersDashboardScreen extends StatefulWidget {
  const EnhancedOrdersDashboardScreen({super.key});

  @override
  State<EnhancedOrdersDashboardScreen> createState() =>
      _EnhancedOrdersDashboardScreenState();
}

class _EnhancedOrdersDashboardScreenState
    extends State<EnhancedOrdersDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  OrderFilters _filters = OrderFilters();
  bool _showFilters = false;
  bool _showAnalytics = false;
  TimePeriod _selectedTimePeriod = TimePeriod.today;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 0);
    // Load orders after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    final orderProvider = Provider.of<TenantOrderProvider>(
      context,
      listen: false,
    );
    await orderProvider.loadOrders();
    await orderProvider.loadAnalytics();
    await orderProvider.loadStatistics();
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
          'Orders Dashboard',
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AnimatedButton(
              onPressed: () {
                setState(() {
                  _showAnalytics = !_showAnalytics;
                });
              },
              backgroundColor: Colors.white,
              width: 48,
              height: 48,
              borderRadius: BorderRadius.circular(24),
              tooltip: _showAnalytics ? 'Hide Analytics' : 'Show Analytics',
              border: Border.all(color: Colors.white, width: 1),
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  AppIcons.analytics,
                  color:
                      _showAnalytics
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: AnimatedButton(
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
              backgroundColor: Colors.white,
              width: 48,
              height: 48,
              borderRadius: BorderRadius.circular(24),
              tooltip: _showFilters ? 'Hide Filters' : 'Show Filters',
              border: Border.all(color: Colors.white, width: 1),
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  AppIcons.filter,
                  color:
                      _showFilters
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                  size: 20,
                ),
              ),
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
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTypography.textTheme.labelMedium,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Pending'),
                Tab(text: 'In Progress'),
                Tab(text: 'Ready'),
                Tab(text: 'Delivered'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<TenantOrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final filteredOrders = _getFilteredOrders(orderProvider.orders);

          return Column(
            children: [
              if (_showAnalytics) ...[
                Flexible(
                  flex: 0,
                  child: AnimatedContainer(
                        duration: AppMotion.normal,
                        curve: AppCurves.standard,
                        constraints: const BoxConstraints(maxHeight: 400),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              OrderAnalyticsWidget(
                                analytics: orderProvider.analytics,
                                statistics: orderProvider.statistics,
                                timePeriod: _selectedTimePeriod,
                                onTimePeriodChanged: (period) {
                                  setState(() {
                                    _selectedTimePeriod = period;
                                  });
                                  _loadOrders();
                                },
                              ),
                              const SizedBox(height: AppSpacing.s),
                            ],
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: AppMotion.normal)
                      .slideY(
                        begin: -0.3,
                        end: 0.0,
                        duration: AppMotion.normal,
                      ),
                ),
                const SizedBox(height: AppSpacing.s),
              ],
              if (_showFilters) ...[
                Flexible(
                  flex: 0,
                  child: AnimatedContainer(
                        duration: AppMotion.normal,
                        curve: AppCurves.standard,
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              OrderFiltersWidget(
                                currentFilters: _filters,
                                onFiltersChanged: (filters) {
                                  setState(() {
                                    _filters = filters;
                                  });
                                },
                              ),
                              const SizedBox(height: AppSpacing.s),
                              OrderStatsWidget(orders: filteredOrders),
                            ],
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: AppMotion.normal)
                      .slideY(
                        begin: -0.3,
                        end: 0.0,
                        duration: AppMotion.normal,
                      ),
                ),
                const SizedBox(height: AppSpacing.s),
              ],
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOrdersList(filteredOrders, 'No orders found'),
                    _buildOrdersList(
                      _getOrdersByStatus(
                        filteredOrders,
                        TenantOrderStatus.pending,
                      ),
                      'No pending orders',
                    ),
                    _buildOrdersList(
                      _getOrdersByStatus(
                        filteredOrders,
                        TenantOrderStatus.inProgress,
                      ),
                      'No orders in progress',
                    ),
                    _buildOrdersList(
                      _getOrdersByStatus(
                        filteredOrders,
                        TenantOrderStatus.readyForDelivery,
                      ),
                      'No orders ready for delivery',
                    ),
                    _buildOrdersList(
                      _getOrdersByStatus(
                        filteredOrders,
                        TenantOrderStatus.delivered,
                      ),
                      'No delivered orders',
                    ),
                    _buildOrdersList(
                      _getOrdersByStatus(
                        filteredOrders,
                        TenantOrderStatus.completed,
                      ),
                      'No completed orders',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrdersList(List<TenantOrderModel> orders, String emptyMessage) {
    final colorScheme = Theme.of(context).colorScheme;

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                  AppIcons.orders,
                  size: 64,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                )
                .animate()
                .scale(duration: AppMotion.slow, curve: AppCurves.emphasized)
                .fadeIn(duration: AppMotion.normal),
            const SizedBox(height: AppSpacing.l),
            Text(
                  emptyMessage,
                  style: AppTypography.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
                .animate()
                .fadeIn(delay: AppMotion.fast, duration: AppMotion.normal)
                .slideY(
                  begin: 0.3,
                  end: 0.0,
                  delay: AppMotion.fast,
                  duration: AppMotion.normal,
                ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: SpacingUtils.all(AppSpacing.l),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order, index);
      },
    );
  }

  Widget _buildOrderCard(TenantOrderModel order, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
          onTap: () => _viewOrderDetails(order),
          margin: const EdgeInsets.only(bottom: AppSpacing.m),
          child: Padding(
            padding: SpacingUtils.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.customerName,
                      style: AppTypography.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    ChipsX.status(
                      label: order.statusDisplayText,
                      status: _getChipStatus(order.status),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  order.branchName,
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Order #${order.id}',
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.m),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '£${order.total.toStringAsFixed(2)}',
                      style: AppTypography.textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (order.isHighPriority)
                      ChipsX.status(
                        label: order.priorityDisplayText,
                        status: _getPriorityChipStatus(order.priority),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s),
                Row(
                  children: [
                    if (order.tags.isNotEmpty) ...[
                      Icon(
                        AppIcons.tag,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${order.tags.length} tags',
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      _formatDateTime(order.createdAt),
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: index * 100),
          duration: AppMotion.normal,
        )
        .slideY(
          begin: 0.3,
          end: 0.0,
          delay: Duration(milliseconds: index * 100),
          duration: AppMotion.normal,
        );
  }

  ChipStatus _getChipStatus(TenantOrderStatus status) {
    switch (status) {
      case TenantOrderStatus.pending:
        return ChipStatus.warning;
      case TenantOrderStatus.confirmed:
        return ChipStatus.info;
      case TenantOrderStatus.pickedUp:
        return ChipStatus.info;
      case TenantOrderStatus.inProgress:
        return ChipStatus.info;
      case TenantOrderStatus.readyForDelivery:
        return ChipStatus.warning;
      case TenantOrderStatus.outForDelivery:
        return ChipStatus.info;
      case TenantOrderStatus.delivered:
        return ChipStatus.success;
      case TenantOrderStatus.completed:
        return ChipStatus.success;
      case TenantOrderStatus.cancelled:
        return ChipStatus.error;
      case TenantOrderStatus.onHold:
        return ChipStatus.warning;
      case TenantOrderStatus.returned:
        return ChipStatus.error;
    }
  }

  ChipStatus _getPriorityChipStatus(OrderPriority priority) {
    switch (priority) {
      case OrderPriority.normal:
        return ChipStatus.neutral;
      case OrderPriority.high:
        return ChipStatus.warning;
      case OrderPriority.urgent:
        return ChipStatus.error;
      case OrderPriority.express:
        return ChipStatus.primary;
    }
  }

  void _viewOrderDetails(TenantOrderModel order) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EnhancedOrderDetailsScreen(order: order),
      ),
    );
  }

  List<TenantOrderModel> _getFilteredOrders(List<TenantOrderModel> orders) {
    if (!_filters.hasActiveFilters) {
      return orders;
    }
    return orders.where((order) => _filters.matchesOrder(order)).toList();
  }

  List<TenantOrderModel> _getOrdersByStatus(
    List<TenantOrderModel> orders,
    TenantOrderStatus status,
  ) {
    return orders.where((order) => order.status == status).toList();
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
