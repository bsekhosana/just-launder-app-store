import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/laundrette_order.dart';

class OrderFiltersWidget extends StatefulWidget {
  final Function(OrderFilters) onFiltersChanged;
  final OrderFilters currentFilters;

  const OrderFiltersWidget({
    super.key,
    required this.onFiltersChanged,
    required this.currentFilters,
  });

  @override
  State<OrderFiltersWidget> createState() => _OrderFiltersWidgetState();
}

class _OrderFiltersWidgetState extends State<OrderFiltersWidget> {
  late OrderFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters;
  }

  @override
  Widget build(BuildContext context) {
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
                  'Filters',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatusFilter(),
            const SizedBox(height: 16),
            _buildPriorityFilter(),
            const SizedBox(height: 16),
            _buildPaymentStatusFilter(),
            const SizedBox(height: 16),
            _buildDateRangeFilter(),
            const SizedBox(height: 16),
            _buildAmountRangeFilter(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Status',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children:
              LaundretteOrderStatus.values.map((status) {
                final isSelected = _filters.statuses.contains(status);
                return FilterChip(
                  label: Text(_getStatusDisplayText(status)),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _filters.statuses.add(status);
                      } else {
                        _filters.statuses.remove(status);
                      }
                    });
                    widget.onFiltersChanged(_filters);
                  },
                  selectedColor: _getStatusColor(status).withOpacity(0.2),
                  checkmarkColor: _getStatusColor(status),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriorityFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children:
              OrderPriority.values.map((priority) {
                final isSelected = _filters.priorities.contains(priority);
                return FilterChip(
                  label: Text(_getPriorityDisplayText(priority)),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _filters.priorities.add(priority);
                      } else {
                        _filters.priorities.remove(priority);
                      }
                    });
                    widget.onFiltersChanged(_filters);
                  },
                  selectedColor: _getPriorityColor(priority).withOpacity(0.2),
                  checkmarkColor: _getPriorityColor(priority),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildPaymentStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Status',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children:
              PaymentStatus.values.map((status) {
                final isSelected = _filters.paymentStatuses.contains(status);
                return FilterChip(
                  label: Text(_getPaymentStatusDisplayText(status)),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _filters.paymentStatuses.add(status);
                      } else {
                        _filters.paymentStatuses.remove(status);
                      }
                    });
                    widget.onFiltersChanged(_filters);
                  },
                  selectedColor: _getPaymentStatusColor(
                    status,
                  ).withOpacity(0.2),
                  checkmarkColor: _getPaymentStatusColor(status),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _selectStartDate,
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(
                  _filters.startDate != null
                      ? _formatDate(_filters.startDate!)
                      : 'Start Date',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _selectEndDate,
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(
                  _filters.endDate != null
                      ? _formatDate(_filters.endDate!)
                      : 'End Date',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount Range',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Min Amount',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _filters.minAmount = double.tryParse(value);
                  widget.onFiltersChanged(_filters);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Max Amount',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _filters.maxAmount = double.tryParse(value);
                  widget.onFiltersChanged(_filters);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _filters.startDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _filters.startDate = date;
      });
      widget.onFiltersChanged(_filters);
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _filters.endDate ?? DateTime.now(),
      firstDate:
          _filters.startDate ??
          DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _filters.endDate = date;
      });
      widget.onFiltersChanged(_filters);
    }
  }

  void _clearFilters() {
    setState(() {
      _filters = OrderFilters();
    });
    widget.onFiltersChanged(_filters);
  }

  String _getStatusDisplayText(LaundretteOrderStatus status) {
    switch (status) {
      case LaundretteOrderStatus.pending:
        return 'Pending';
      case LaundretteOrderStatus.approved:
        return 'Approved';
      case LaundretteOrderStatus.declined:
        return 'Declined';
      case LaundretteOrderStatus.confirmed:
        return 'Confirmed';
      case LaundretteOrderStatus.pickedUp:
        return 'Picked Up';
      case LaundretteOrderStatus.inProgress:
        return 'In Progress';
      case LaundretteOrderStatus.ready:
        return 'Ready';
      case LaundretteOrderStatus.outForDelivery:
        return 'Out for Delivery';
      case LaundretteOrderStatus.delivered:
        return 'Delivered';
      case LaundretteOrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _getPriorityDisplayText(OrderPriority priority) {
    switch (priority) {
      case OrderPriority.normal:
        return 'Normal';
      case OrderPriority.high:
        return 'High';
      case OrderPriority.urgent:
        return 'Urgent';
    }
  }

  String _getPaymentStatusDisplayText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class OrderFilters {
  Set<LaundretteOrderStatus> statuses = {};
  Set<OrderPriority> priorities = {};
  Set<PaymentStatus> paymentStatuses = {};
  DateTime? startDate;
  DateTime? endDate;
  double? minAmount;
  double? maxAmount;

  OrderFilters();

  bool get hasActiveFilters {
    return statuses.isNotEmpty ||
        priorities.isNotEmpty ||
        paymentStatuses.isNotEmpty ||
        startDate != null ||
        endDate != null ||
        minAmount != null ||
        maxAmount != null;
  }

  bool matchesOrder(LaundretteOrder order) {
    if (statuses.isNotEmpty && !statuses.contains(order.status)) {
      return false;
    }
    if (priorities.isNotEmpty && !priorities.contains(order.priority)) {
      return false;
    }
    if (paymentStatuses.isNotEmpty &&
        !paymentStatuses.contains(order.paymentStatus)) {
      return false;
    }
    if (startDate != null && order.createdAt.isBefore(startDate!)) {
      return false;
    }
    if (endDate != null &&
        order.createdAt.isAfter(endDate!.add(const Duration(days: 1)))) {
      return false;
    }
    if (minAmount != null && order.total < minAmount!) {
      return false;
    }
    if (maxAmount != null && order.total > maxAmount!) {
      return false;
    }
    return true;
  }
}
