import 'package:http/http.dart' as http;
import '../../domain/models/tenant_order_model.dart';
import '../../domain/repositories/tenant_order_repository.dart';
import '../../datasources/tenant_order_remote_data_source.dart';
import '../../../auth/data/datasources/tenant_remote_data_source.dart';

class TenantOrderRepositoryImpl implements TenantOrderRepository {
  late final TenantOrderRemoteDataSource _remoteDataSource;

  TenantOrderRepositoryImpl() {
    _remoteDataSource = TenantOrderRemoteDataSource(
      baseUrl: TenantRemoteDataSource.baseUrl.replaceAll('/api/v1', ''),
      client: http.Client(),
    );
  }

  @override
  Future<List<TenantOrderModel>> getOrders({
    String? status,
    String? priority,
    String? paymentStatus,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await _remoteDataSource.getOrders(
        status: status,
        priority: priority,
        paymentStatus: paymentStatus,
        startDate: startDate,
        endDate: endDate,
        page: page,
        limit: limit,
      );
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  @override
  Future<TenantOrderModel> getOrderDetails(String orderId) async {
    try {
      return await _remoteDataSource.getOrderDetails(orderId);
    } catch (e) {
      throw Exception('Failed to load order details: $e');
    }
  }

  @override
  Future<TenantOrderModel> updateOrderStatus(
    String orderId,
    TenantOrderStatus status, {
    String? notes,
  }) async {
    try {
      return await _remoteDataSource.updateOrderStatus(
        orderId,
        status,
        notes: notes,
      );
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  @override
  Future<TenantOrderModel> assignToDriver(
    String orderId,
    String driverId,
  ) async {
    try {
      return await _remoteDataSource.assignToDriver(orderId, driverId);
    } catch (e) {
      throw Exception('Failed to assign driver: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getOrderAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    String? branchId,
  }) async {
    try {
      return await _remoteDataSource.getOrderAnalytics(
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
      );
    } catch (e) {
      throw Exception('Failed to load order analytics: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getOrderStatistics({
    DateTime? startDate,
    DateTime? endDate,
    String? branchId,
  }) async {
    try {
      return await _remoteDataSource.getOrderStatistics(
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
      );
    } catch (e) {
      throw Exception('Failed to load order statistics: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailableDrivers({
    String? branchId,
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    try {
      return await _remoteDataSource.getAvailableDrivers(
        branchId: branchId,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );
    } catch (e) {
      throw Exception('Failed to load available drivers: $e');
    }
  }

  @override
  Future<OrderTagModel> addOrderTag(
    String orderId,
    OrderTagType type,
    String value, {
    String? description,
  }) async {
    try {
      return await _remoteDataSource.addOrderTag(
        orderId,
        type,
        value,
        description: description,
      );
    } catch (e) {
      throw Exception('Failed to add order tag: $e');
    }
  }

  @override
  Future<void> removeOrderTag(String orderId, String tagId) async {
    try {
      await _remoteDataSource.removeOrderTag(orderId, tagId);
    } catch (e) {
      throw Exception('Failed to remove order tag: $e');
    }
  }

  @override
  Future<List<OrderTagModel>> getOrderTags(String orderId) async {
    try {
      return await _remoteDataSource.getOrderTags(orderId);
    } catch (e) {
      throw Exception('Failed to load order tags: $e');
    }
  }

  @override
  Future<List<OrderStatusHistoryModel>> getOrderStatusHistory(
    String orderId,
  ) async {
    try {
      return await _remoteDataSource.getOrderStatusHistory(orderId);
    } catch (e) {
      throw Exception('Failed to load order status history: $e');
    }
  }

  @override
  Future<List<OrderAssignmentModel>> getOrderAssignments(String orderId) async {
    try {
      return await _remoteDataSource.getOrderAssignments(orderId);
    } catch (e) {
      throw Exception('Failed to load order assignments: $e');
    }
  }
}
