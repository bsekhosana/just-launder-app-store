import '../../../core/services/api_service.dart';
import '../domain/models/tenant_order_model.dart';

/// Remote data source for tenant order operations
class TenantOrderRemoteDataSource {
  final ApiService _apiService;

  TenantOrderRemoteDataSource({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  /// Get all orders for a tenant
  Future<List<TenantOrderModel>> getOrders({
    String? status,
    String? priority,
    String? paymentStatus,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (status != null) queryParams['status'] = status;
    if (priority != null) queryParams['priority'] = priority;
    if (paymentStatus != null) queryParams['payment_status'] = paymentStatus;
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String();
    }
    if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

    final response = await _apiService.get(
      '/api/v1/tenant/orders',
      queryParameters: queryParams,
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;

      // Handle the API response structure: { "success": true, "data": { "data": [...] } }
      if (data is Map<String, dynamic> && data['success'] == true) {
        final responseData = data['data'] as Map<String, dynamic>?;
        if (responseData != null && responseData.containsKey('data')) {
          // Handle paginated response structure
          final ordersData = responseData['data'] as List<dynamic>? ?? [];
          final orders =
              ordersData
                  .map(
                    (order) => TenantOrderModel.fromJson(
                      order as Map<String, dynamic>,
                    ),
                  )
                  .toList();
          return orders;
        }
      }

      // Fallback: if data is directly a list
      final ordersData = data as List<dynamic>? ?? [];
      final orders =
          ordersData
              .map(
                (order) =>
                    TenantOrderModel.fromJson(order as Map<String, dynamic>),
              )
              .toList();
      return orders;
    } else {
      throw Exception('Failed to load orders: ${response.statusCode}');
    }
  }

  /// Get order details by ID
  Future<TenantOrderModel> getOrderDetails(String orderId) async {
    final response = await _apiService.get('/api/v1/tenant/orders/$orderId');

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return TenantOrderModel.fromJson(data['data']);
    } else {
      throw Exception('Failed to load order details: ${response.statusCode}');
    }
  }

  /// Update order status
  Future<TenantOrderModel> updateOrderStatus(
    String orderId,
    TenantOrderStatus status, {
    String? notes,
  }) async {
    final response = await _apiService.put(
      '/api/v1/tenant/orders/$orderId/status',
      data: {'status': status.name, if (notes != null) 'notes': notes},
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return TenantOrderModel.fromJson(data['data']);
    } else {
      throw Exception('Failed to update order status: ${response.statusCode}');
    }
  }

  /// Assign driver to order
  Future<TenantOrderModel> assignToDriver(
    String orderId,
    String driverId,
  ) async {
    final response = await _apiService.post(
      '/api/v1/tenant/orders/$orderId/assign-driver',
      data: {'driver_id': driverId},
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return TenantOrderModel.fromJson(data['data']);
    } else {
      throw Exception('Failed to assign driver: ${response.statusCode}');
    }
  }

  /// Get order analytics
  Future<Map<String, dynamic>> getOrderAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    String? branchId,
  }) async {
    final queryParams = <String, dynamic>{};

    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String();
    }
    if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
    if (branchId != null) queryParams['branch_id'] = branchId;

    final response = await _apiService.get(
      '/api/v1/tenant/orders/analytics',
      queryParameters: queryParams,
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return data['data'];
    } else {
      throw Exception('Failed to load analytics: ${response.statusCode}');
    }
  }

  /// Get order statistics
  Future<Map<String, dynamic>> getOrderStatistics({
    DateTime? startDate,
    DateTime? endDate,
    String? branchId,
  }) async {
    final queryParams = <String, dynamic>{};

    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String();
    }
    if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
    if (branchId != null) queryParams['branch_id'] = branchId;

    final response = await _apiService.get(
      '/api/v1/tenant/orders/statistics',
      queryParameters: queryParams,
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return data['data'];
    } else {
      throw Exception('Failed to load statistics: ${response.statusCode}');
    }
  }

  /// Add tag to order
  Future<OrderTagModel> addOrderTag(
    String orderId,
    OrderTagType type,
    String value, {
    String? description,
  }) async {
    final response = await _apiService.post(
      '/api/v1/common/orders/$orderId/tags',
      data: {
        'tag_type': type.name,
        'tag_value': value,
        if (description != null) 'description': description,
      },
    );

    if (response.statusCode == 201 && response.data != null) {
      final data = response.data;
      return OrderTagModel.fromJson(data['data']);
    } else {
      throw Exception('Failed to add tag: ${response.statusCode}');
    }
  }

  /// Remove tag from order
  Future<void> removeOrderTag(String orderId, String tagId) async {
    final response = await _apiService.delete(
      '/api/v1/common/orders/$orderId/tags/$tagId',
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove tag: ${response.statusCode}');
    }
  }

  /// Get order tags
  Future<List<OrderTagModel>> getOrderTags(String orderId) async {
    final response = await _apiService.get(
      '/api/v1/common/orders/$orderId/tags',
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return (data['data'] as List)
          .map((tag) => OrderTagModel.fromJson(tag))
          .toList();
    } else {
      throw Exception('Failed to load tags: ${response.statusCode}');
    }
  }

  /// Get order status history
  Future<List<OrderStatusHistoryModel>> getOrderStatusHistory(
    String orderId,
  ) async {
    final response = await _apiService.get(
      '/api/v1/common/orders/$orderId/status-history',
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return (data['data'] as List)
          .map((history) => OrderStatusHistoryModel.fromJson(history))
          .toList();
    } else {
      throw Exception('Failed to load status history: ${response.statusCode}');
    }
  }

  /// Get order assignments
  Future<List<OrderAssignmentModel>> getOrderAssignments(String orderId) async {
    final response = await _apiService.get(
      '/api/v1/common/orders/$orderId/assignments',
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return (data['data'] as List)
          .map((assignment) => OrderAssignmentModel.fromJson(assignment))
          .toList();
    } else {
      throw Exception('Failed to load assignments: ${response.statusCode}');
    }
  }

  /// Get available drivers for assignment
  Future<List<Map<String, dynamic>>> getAvailableDrivers({
    String? branchId,
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    final queryParams = <String, dynamic>{};

    if (branchId != null) queryParams['branch_id'] = branchId;
    if (latitude != null) queryParams['latitude'] = latitude.toString();
    if (longitude != null) queryParams['longitude'] = longitude.toString();
    if (radius != null) queryParams['radius'] = radius.toString();

    final response = await _apiService.get(
      '/api/v1/tenant/drivers/available',
      queryParameters: queryParams,
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception(
        'Failed to load available drivers: ${response.statusCode}',
      );
    }
  }
}
