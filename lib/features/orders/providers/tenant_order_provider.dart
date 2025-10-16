import 'package:flutter/material.dart';
import '../domain/models/tenant_order_model.dart';
import '../domain/repositories/tenant_order_repository.dart';

/// Provider for managing tenant order state and logic
class TenantOrderProvider extends ChangeNotifier {
  final TenantOrderRepository repository;

  TenantOrderProvider({required this.repository});

  // State variables
  List<TenantOrderModel> _orders = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic> _analytics = {};
  Map<String, dynamic> _statistics = {};
  List<Map<String, dynamic>> _availableDrivers = [];

  // Getters
  List<TenantOrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic> get analytics => _analytics;
  Map<String, dynamic> get statistics => _statistics;
  List<Map<String, dynamic>> get availableDrivers => _availableDrivers;

  /// Get orders by status
  List<TenantOrderModel> getOrdersByStatus(TenantOrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  /// Get pending orders
  List<TenantOrderModel> get pendingOrders =>
      getOrdersByStatus(TenantOrderStatus.pending);

  /// Get confirmed orders
  List<TenantOrderModel> get confirmedOrders =>
      getOrdersByStatus(TenantOrderModel.confirmed);

  /// Get picked up orders
  List<TenantOrderModel> get pickedUpOrders =>
      getOrdersByStatus(TenantOrderModel.readyForPickup);

  /// Get in progress orders
  List<TenantOrderModel> get inProgressOrders =>
      getOrdersByStatus(TenantOrderStatus.inProgress);

  /// Get ready for delivery orders (alias for readyForPickup)
  List<TenantOrderModel> get readyForDeliveryOrders =>
      getOrdersByStatus(TenantOrderModel.readyForPickup);

  /// Get out for delivery orders (alias for inProgress)
  List<TenantOrderModel> get outForDeliveryOrders =>
      getOrdersByStatus(TenantOrderStatus.inProgress);

  /// Get delivered orders (alias for completed)
  List<TenantOrderModel> get deliveredOrders =>
      getOrdersByStatus(TenantOrderModel.completed);

  /// Get completed orders
  List<TenantOrderModel> get completedOrders =>
      getOrdersByStatus(TenantOrderModel.completed);

  /// Get cancelled orders
  List<TenantOrderModel> get cancelledOrders =>
      getOrdersByStatus(TenantOrderStatus.cancelled);

  /// Get on hold orders (alias for pending)
  List<TenantOrderModel> get onHoldOrders =>
      getOrdersByStatus(TenantOrderStatus.pending);

  /// Get returned orders (alias for cancelled)
  List<TenantOrderModel> get returnedOrders =>
      getOrdersByStatus(TenantOrderStatus.cancelled);

  /// Get high priority orders
  List<TenantOrderModel> get highPriorityOrders {
    // Since the model doesn't have priority, return all orders
    return _orders;
  }

  /// Get orders by date range
  List<TenantOrderModel> getOrdersByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _orders.where((order) {
      return order.createdAt.isAfter(startDate) &&
          order.createdAt.isBefore(endDate);
    }).toList();
  }

  /// Get orders by branch
  List<TenantOrderModel> getOrdersByBranch(String branchId) {
    return _orders.where((order) => order.branchId == branchId).toList();
  }

  /// Get order by ID
  TenantOrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  /// Load orders
  Future<void> loadOrders({
    String? status,
    String? priority,
    String? paymentStatus,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 20,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final orders = await repository.getOrders(
        status: status,
        priority: priority,
        paymentStatus: paymentStatus,
        startDate: startDate,
        endDate: endDate,
        page: page,
        limit: limit,
      );

      _orders = orders;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load order details
  Future<TenantOrderModel?> loadOrderDetails(String orderId) async {
    try {
      final order = await repository.getOrderDetails(orderId);

      // Update the order in the list
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = order;
        notifyListeners();
      }

      return order;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Update order status
  Future<bool> updateOrderStatus(
    String orderId,
    TenantOrderStatus status, {
    String? notes,
  }) async {
    try {
      final updatedOrder = await repository.updateOrderStatus(
        orderId,
        status,
        notes: notes,
      );

      // Update the order in the list
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = updatedOrder;
        notifyListeners();
      }

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Assign driver to order
  Future<bool> assignToDriver(String orderId, String driverId) async {
    try {
      final updatedOrder = await repository.assignToDriver(orderId, driverId);

      // Update the order in the list
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = updatedOrder;
        notifyListeners();
      }

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Load analytics
  Future<void> loadAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    String? branchId,
  }) async {
    try {
      final analytics = await repository.getOrderAnalytics(
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
      );

      _analytics = analytics;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Load statistics
  Future<void> loadStatistics({
    DateTime? startDate,
    DateTime? endDate,
    String? branchId,
  }) async {
    try {
      final statistics = await repository.getOrderStatistics(
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
      );

      _statistics = statistics;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Add tag to order
  Future<bool> addOrderTag(
    String orderId,
    OrderTagType type,
    String value, {
    String? description,
  }) async {
    try {
      final tag = await repository.addOrderTag(
        orderId,
        type,
        value,
        description: description,
      );

      // Update the order in the list
      // Note: copyWith and tags not implemented in current model
      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Remove tag from order
  Future<bool> removeOrderTag(String orderId, String tagId) async {
    try {
      await repository.removeOrderTag(orderId, tagId);

      // Update the order in the list
      // Note: copyWith and tags not implemented in current model
      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Load order tags
  Future<List<OrderTagModel>> loadOrderTags(String orderId) async {
    try {
      return await repository.getOrderTags(orderId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  /// Load order status history
  Future<List<OrderStatusHistoryModel>> loadOrderStatusHistory(
    String orderId,
  ) async {
    try {
      return await repository.getOrderStatusHistory(orderId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  /// Load order assignments
  Future<List<OrderAssignmentModel>> loadOrderAssignments(
    String orderId,
  ) async {
    try {
      return await repository.getOrderAssignments(orderId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  /// Load available drivers
  Future<void> loadAvailableDrivers({
    String? branchId,
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    try {
      final drivers = await repository.getAvailableDrivers(
        branchId: branchId,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );

      _availableDrivers = drivers;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Refresh orders
  Future<void> refreshOrders() async {
    await loadOrders();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Get order summary statistics
  Map<String, int> getOrderSummary() {
    return {
      'total': _orders.length,
      'pending': pendingOrders.length,
      'confirmed': confirmedOrders.length,
      'pickedUp': pickedUpOrders.length,
      'inProgress': inProgressOrders.length,
      'readyForDelivery': readyForDeliveryOrders.length,
      'outForDelivery': outForDeliveryOrders.length,
      'delivered': deliveredOrders.length,
      'completed': completedOrders.length,
      'cancelled': cancelledOrders.length,
      'onHold': onHoldOrders.length,
      'returned': returnedOrders.length,
    };
  }

  /// Get revenue summary
  Map<String, double> getRevenueSummary() {
    double totalRevenue = 0;
    double pendingRevenue = 0;
    double completedRevenue = 0;

    for (final order in _orders) {
      totalRevenue += order.totalAmount;

      if (order.status == TenantOrderModel.completed) {
        completedRevenue += order.totalAmount;
      } else {
        pendingRevenue += order.totalAmount;
      }
    }

    return {
      'total': totalRevenue,
      'pending': pendingRevenue,
      'completed': completedRevenue,
    };
  }

  /// Get average order value
  double getAverageOrderValue() {
    if (_orders.isEmpty) return 0.0;

    final totalRevenue = _orders.fold<double>(
      0,
      (sum, order) => sum + order.totalAmount,
    );
    return totalRevenue / _orders.length;
  }

  /// Get orders by time period
  List<TenantOrderModel> getOrdersByTimePeriod(TimePeriod period) {
    final now = DateTime.now();
    final startDate = switch (period) {
      TimePeriod.today => DateTime(now.year, now.month, now.day),
      TimePeriod.week => now.subtract(const Duration(days: 7)),
      TimePeriod.month => DateTime(now.year, now.month - 1, now.day),
      TimePeriod.year => DateTime(now.year - 1, now.month, now.day),
    };

    return _orders
        .where((order) => order.createdAt.isAfter(startDate))
        .toList();
  }
}

/// Time period enum for filtering
enum TimePeriod { today, week, month, year }
