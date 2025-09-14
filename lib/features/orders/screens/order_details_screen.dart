import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../ui/primitives/card_x.dart';
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
    // Load staff after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStaff();
    });
  }

  Future<void> _loadStaff() async {
    final staffProvider = Provider.of<StaffProvider>(context, listen: false);
    await staffProvider.loadStaff('laundrette_business_1');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Order #${widget.order.id}',
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
        actions: [
          if (widget.order.isPendingApproval) ...[
            AnimatedButtons.secondary(
              onPressed: () => _approveOrder(),
              child: Text(
                'Approve',
                style: AppTypography.textTheme.labelMedium?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Gap.horizontal(AppSpacing.xs),
            AnimatedButtons.secondary(
              onPressed: () => _declineOrder(),
              child: Text(
                'Decline',
                style: AppTypography.textTheme.labelMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Gap.horizontal(AppSpacing.s),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: SpacingUtils.all(AppSpacing.l),
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
              _buildStaffInfoCard(),
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
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Status',
                  style: AppTypography.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: SpacingUtils.symmetric(
                    horizontal: AppSpacing.s,
                    vertical: AppSpacing.xs,
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
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(widget.order.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Gap.vertical(AppSpacing.s),
            Row(
              children: [
                _buildStatusItem(
                  'Priority',
                  widget.order.priorityDisplayText,
                  _getPriorityColor(widget.order.priority),
                ),
                const Gap.horizontal(AppSpacing.l),
                _buildStatusItem(
                  'Payment',
                  widget.order.paymentStatusDisplayText,
                  _getPaymentStatusColor(widget.order.paymentStatus),
                ),
              ],
            ),
            const Gap.vertical(AppSpacing.s),
            Row(
              children: [
                _buildStatusItem(
                  'Total',
                  '£${widget.order.total.toStringAsFixed(2)}',
                  AppColors.primary,
                ),
                const Gap.horizontal(AppSpacing.l),
                _buildStatusItem(
                  'Created',
                  _formatDateTime(widget.order.createdAt),
                  AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, Color color) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const Gap.vertical(AppSpacing.xs),
        Text(
          value,
          style: AppTypography.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfoCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Information',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap.vertical(AppSpacing.m),
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
                      Text('£${bag['price'].toStringAsFixed(2)}'),
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
            '£${amount.toStringAsFixed(2)}',
            style:
                isTotal
                    ? Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
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
                      ? AppColors.successGreen.withOpacity(0.1)
                      : AppColors.mediumGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color:
                  isCompleted ? AppColors.successGreen : AppColors.mediumGrey,
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
                        isCompleted ? AppColors.darkGrey : AppColors.mediumGrey,
                  ),
                ),
                Text(
                  _formatDateTime(dateTime),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.mediumGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Staff Information',
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
                      backgroundColor: AppColors.successGreen,
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
                      backgroundColor: AppColors.errorRed,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.order.status == LaundretteOrderStatus.approved) ...[
              ElevatedButton.icon(
                onPressed: _assignStaff,
                icon: const Icon(Icons.person_add),
                label: const Text('Assign Staff'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(LaundretteOrderStatus status) {
    switch (status) {
      case LaundretteOrderStatus.pending:
        return AppColors.warning;
      case LaundretteOrderStatus.approved:
        return AppColors.info;
      case LaundretteOrderStatus.declined:
        return AppColors.error;
      case LaundretteOrderStatus.confirmed:
        return AppColors.primary;
      case LaundretteOrderStatus.pickedUp:
        return AppColors.primary;
      case LaundretteOrderStatus.inProgress:
        return AppColors.success;
      case LaundretteOrderStatus.ready:
        return AppColors.warning;
      case LaundretteOrderStatus.outForDelivery:
        return AppColors.primary;
      case LaundretteOrderStatus.delivered:
        return AppColors.success;
      case LaundretteOrderStatus.cancelled:
        return AppColors.onSurfaceVariant;
    }
  }

  Color _getPriorityColor(OrderPriority priority) {
    switch (priority) {
      case OrderPriority.normal:
        return AppColors.onSurfaceVariant;
      case OrderPriority.high:
        return AppColors.warning;
      case OrderPriority.urgent:
        return AppColors.error;
    }
  }

  Color _getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return AppColors.warning;
      case PaymentStatus.paid:
        return AppColors.success;
      case PaymentStatus.failed:
        return AppColors.error;
      case PaymentStatus.refunded:
        return AppColors.onSurfaceVariant;
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
          backgroundColor: AppColors.successGreen,
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
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _assignStaff() async {
    final staffProvider = Provider.of<StaffProvider>(context, listen: false);
    final staff = staffProvider.staff;

    if (staff.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No staff available'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final selectedStaff = await showDialog<Map<String, String>>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Assign Staff'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  staff.map((staffMember) {
                    return ListTile(
                      title: Text(staffMember.fullName),
                      subtitle: Text(staffMember.phoneNumber ?? 'No phone'),
                      onTap: () {
                        Navigator.of(context).pop({
                          'id': staffMember.id,
                          'name': staffMember.fullName,
                          'phone': staffMember.phoneNumber ?? 'No phone',
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

    if (selectedStaff != null) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final success = await orderProvider.assignDriver(
        widget.order.id,
        selectedStaff['id']!,
        selectedStaff['name']!,
        selectedStaff['phone']!,
      );

      if (success && mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Staff assigned successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }
}
