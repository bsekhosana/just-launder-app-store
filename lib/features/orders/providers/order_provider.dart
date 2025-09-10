import 'package:flutter/material.dart';
import '../../../data/models/laundrette_order.dart';

/// Order provider for managing laundrette orders
class OrderProvider extends ChangeNotifier {
  List<LaundretteOrder> _orders = [];
  bool _isLoading = false;

  List<LaundretteOrder> get orders => _orders;
  bool get isLoading => _isLoading;

  /// Get orders by status
  List<LaundretteOrder> getOrdersByStatus(LaundretteOrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  /// Get pending orders
  List<LaundretteOrder> get pendingOrders =>
      getOrdersByStatus(LaundretteOrderStatus.pending);

  /// Get approved orders
  List<LaundretteOrder> get approvedOrders =>
      getOrdersByStatus(LaundretteOrderStatus.approved);

  /// Get in progress orders
  List<LaundretteOrder> get inProgressOrders =>
      getOrdersByStatus(LaundretteOrderStatus.inProgress);

  /// Get completed orders
  List<LaundretteOrder> get completedOrders =>
      getOrdersByStatus(LaundretteOrderStatus.delivered);

  /// Load orders for a laundrette
  Future<void> loadOrders(String laundretteId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - replace with real API call
      _orders = [
        LaundretteOrder(
          id: 'order_1',
          customerId: 'customer_1',
          customerName: 'John Smith',
          customerPhone: '+1-555-0101',
          branchId: 'branch_1',
          branchName: 'Downtown Branch',
          status: LaundretteOrderStatus.pending,
          priority: OrderPriority.normal,
          paymentStatus: PaymentStatus.pending,
          subtotal: 45.97,
          deliveryFee: 5.00,
          total: 50.97,
          notes: 'Please handle with care',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          orderItems: {
            'bags': [
              {
                'type': 'medium',
                'weight': 3.5,
                'services': ['wash_and_fold', 'ironing'],
                'price': 25.98,
              },
              {
                'type': 'small',
                'weight': 2.0,
                'services': ['wash_and_fold'],
                'price': 20.99,
              },
            ],
          },
          metadata: {
            'customerAddress': '123 Customer Street, New York, NY 10001',
            'specialInstructions': 'Use gentle cycle',
          },
          updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        LaundretteOrder(
          id: 'order_2',
          customerId: 'customer_2',
          customerName: 'Sarah Johnson',
          customerPhone: '+1-555-0102',
          branchId: 'branch_1',
          branchName: 'Downtown Branch',
          status: LaundretteOrderStatus.approved,
          priority: OrderPriority.high,
          paymentStatus: PaymentStatus.paid,
          subtotal: 67.47,
          deliveryFee: 8.00,
          total: 75.47,
          scheduledPickupTime: DateTime.now().add(const Duration(hours: 1)),
          notes: 'Urgent delivery needed',
          createdAt: DateTime.now().subtract(const Duration(hours: 4)),
          orderItems: {
            'bags': [
              {
                'type': 'large',
                'weight': 5.0,
                'services': ['wash_and_fold', 'dry_clean', 'express'],
                'price': 45.47,
              },
              {
                'type': 'medium',
                'weight': 3.0,
                'services': ['wash_and_fold'],
                'price': 22.00,
              },
            ],
          },
          metadata: {
            'customerAddress': '456 Customer Avenue, New York, NY 10002',
            'specialInstructions': 'Express service requested',
          },
          updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        LaundretteOrder(
          id: 'order_3',
          customerId: 'customer_3',
          customerName: 'Mike Wilson',
          customerPhone: '+1-555-0103',
          branchId: 'branch_2',
          branchName: 'Uptown Branch',
          status: LaundretteOrderStatus.inProgress,
          priority: OrderPriority.normal,
          paymentStatus: PaymentStatus.paid,
          subtotal: 32.98,
          deliveryFee: 4.00,
          total: 36.98,
          actualPickupTime: DateTime.now().subtract(const Duration(hours: 6)),
          estimatedDeliveryTime: DateTime.now().add(const Duration(hours: 18)),
          notes: 'Regular service',
          createdAt: DateTime.now().subtract(const Duration(hours: 8)),
          orderItems: {
            'bags': [
              {
                'type': 'medium',
                'weight': 4.0,
                'services': ['wash_and_fold'],
                'price': 32.98,
              },
            ],
          },
          metadata: {
            'customerAddress': '789 Customer Boulevard, New York, NY 10028',
            'specialInstructions': 'Standard processing',
          },
          updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        LaundretteOrder(
          id: 'order_4',
          customerId: 'customer_4',
          customerName: 'Emily Davis',
          customerPhone: '+1-555-0104',
          branchId: 'branch_3',
          branchName: 'Home Location',
          status: LaundretteOrderStatus.delivered,
          priority: OrderPriority.normal,
          paymentStatus: PaymentStatus.paid,
          subtotal: 28.98,
          deliveryFee: 3.00,
          total: 31.98,
          actualPickupTime: DateTime.now().subtract(
            const Duration(days: 1, hours: 12),
          ),
          actualDeliveryTime: DateTime.now().subtract(const Duration(hours: 2)),
          notes: 'Delivered successfully',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          orderItems: {
            'bags': [
              {
                'type': 'small',
                'weight': 2.5,
                'services': ['wash_and_fold', 'ironing'],
                'price': 28.98,
              },
            ],
          },
          metadata: {
            'customerAddress': '321 Customer Lane, Los Angeles, CA 90210',
            'specialInstructions': 'Delivered on time',
          },
          updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Approve order
  Future<bool> approveOrder(String orderId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          status: LaundretteOrderStatus.approved,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Decline order
  Future<bool> declineOrder(String orderId, String reason) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          status: LaundretteOrderStatus.declined,
          declineReason: reason,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Update order status
  Future<bool> updateOrderStatus(
    String orderId,
    LaundretteOrderStatus status,
  ) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          status: status,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Assign driver to order
  Future<bool> assignDriver(
    String orderId,
    String driverId,
    String driverName,
    String driverPhone,
  ) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          driverId: driverId,
          driverName: driverName,
          driverPhone: driverPhone,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get order by ID
  LaundretteOrder? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (e) {
      return null;
    }
  }
}
