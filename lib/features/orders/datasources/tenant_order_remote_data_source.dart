import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tenant_order_model.dart';

/// Remote data source for tenant order operations
class TenantOrderRemoteDataSource {
  final String baseUrl;
  final http.Client client;

  TenantOrderRemoteDataSource({required this.baseUrl, required this.client});

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
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (status != null) queryParams['status'] = status;
    if (priority != null) queryParams['priority'] = priority;
    if (paymentStatus != null) queryParams['payment_status'] = paymentStatus;
    if (startDate != null)
      queryParams['start_date'] = startDate.toIso8601String();
    if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

    final uri = Uri.parse(
      '$baseUrl/api/v1/tenant/orders',
    ).replace(queryParameters: queryParams);

    final response = await client.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final orders =
          (data['data'] as List)
              .map((order) => TenantOrderModel.fromJson(order))
              .toList();
      return orders;
    } else {
      throw Exception('Failed to load orders: ${response.statusCode}');
    }
  }

  /// Get order details by ID
  Future<TenantOrderModel> getOrderDetails(String orderId) async {
    final uri = Uri.parse('$baseUrl/api/v1/tenant/orders/$orderId');

    final response = await client.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
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
    final uri = Uri.parse('$baseUrl/api/v1/tenant/orders/$orderId/status');

    final response = await client.put(
      uri,
      headers: await _getHeaders(),
      body: json.encode({'status': status.name, 'notes': notes}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
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
    final uri = Uri.parse(
      '$baseUrl/api/v1/tenant/orders/$orderId/assign-driver',
    );

    final response = await client.post(
      uri,
      headers: await _getHeaders(),
      body: json.encode({'driver_id': driverId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
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
    final queryParams = <String, String>{};

    if (startDate != null)
      queryParams['start_date'] = startDate.toIso8601String();
    if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
    if (branchId != null) queryParams['branch_id'] = branchId;

    final uri = Uri.parse(
      '$baseUrl/api/v1/tenant/orders/analytics',
    ).replace(queryParameters: queryParams);

    final response = await client.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
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
    final queryParams = <String, String>{};

    if (startDate != null)
      queryParams['start_date'] = startDate.toIso8601String();
    if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
    if (branchId != null) queryParams['branch_id'] = branchId;

    final uri = Uri.parse(
      '$baseUrl/api/v1/tenant/orders/statistics',
    ).replace(queryParameters: queryParams);

    final response = await client.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
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
    final uri = Uri.parse('$baseUrl/api/v1/common/orders/$orderId/tags');

    final response = await client.post(
      uri,
      headers: await _getHeaders(),
      body: json.encode({
        'tag_type': type.name,
        'tag_value': value,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return OrderTagModel.fromJson(data['data']);
    } else {
      throw Exception('Failed to add tag: ${response.statusCode}');
    }
  }

  /// Remove tag from order
  Future<void> removeOrderTag(String orderId, String tagId) async {
    final uri = Uri.parse('$baseUrl/api/v1/common/orders/$orderId/tags/$tagId');

    final response = await client.delete(uri, headers: await _getHeaders());

    if (response.statusCode != 200) {
      throw Exception('Failed to remove tag: ${response.statusCode}');
    }
  }

  /// Get order tags
  Future<List<OrderTagModel>> getOrderTags(String orderId) async {
    final uri = Uri.parse('$baseUrl/api/v1/common/orders/$orderId/tags');

    final response = await client.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
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
    final uri = Uri.parse(
      '$baseUrl/api/v1/common/orders/$orderId/status-history',
    );

    final response = await client.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((history) => OrderStatusHistoryModel.fromJson(history))
          .toList();
    } else {
      throw Exception('Failed to load status history: ${response.statusCode}');
    }
  }

  /// Get order assignments
  Future<List<OrderAssignmentModel>> getOrderAssignments(String orderId) async {
    final uri = Uri.parse('$baseUrl/api/v1/common/orders/$orderId/assignments');

    final response = await client.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
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
    final queryParams = <String, String>{};

    if (branchId != null) queryParams['branch_id'] = branchId;
    if (latitude != null) queryParams['latitude'] = latitude.toString();
    if (longitude != null) queryParams['longitude'] = longitude.toString();
    if (radius != null) queryParams['radius'] = radius.toString();

    final uri = Uri.parse(
      '$baseUrl/api/v1/tenant/drivers/available',
    ).replace(queryParameters: queryParams);

    final response = await client.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception(
        'Failed to load available drivers: ${response.statusCode}',
      );
    }
  }

  /// Get headers for API requests
  Future<Map<String, String>> _getHeaders() async {
    // TODO: Get token from secure storage
    final token = 'your_jwt_token_here';

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'X-App-Type': 'laundrette', // Mandatory app type for all API calls
    };
  }
}
