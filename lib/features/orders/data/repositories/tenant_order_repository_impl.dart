import '../../domain/repositories/tenant_order_repository.dart';
import '../models/tenant_order_model.dart';
import '../datasources/tenant_order_remote_data_source.dart';

/// Implementation of tenant order repository
class TenantOrderRepositoryImpl implements TenantOrderRepository {
  final TenantOrderRemoteDataSource remoteDataSource;

  TenantOrderRepositoryImpl({required this.remoteDataSource});

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
    return await remoteDataSource.getOrders(
      status: status,
      priority: priority,
      paymentStatus: paymentStatus,
      startDate: startDate,
      endDate: endDate,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<TenantOrderModel> getOrderDetails(String orderId) async {
    return await remoteDataSource.getOrderDetails(orderId);
  }

  @override
  Future<TenantOrderModel> updateOrderStatus(
    String orderId,
    TenantOrderStatus status, {
    String? notes,
  }) async {
    return await remoteDataSource.updateOrderStatus(
      orderId,
      status,
      notes: notes,
    );
  }

  @override
  Future<TenantOrderModel> assignToDriver(
    String orderId,
    String driverId,
  ) async {
    return await remoteDataSource.assignToDriver(orderId, driverId);
  }

  @override
  Future<Map<String, dynamic>> getOrderAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    String? branchId,
  }) async {
    return await remoteDataSource.getOrderAnalytics(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
    );
  }

  @override
  Future<Map<String, dynamic>> getOrderStatistics({
    DateTime? startDate,
    DateTime? endDate,
    String? branchId,
  }) async {
    return await remoteDataSource.getOrderStatistics(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
    );
  }

  @override
  Future<OrderTagModel> addOrderTag(
    String orderId,
    OrderTagType type,
    String value, {
    String? description,
  }) async {
    return await remoteDataSource.addOrderTag(
      orderId,
      type,
      value,
      description: description,
    );
  }

  @override
  Future<void> removeOrderTag(String orderId, String tagId) async {
    return await remoteDataSource.removeOrderTag(orderId, tagId);
  }

  @override
  Future<List<OrderTagModel>> getOrderTags(String orderId) async {
    return await remoteDataSource.getOrderTags(orderId);
  }

  @override
  Future<List<OrderStatusHistoryModel>> getOrderStatusHistory(
    String orderId,
  ) async {
    return await remoteDataSource.getOrderStatusHistory(orderId);
  }

  @override
  Future<List<OrderAssignmentModel>> getOrderAssignments(String orderId) async {
    return await remoteDataSource.getOrderAssignments(orderId);
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailableDrivers({
    String? branchId,
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    return await remoteDataSource.getAvailableDrivers(
      branchId: branchId,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );
  }
}
