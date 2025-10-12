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
import '../providers/order_provider.dart';
import '../../../data/models/laundrette_order.dart';
import 'order_details_screen.dart';
import '../widgets/order_filters_widget.dart';
import '../widgets/order_stats_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  OrderFilters _filters = OrderFilters();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
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
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    // Load orders when screen initializes
    await orderProvider.loadOrders(
      'laundrette_business_1',
    ); // Mock laundrette ID
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
          'Orders',
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
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
                Tab(text: 'Approved'),
                Tab(text: 'In Progress'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final filteredOrders = _getFilteredOrders(orderProvider.orders);

          return Column(
            children: [
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
                        LaundretteOrderStatus.pending,
                      ),
                      'No pending orders',
                    ),
                    _buildOrdersList(
                      _getOrdersByStatus(
                        filteredOrders,
                        LaundretteOrderStatus.approved,
                      ),
                      'No approved orders',
                    ),
                    _buildOrdersList(
                      _getOrdersByStatus(
                        filteredOrders,
                        LaundretteOrderStatus.inProgress,
                      ),
                      'No orders in progress',
                    ),
                    _buildOrdersList(
                      _getOrdersByStatus(
                        filteredOrders,
                        LaundretteOrderStatus.delivered,
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

  Widget _buildOrdersList(List<LaundretteOrder> orders, String emptyMessage) {
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

  Widget _buildOrderCard(LaundretteOrder order, int index) {
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
                // Price
                Text(
                  '£${order.total.toStringAsFixed(2)}',
                  style: AppTypography.textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Action buttons as footer (if pending approval)
                if (order.isPendingApproval) ...[
                  const SizedBox(height: AppSpacing.l),
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedButtons.secondary(
                          onPressed: () => _declineOrder(order.id),
                          height: 44,
                          child: Text(
                            'Decline',
                            style: AppTypography.textTheme.labelMedium
                                ?.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: AnimatedButtons.primary(
                          onPressed: () => _approveOrder(order.id),
                          height: 44,
                          child: Text(
                            'Approve',
                            style: AppTypography.textTheme.labelMedium
                                ?.copyWith(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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

  ChipStatus _getChipStatus(LaundretteOrderStatus status) {
    switch (status) {
      case LaundretteOrderStatus.pending:
        return ChipStatus.warning;
      case LaundretteOrderStatus.approved:
        return ChipStatus.info;
      case LaundretteOrderStatus.declined:
        return ChipStatus.error;
      case LaundretteOrderStatus.confirmed:
        return ChipStatus.info;
      case LaundretteOrderStatus.pickedUp:
        return ChipStatus.info;
      case LaundretteOrderStatus.inProgress:
        return ChipStatus.info;
      case LaundretteOrderStatus.ready:
        return ChipStatus.warning;
      case LaundretteOrderStatus.outForDelivery:
        return ChipStatus.info;
      case LaundretteOrderStatus.delivered:
        return ChipStatus.success;
      case LaundretteOrderStatus.cancelled:
        return ChipStatus.neutral;
    }
  }

  Future<void> _approveOrder(String orderId) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final success = await orderProvider.approveOrder(orderId);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Order approved successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _declineOrder(String orderId) async {
    // Show decline reason dialog
    final reason = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Decline Order'),
            content: TextField(
              decoration: const InputDecoration(
                labelText: 'Reason for declining',
                hintText: 'Enter reason...',
              ),
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Get the reason from the text field
                  Navigator.of(context).pop('No reason provided');
                },
                child: const Text('Decline'),
              ),
            ],
          ),
    );

    if (reason != null) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final success = await orderProvider.declineOrder(orderId, reason);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Order declined'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _viewOrderDetails(LaundretteOrder order) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => OrderDetailsScreen(order: order)),
    );
  }

  List<LaundretteOrder> _getFilteredOrders(List<LaundretteOrder> orders) {
    if (!_filters.hasActiveFilters) {
      return orders;
    }
    return orders.where((order) => _filters.matchesOrder(order)).toList();
  }

  List<LaundretteOrder> _getOrdersByStatus(
    List<LaundretteOrder> orders,
    LaundretteOrderStatus status,
  ) {
    return orders.where((order) => order.status == status).toList();
  }
}
