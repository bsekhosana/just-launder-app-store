import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/order_provider.dart';
import '../../../data/models/laundrette_order.dart';
import '../../staff/providers/staff_provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final LaundretteOrder order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    final staffProvider = Provider.of<StaffProvider>(context, listen: false);
    await staffProvider.loadStaff('laundrette_business_1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.order.id}'),
        actions: [
          if (widget.order.isPendingApproval) ...[
            TextButton(
              onPressed: () => _approveOrder(),
              child: const Text('Approve'),
            ),
            TextButton(
              onPressed: () => _declineOrder(),
              child: const Text('Decline'),
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderStatusCard(),
            const SizedBox(height: 16),
            _buildCustomerInfoCard(),
            const SizedBox(height: 16),
            _buildOrderItemsCard(),
            const SizedBox(height: 16),
            _buildPricingCard(),
            const SizedBox(height: 16),
            _buildTimelineCard(),
            if (widget.order.driverId != null) ...[
              const SizedBox(height: 16),
              _buildDriverInfoCard(),
            ],
            if (widget.order.isPendingApproval) ...[
              const SizedBox(height: 16),
              _buildActionButtons(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Status',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      widget.order.status,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getStatusColor(widget.order.status),
                    ),
                  ),
                  child: Text(
                    widget.order.statusDisplayText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(widget.order.status),
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
                  'Priority',
                  widget.order.priorityDisplayText,
                  _getPriorityColor(widget.order.priority),
                ),
                const SizedBox(width: 24),
                _buildStatusItem(
                  'Payment',
                  widget.order.paymentStatusDisplayText,
                  _getPaymentStatusColor(widget.order.paymentStatus),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatusItem(
                  'Total',
                  '\$${widget.order.total.toStringAsFixed(2)}',
                  AppTheme.primaryBlue,
                ),
                const SizedBox(width: 24),
                _buildStatusItem(
                  'Created',
                  _formatDateTime(widget.order.createdAt),
                  AppTheme.mediumGrey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGrey),
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

  Widget _buildCustomerInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Information',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Name', widget.order.customerName),
            _buildInfoRow('Phone', widget.order.customerPhone),
            if (widget.order.pickupAddress != null)
              _buildInfoRow('Pickup Address', widget.order.pickupAddress!),
            if (widget.order.deliveryAddress != null)
              _buildInfoRow('Delivery Address', widget.order.deliveryAddress!),
            if (widget.order.notes != null)
              _buildInfoRow('Notes', widget.order.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Items',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (widget.order.orderItems.containsKey('bags')) ...[
              Text(
                'Bags',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...((widget.order.orderItems['bags'] as List).map((bag) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${bag['type'].toString().toUpperCase()} (${bag['weight']}kg)',
                      ),
                      Text('\$${bag['price'].toStringAsFixed(2)}'),
                    ],
                  ),
                );
              }).toList()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing Breakdown',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPricingRow('Subtotal', widget.order.subtotal),
            _buildPricingRow('Delivery Fee', widget.order.deliveryFee),
            const Divider(),
            _buildPricingRow('Total', widget.order.total, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                isTotal
                    ? Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )
                    : Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style:
                isTotal
                    ? Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    )
                    : Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Timeline',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTimelineItem(
              'Order Created',
              widget.order.createdAt,
              true,
              Icons.shopping_cart,
            ),
            if (widget.order.scheduledPickupTime != null)
              _buildTimelineItem(
                'Scheduled Pickup',
                widget.order.scheduledPickupTime!,
                true,
                Icons.schedule,
              ),
            if (widget.order.actualPickupTime != null)
              _buildTimelineItem(
                'Picked Up',
                widget.order.actualPickupTime!,
                true,
                Icons.local_shipping,
              ),
            if (widget.order.estimatedDeliveryTime != null)
              _buildTimelineItem(
                'Estimated Delivery',
                widget.order.estimatedDeliveryTime!,
                false,
                Icons.delivery_dining,
              ),
            if (widget.order.actualDeliveryTime != null)
              _buildTimelineItem(
                'Delivered',
                widget.order.actualDeliveryTime!,
                true,
                Icons.check_circle,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    DateTime dateTime,
    bool isCompleted,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isCompleted
                      ? AppTheme.successGreen.withOpacity(0.1)
                      : AppTheme.mediumGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: isCompleted ? AppTheme.successGreen : AppTheme.mediumGrey,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color:
                        isCompleted ? AppTheme.darkGrey : AppTheme.mediumGrey,
                  ),
                ),
                Text(
                  _formatDateTime(dateTime),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGrey),
                ),
              ],
            ),
          ),
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
            Text(
              'Driver Information',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Name', widget.order.driverName ?? 'Not assigned'),
            _buildInfoRow('Phone', widget.order.driverPhone ?? 'Not available'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _approveOrder,
                    icon: const Icon(Icons.check),
                    label: const Text('Approve Order'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successGreen,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _declineOrder,
                    icon: const Icon(Icons.close),
                    label: const Text('Decline Order'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorRed,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.order.status == LaundretteOrderStatus.approved) ...[
              ElevatedButton.icon(
                onPressed: _assignDriver,
                icon: const Icon(Icons.person_add),
                label: const Text('Assign Driver'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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

  Color _getPriorityColor(OrderPriority priority) {
    switch (priority) {
      case OrderPriority.normal:
        return AppTheme.mediumGrey;
      case OrderPriority.high:
        return AppTheme.warningOrange;
      case OrderPriority.urgent:
        return AppTheme.errorRed;
    }
  }

  Color _getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return AppTheme.warningOrange;
      case PaymentStatus.paid:
        return AppTheme.successGreen;
      case PaymentStatus.failed:
        return AppTheme.errorRed;
      case PaymentStatus.refunded:
        return AppTheme.mediumGrey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _approveOrder() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final success = await orderProvider.approveOrder(widget.order.id);

    if (success && mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order approved successfully'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    }
  }

  Future<void> _declineOrder() async {
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
                  Navigator.of(context).pop('No reason provided');
                },
                child: const Text('Decline'),
              ),
            ],
          ),
    );

    if (reason != null) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final success = await orderProvider.declineOrder(widget.order.id, reason);

      if (success && mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order declined'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _assignDriver() async {
    final staffProvider = Provider.of<StaffProvider>(context, listen: false);
    final drivers = staffProvider.drivers;

    if (drivers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No drivers available'),
          backgroundColor: AppTheme.warningOrange,
        ),
      );
      return;
    }

    final selectedDriver = await showDialog<Map<String, String>>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Assign Driver'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  drivers.map((driver) {
                    return ListTile(
                      title: Text(driver.fullName),
                      subtitle: Text(driver.phoneNumber ?? 'No phone'),
                      onTap: () {
                        Navigator.of(context).pop({
                          'id': driver.id,
                          'name': driver.fullName,
                          'phone': driver.phoneNumber ?? 'No phone',
                        });
                      },
                    );
                  }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );

    if (selectedDriver != null) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final success = await orderProvider.assignDriver(
        widget.order.id,
        selectedDriver['id']!,
        selectedDriver['name']!,
        selectedDriver['phone']!,
      );

      if (success && mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Driver assigned successfully'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    }
  }
}
