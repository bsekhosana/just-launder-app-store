import '../../../../core/services/api_service.dart';

class AnalyticsRemoteDataSource {
  final ApiService _apiService = ApiService();

  /// Get dashboard analytics
  Future<Map<String, dynamic>> getDashboardAnalytics({
    required String period,
    String? branchId,
  }) async {
    final response = await _apiService.get(
      '/api/v1/tenant/analytics/dashboard',
      queryParameters: {
        'period': period,
        if (branchId != null && branchId != 'all') 'branch_id': branchId,
      },
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to fetch analytics');
    }

    return response['data'];
  }

  /// Get revenue by branch
  Future<List<Map<String, dynamic>>> getRevenueByBranch({
    required String period,
  }) async {
    final response = await _apiService.get(
      '/api/v1/tenant/analytics/revenue-by-branch',
      queryParameters: {'period': period},
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to fetch revenue by branch');
    }

    return List<Map<String, dynamic>>.from(response['data']);
  }

  /// Get time series data
  Future<List<Map<String, dynamic>>> getTimeSeriesData({
    required String period,
  }) async {
    final response = await _apiService.get(
      '/api/v1/tenant/analytics/time-series',
      queryParameters: {'period': period},
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to fetch time series');
    }

    return List<Map<String, dynamic>>.from(response['data']);
  }

  /// Get top services
  Future<List<Map<String, dynamic>>> getTopServices({
    required String period,
    int limit = 10,
  }) async {
    final response = await _apiService.get(
      '/api/v1/tenant/analytics/top-services',
      queryParameters: {'period': period, 'limit': limit},
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to fetch top services');
    }

    return List<Map<String, dynamic>>.from(response['data']);
  }

  /// Get top customers
  Future<List<Map<String, dynamic>>> getTopCustomers({
    required String period,
    int limit = 10,
  }) async {
    final response = await _apiService.get(
      '/api/v1/tenant/analytics/top-customers',
      queryParameters: {'period': period, 'limit': limit},
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to fetch top customers');
    }

    return List<Map<String, dynamic>>.from(response['data']);
  }

  /// Get staff performance
  Future<List<Map<String, dynamic>>> getStaffPerformance({
    required String period,
  }) async {
    final response = await _apiService.get(
      '/api/v1/tenant/analytics/staff-performance',
      queryParameters: {'period': period},
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to fetch staff performance');
    }

    return List<Map<String, dynamic>>.from(response['data']);
  }
}

