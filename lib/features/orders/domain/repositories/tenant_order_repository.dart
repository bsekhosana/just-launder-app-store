import '../models/tenant_order_model.dart';

/// Abstract repository for tenant order operations
abstract class TenantOrderRepository {
  /// Get all orders for a tenant
  Future<List<TenantOrderModel>> getOrders({
    String? status,
    String? priority,
    String? paymentStatus,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 20,
  });

  /// Get order details by ID
  Future<TenantOrderModel> getOrderDetails(String orderId);

  /// Update order status
  Future<TenantOrderModel> updateOrderStatus(
    String orderId,
    TenantOrderStatus status, {
    String? notes,
  });

  /// Assign driver to order
  Future<TenantOrderModel> assignToDriver(String orderId, String driverId);

  /// Get order analytics
  Future<Map<String, dynamic>> getOrderAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    String? branchId,
  });

  /// Get order statistics
  Future<Map<String, dynamic>> getOrderStatistics({
    DateTime? startDate,
    DateTime? endDate,
    String? branchId,
  });

  /// Add tag to order
  Future<OrderTagModel> addOrderTag(
    String orderId,
    OrderTagType type,
    String value, {
    String? description,
  });

  /// Remove tag from order
  Future<void> removeOrderTag(String orderId, String tagId);

  /// Get order tags
  Future<List<OrderTagModel>> getOrderTags(String orderId);

  /// Get order status history
  Future<List<OrderStatusHistoryModel>> getOrderStatusHistory(String orderId);

  /// Get order assignments
  Future<List<OrderAssignmentModel>> getOrderAssignments(String orderId);

  /// Get available drivers for assignment
  Future<List<Map<String, dynamic>>> getAvailableDrivers({
    String? branchId,
    double? latitude,
    double? longitude,
    double? radius,
  });
}
