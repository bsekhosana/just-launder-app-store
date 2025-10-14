import '../models/dashboard_analytics_model.dart';

abstract class AnalyticsRepository {
  /// Get dashboard analytics summary
  Future<DashboardAnalyticsModel> getDashboardAnalytics({
    required String period,
    String? branchId,
  });

  /// Get revenue breakdown by branch
  Future<List<Map<String, dynamic>>> getRevenueByBranch({
    required String period,
  });

  /// Get time series data
  Future<List<Map<String, dynamic>>> getTimeSeriesData({
    required String period,
  });

  /// Get top services
  Future<List<Map<String, dynamic>>> getTopServices({
    required String period,
    int limit = 10,
  });

  /// Get top customers
  Future<List<Map<String, dynamic>>> getTopCustomers({
    required String period,
    int limit = 10,
  });

  /// Get staff performance
  Future<List<Map<String, dynamic>>> getStaffPerformance({
    required String period,
  });
}

