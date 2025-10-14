import '../../domain/models/dashboard_analytics_model.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../datasources/analytics_remote_data_source.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;

  AnalyticsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DashboardAnalyticsModel> getDashboardAnalytics({
    required String period,
    String? branchId,
  }) async {
    try {
      final data = await remoteDataSource.getDashboardAnalytics(
        period: period,
        branchId: branchId,
      );
      return DashboardAnalyticsModel.fromJson(data);
    } catch (e) {
      print('Repository: Failed to get dashboard analytics: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRevenueByBranch({
    required String period,
  }) async {
    try {
      return await remoteDataSource.getRevenueByBranch(period: period);
    } catch (e) {
      print('Repository: Failed to get revenue by branch: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTimeSeriesData({
    required String period,
  }) async {
    try {
      return await remoteDataSource.getTimeSeriesData(period: period);
    } catch (e) {
      print('Repository: Failed to get time series data: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTopServices({
    required String period,
    int limit = 10,
  }) async {
    try {
      return await remoteDataSource.getTopServices(
        period: period,
        limit: limit,
      );
    } catch (e) {
      print('Repository: Failed to get top services: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTopCustomers({
    required String period,
    int limit = 10,
  }) async {
    try {
      return await remoteDataSource.getTopCustomers(
        period: period,
        limit: limit,
      );
    } catch (e) {
      print('Repository: Failed to get top customers: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getStaffPerformance({
    required String period,
  }) async {
    try {
      return await remoteDataSource.getStaffPerformance(period: period);
    } catch (e) {
      print('Repository: Failed to get staff performance: $e');
      rethrow;
    }
  }
}

