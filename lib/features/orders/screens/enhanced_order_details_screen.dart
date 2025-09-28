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
import '../data/models/tenant_order_model.dart';

class EnhancedOrderDetailsScreen extends StatefulWidget {
  final TenantOrderModel order;

  const EnhancedOrderDetailsScreen({super.key, required this.order});

  @override
  State<EnhancedOrderDetailsScreen> createState() =>
      _EnhancedOrderDetailsScreenState();
}

class _EnhancedOrderDetailsScreenState extends State<EnhancedOrderDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    // Load additional order data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrderData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrderData() async {
    final orderProvider = Provider.of<TenantOrderProvider>(
      context,
      listen: false,
    );
    setState(() => _isLoading = true);

    try {
      await orderProvider.loadOrderDetails(widget.order.id);
      await orderProvider.loadOrderTags(widget.order.id);
      await orderProvider.loadOrderStatusHistory(widget.order.id);
      await orderProvider.loadOrderAssignments(widget.order.id);
    } finally {
      setState(() => _isLoading = false);
    }
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
            AnimatedButton(
              onPressed: () => _updateOrderStatus(TenantOrderStatus.confirmed),
              child: Text(
                'Approve',
                style: AppTypography.textTheme.labelMedium?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Gap.horizontal(AppSpacing.xs),
            AnimatedButton(
              onPressed: () => _updateOrderStatus(TenantOrderStatus.cancelled),
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
                Tab(text: 'Overview'),
                Tab(text: 'Items'),
                Tab(text: 'Timeline'),
                Tab(text: 'Tags'),
              ],
            ),
          ),
        ),
      ),
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
              : TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildItemsTab(),
                  _buildTimelineTab(),
                  _buildTagsTab(),
                ],
              ),
    );
  }

  Widget _buildOverviewTab() {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: SpacingUtils.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderStatusCard(),
          const Gap.vertical(AppSpacing.l),
          _buildCustomerInfoCard(),
          const Gap.vertical(AppSpacing.l),
          _buildPricingCard(),
          const Gap.vertical(AppSpacing.l),
          _buildDriverInfoCard(),
          const Gap.vertical(AppSpacing.l),
          _buildActionButtons(),
        ],
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
                ChipsX.status(
                  label: widget.order.statusDisplayText,
                  status: _getChipStatus(widget.order.status),
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
            _buildInfoRow('Email', widget.order.customerEmail),
            if (widget.order.pickupAddress != null)
              _buildInfoRow('Pickup Address', widget.order.pickupAddress!),
            if (widget.order.deliveryAddress != null)
              _buildInfoRow('Delivery Address', widget.order.deliveryAddress!),
            if (widget.order.notes != null)
              _buildInfoRow('Notes', widget.order.notes!),
            if (widget.order.specialInstructions != null)
              _buildInfoRow(
                'Special Instructions',
                widget.order.specialInstructions!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing Breakdown',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap.vertical(AppSpacing.m),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                isTotal
                    ? AppTypography.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    )
                    : AppTypography.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
          ),
          Text(
            '£${amount.toStringAsFixed(2)}',
            style:
                isTotal
                    ? AppTypography.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    )
                    : AppTypography.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfoCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Driver Information',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap.vertical(AppSpacing.m),
            if (widget.order.driverId != null) ...[
              _buildInfoRow('Name', widget.order.driverName ?? 'Not assigned'),
              _buildInfoRow(
                'Phone',
                widget.order.driverPhone ?? 'Not available',
              ),
            ] else ...[
              Text(
                'No driver assigned',
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Gap.vertical(AppSpacing.s),
              AnimatedButton(
                onPressed: _assignDriver,
                child: Text(
                  'Assign Driver',
                  style: AppTypography.textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap.vertical(AppSpacing.m),
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: [
                if (widget.order.isPendingApproval) ...[
                  AnimatedButton(
                    onPressed:
                        () => _updateOrderStatus(TenantOrderStatus.confirmed),
                    backgroundColor: AppColors.success,
                    child: Text(
                      'Approve Order',
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedButton(
                    onPressed:
                        () => _updateOrderStatus(TenantOrderStatus.cancelled),
                    backgroundColor: AppColors.error,
                    child: Text(
                      'Decline Order',
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                if (widget.order.isConfirmed) ...[
                  AnimatedButton(
                    onPressed:
                        () => _updateOrderStatus(TenantOrderStatus.pickedUp),
                    backgroundColor: AppColors.primary,
                    child: Text(
                      'Mark Picked Up',
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                if (widget.order.isPickedUp) ...[
                  AnimatedButton(
                    onPressed:
                        () => _updateOrderStatus(TenantOrderStatus.inProgress),
                    backgroundColor: AppColors.info,
                    child: Text(
                      'Start Processing',
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                if (widget.order.isInProgress) ...[
                  AnimatedButton(
                    onPressed:
                        () => _updateOrderStatus(
                          TenantOrderStatus.readyForDelivery,
                        ),
                    backgroundColor: AppColors.warning,
                    child: Text(
                      'Mark Ready',
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                if (widget.order.isReadyForDelivery) ...[
                  AnimatedButton(
                    onPressed:
                        () => _updateOrderStatus(
                          TenantOrderStatus.outForDelivery,
                        ),
                    backgroundColor: AppColors.primary,
                    child: Text(
                      'Out for Delivery',
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                if (widget.order.isOutForDelivery) ...[
                  AnimatedButton(
                    onPressed:
                        () => _updateOrderStatus(TenantOrderStatus.delivered),
                    backgroundColor: AppColors.success,
                    child: Text(
                      'Mark Delivered',
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                if (widget.order.isDelivered) ...[
                  AnimatedButton(
                    onPressed:
                        () => _updateOrderStatus(TenantOrderStatus.completed),
                    backgroundColor: AppColors.success,
                    child: Text(
                      'Complete Order',
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsTab() {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: SpacingUtils.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Items',
            style: AppTypography.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap.vertical(AppSpacing.m),
          if (widget.order.orderItems.isEmpty)
            Center(
              child: Text(
                'No items found',
                style: AppTypography.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            ...widget.order.orderItems.map((item) => _buildOrderItemCard(item)),
        ],
      ),
    );
  }

  Widget _buildOrderItemCard(OrderItemModel item) {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
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
                  item.itemType.toUpperCase(),
                  style: AppTypography.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  '£${item.price.toStringAsFixed(2)}',
                  style: AppTypography.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Gap.vertical(AppSpacing.s),
            Text(
              'Weight: ${item.weight}kg',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap.vertical(AppSpacing.s),
            Text(
              'Services: ${item.services.join(', ')}',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineTab() {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: SpacingUtils.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Timeline',
            style: AppTypography.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap.vertical(AppSpacing.m),
          if (widget.order.statusHistory.isEmpty)
            Center(
              child: Text(
                'No timeline data available',
                style: AppTypography.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            ...widget.order.statusHistory.map(
              (history) => _buildTimelineItem(history),
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(OrderStatusHistoryModel history) {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      margin: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.m),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(AppIcons.clock, color: AppColors.primary, size: 16),
            ),
            const Gap.horizontal(AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    history.status.name.toUpperCase(),
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (history.notes != null) ...[
                    const Gap.vertical(AppSpacing.xs),
                    Text(
                      history.notes!,
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const Gap.vertical(AppSpacing.xs),
                  Text(
                    _formatDateTime(history.statusChangedAt),
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsTab() {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: SpacingUtils.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Tags',
                style: AppTypography.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AnimatedButton(
                onPressed: _addTag,
                child: Text(
                  'Add Tag',
                  style: AppTypography.textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Gap.vertical(AppSpacing.m),
          if (widget.order.tags.isEmpty)
            Center(
              child: Text(
                'No tags added',
                style: AppTypography.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children:
                  widget.order.tags.map((tag) => _buildTagChip(tag)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildTagChip(OrderTagModel tag) {
    final colorScheme = Theme.of(context).colorScheme;

    return ChipsX.status(
      label: tag.value,
      status: _getTagChipStatus(tag.type),
      onDelete: () => _removeTag(tag.id),
    );
  }

  ChipStatus _getTagChipStatus(OrderTagType type) {
    switch (type) {
      case OrderTagType.location:
        return ChipStatus.info;
      case OrderTagType.status:
        return ChipStatus.primary;
      case OrderTagType.priority:
        return ChipStatus.warning;
      case OrderTagType.service:
        return ChipStatus.success;
      case OrderTagType.custom:
        return ChipStatus.neutral;
    }
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

  Color _getPriorityColor(OrderPriority priority) {
    switch (priority) {
      case OrderPriority.normal:
        return AppColors.onSurfaceVariant;
      case OrderPriority.high:
        return AppColors.warning;
      case OrderPriority.urgent:
        return AppColors.error;
      case OrderPriority.express:
        return AppColors.primary;
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
      case PaymentStatus.partiallyRefunded:
        return AppColors.warning;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _updateOrderStatus(TenantOrderStatus status) async {
    final orderProvider = Provider.of<TenantOrderProvider>(
      context,
      listen: false,
    );
    final success = await orderProvider.updateOrderStatus(
      widget.order.id,
      status,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order status updated to ${status.name}'),
          backgroundColor: AppColors.success,
        ),
      );
      _loadOrderData();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update order status'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _assignDriver() async {
    final orderProvider = Provider.of<TenantOrderProvider>(
      context,
      listen: false,
    );
    await orderProvider.loadAvailableDrivers();

    if (orderProvider.availableDrivers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No available drivers found'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final selectedDriver = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Assign Driver'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  orderProvider.availableDrivers.map((driver) {
                    return ListTile(
                      title: Text(driver['name'] ?? 'Unknown'),
                      subtitle: Text(driver['phone'] ?? 'No phone'),
                      onTap: () => Navigator.of(context).pop(driver),
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
      final success = await orderProvider.assignToDriver(
        widget.order.id,
        selectedDriver['id'],
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Driver assigned successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadOrderData();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to assign driver'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _addTag() async {
    final tagType = await showDialog<OrderTagType>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Tag Type'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  OrderTagType.values.map((type) {
                    return ListTile(
                      title: Text(type.name.toUpperCase()),
                      onTap: () => Navigator.of(context).pop(type),
                    );
                  }).toList(),
            ),
          ),
    );

    if (tagType != null) {
      final value = await showDialog<String>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Add Tag'),
              content: TextField(
                decoration: const InputDecoration(
                  labelText: 'Tag Value',
                  hintText: 'Enter tag value...',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Get the value from the text field
                    Navigator.of(context).pop('Sample Value');
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
      );

      if (value != null) {
        final orderProvider = Provider.of<TenantOrderProvider>(
          context,
          listen: false,
        );
        final success = await orderProvider.addOrderTag(
          widget.order.id,
          tagType,
          value,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tag added successfully'),
              backgroundColor: AppColors.success,
            ),
          );
          _loadOrderData();
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add tag'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _removeTag(String tagId) async {
    final orderProvider = Provider.of<TenantOrderProvider>(
      context,
      listen: false,
    );
    final success = await orderProvider.removeOrderTag(widget.order.id, tagId);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tag removed successfully'),
          backgroundColor: AppColors.success,
        ),
      );
      _loadOrderData();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove tag'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
