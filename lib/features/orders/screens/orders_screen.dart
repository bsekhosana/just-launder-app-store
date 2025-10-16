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
import '../../auth/providers/auth_provider.dart';
import 'enhanced_order_details_screen.dart';
// import '../widgets/order_filters_widget.dart';
// import '../widgets/order_stats_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // OrderFilters _filters = OrderFilters();
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
    final orderProvider = Provider.of<TenantOrderProvider>(
      context,
      listen: false,
    );
    // Load orders when screen initializes
    await orderProvider.loadOrders();
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
      body: Consumer<TenantOrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading && orderProvider.orders.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (orderProvider.error != null && orderProvider.orders.isEmpty) {
            return _buildErrorState(orderProvider.error!);
          }

          final filteredOrders = _getFilteredOrders(orderProvider.orders);

          return Column(
            children: [
              // Filters can be uncommented when needed
              // if (_showFilters) ...[
              //   Flexible(
              //     flex: 0,
              //     child: AnimatedContainer(
              //           duration: AppMotion.normal,
              //           curve: AppCurves.standard,
              //           constraints: const BoxConstraints(maxHeight: 300),
              //           child: SingleChildScrollView(
              //             child: Column(
              //               children: [
              //                 OrderFiltersWidget(
              //                   currentFilters: _filters,
              //                   onFiltersChanged: (filters) {
              //                     setState(() {
              //                       _filters = filters;
              //                     });
              //                   },
              //                 ),
              //                 const SizedBox(height: AppSpacing.s),
              //                 OrderStatsWidget(orders: filteredOrders),
              //               ],
              //             ),
              //           ),
              //         )
              //         .animate()
              //         .fadeIn(duration: AppMotion.normal)
              //         .slideY(
              //           begin: -0.3,
              //           end: 0.0,
              //           duration: AppMotion.normal,
              //         ),
              //   ),
              //   const SizedBox(height: AppSpacing.s),
              // ],
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
                        TenantOrderModel.confirmed,
                      ),
                      'No approved orders',
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
                        TenantOrderModel.completed,
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

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding: SpacingUtils.all(AppSpacing.l),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order, index);
        },
      ),
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
                      label: _getStatusLabel(order.status),
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
                  'Order #${order.orderNumber}',
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.m),
                // Price
                Text(
                  '£${order.totalAmount.toStringAsFixed(2)}',
                  style: AppTypography.textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Action buttons as footer (if pending)
                if (order.status == TenantOrderStatus.pending) ...[
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

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: AppSpacing.l),
          Text(
            'Error loading orders',
            style: AppTypography.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            error,
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.l),
          AnimatedButtons.primary(
            onPressed: _loadOrders,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(TenantOrderStatus status) {
    // Use the model's displayText instead
    final order = TenantOrderModel(
      id: '',
      orderNumber: '',
      customerId: '',
      customerName: '',
      customerEmail: '',
      customerPhone: '',
      branchId: '',
      branchName: '',
      status: status,
      items: [],
      totalAmount: 0,
      pickupAddress: '',
      deliveryAddress: '',
      pickupDate: DateTime.now(),
      deliveryDate: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return order.statusDisplayText;
  }

  ChipStatus _getChipStatus(TenantOrderStatus status) {
    switch (status) {
      case TenantOrderStatus.pending:
      case TenantOrderStatus.awaitingApproval:
        return ChipStatus.warning;
      case TenantOrderStatus.approved:
      case TenantOrderStatus.assigned:
        return ChipStatus.info;
      case TenantOrderStatus.inProgress:
      case TenantOrderStatus.processing:
      case TenantOrderStatus.pickedUp:
        return ChipStatus.info;
      case TenantOrderStatus.ready:
      case TenantOrderStatus.outForDelivery:
        return ChipStatus.warning;
      case TenantOrderStatus.delivered:
        return ChipStatus.success;
      case TenantOrderStatus.cancelled:
      case TenantOrderStatus.declined:
        return ChipStatus.neutral;
      default:
        return ChipStatus.neutral;
    }
  }

  Future<void> _approveOrder(String orderId) async {
    final orderProvider = Provider.of<TenantOrderProvider>(
      context,
      listen: false,
    );
    final success = await orderProvider.updateOrderStatus(
      orderId,
      TenantOrderStatus.approved,
    );

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
      final orderProvider = Provider.of<TenantOrderProvider>(
        context,
        listen: false,
      );
      final success = await orderProvider.updateOrderStatus(
        orderId,
        TenantOrderStatus.cancelled,
        notes: reason,
      );

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

  void _viewOrderDetails(TenantOrderModel order) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EnhancedOrderDetailsScreen(order: order),
      ),
    );
  }

  List<TenantOrderModel> _getFilteredOrders(List<TenantOrderModel> orders) {
    // Filtering can be implemented when OrderFiltersWidget is updated
    return orders;
  }

  List<TenantOrderModel> _getOrdersByStatus(
    List<TenantOrderModel> orders,
    TenantOrderStatus status,
  ) {
    return orders.where((order) => order.status == status).toList();
  }
}
