import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
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
    _tabController = TabController(length: 4, vsync: this);
    _loadOrders();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_list : Icons.filter_list_outlined,
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'In Progress'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredOrders = _getFilteredOrders(orderProvider.orders);

          return Column(
            children: [
              if (_showFilters) ...[
                OrderFiltersWidget(
                  currentFilters: _filters,
                  onFiltersChanged: (filters) {
                    setState(() {
                      _filters = filters;
                    });
                  },
                ),
                const SizedBox(height: 8),
                OrderStatsWidget(orders: filteredOrders),
                const SizedBox(height: 8),
              ],
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
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
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: AppTheme.lightGrey,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.mediumGrey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(LaundretteOrder order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _viewOrderDetails(order),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.customerName,
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
                order.branchName,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGrey),
              ),
              const SizedBox(height: 4),
              Text(
                'Order #${order.id}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGrey),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${order.total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (order.isPendingApproval) ...[
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => _approveOrder(order.id),
                          child: const Text('Approve'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => _declineOrder(order.id),
                          child: const Text('Decline'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
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

  Future<void> _approveOrder(String orderId) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final success = await orderProvider.approveOrder(orderId);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order approved successfully'),
          backgroundColor: AppTheme.successGreen,
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
          const SnackBar(
            content: Text('Order declined'),
            backgroundColor: AppTheme.errorRed,
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
