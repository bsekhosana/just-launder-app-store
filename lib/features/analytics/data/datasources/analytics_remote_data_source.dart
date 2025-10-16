import '../../../../core/services/api_service.dart';

class AnalyticsRemoteDataSource {
  final ApiService _apiService = ApiService();

  /// Get dashboard analytics
  Future<Map<String, dynamic>> getDashboardAnalytics({
    required String period,
    String? branchId,
  }) async {
    try {
      final response = await _apiService.get(
        '/api/v1/tenant/analytics/dashboard',
        queryParameters: {
          'period': period,
          if (branchId != null && branchId != 'all') 'branch_id': branchId,
        },
      );

      if (response.data != null && response.data['success'] == true) {
        // Handle nested data structure: { "success": true, "data": {...} }
        final responseData = response.data['data'];
        if (responseData is Map<String, dynamic>) {
          return responseData;
        } else {
          return _getDefaultDashboardData();
        }
      } else {
        // Return default data if API fails
        return _getDefaultDashboardData();
      }
    } catch (e) {
      // Return default data if API fails
      return _getDefaultDashboardData();
    }
  }

  /// Get default dashboard data when API fails
  Map<String, dynamic> _getDefaultDashboardData() {
    return {
      'total_revenue': 0.0,
      'total_orders': 0,
      'completed_orders': 0,
      'pending_orders': 0,
      'cancelled_orders': 0,
      'average_order_value': 0.0,
      'customer_satisfaction': 0.0,
      'total_customers': 0,
      'new_customers': 0,
      'delivery_time': 0.0,
      'total_deliveries': 0,
      'staff_efficiency': 0.0,
    };
  }

  /// Get revenue by branch
  Future<List<Map<String, dynamic>>> getRevenueByBranch({
    required String period,
  }) async {
    try {
      final response = await _apiService.get(
        '/api/v1/tenant/analytics/revenue-by-branch',
        queryParameters: {'period': period},
      );

      if (response.data != null && response.data['success'] == true) {
        // Handle nested data structure: { "success": true, "data": [...] }
        final responseData = response.data['data'];
        if (responseData is List) {
          return List<Map<String, dynamic>>.from(responseData);
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// Get time series data
  Future<List<Map<String, dynamic>>> getTimeSeriesData({
    required String period,
  }) async {
    try {
      final response = await _apiService.get(
        '/api/v1/tenant/analytics/time-series',
        queryParameters: {'period': period},
      );

      if (response.data != null && response.data['success'] == true) {
        // Handle nested data structure: { "success": true, "data": [...] }
        final responseData = response.data['data'];
        if (responseData is List) {
          return List<Map<String, dynamic>>.from(responseData);
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// Get top services
  Future<List<Map<String, dynamic>>> getTopServices({
    required String period,
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.get(
        '/api/v1/tenant/analytics/top-services',
        queryParameters: {'period': period, 'limit': limit},
      );

      if (response.data != null && response.data['success'] == true) {
        // Handle nested data structure: { "success": true, "data": [...] }
        final responseData = response.data['data'];
        if (responseData is List) {
          return List<Map<String, dynamic>>.from(responseData);
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// Get top customers
  Future<List<Map<String, dynamic>>> getTopCustomers({
    required String period,
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.get(
        '/api/v1/tenant/analytics/top-customers',
        queryParameters: {'period': period, 'limit': limit},
      );

      if (response.data != null && response.data['success'] == true) {
        // Handle nested data structure: { "success": true, "data": [...] }
        final responseData = response.data['data'];
        if (responseData is List) {
          return List<Map<String, dynamic>>.from(responseData);
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// Get staff performance
  Future<List<Map<String, dynamic>>> getStaffPerformance({
    required String period,
  }) async {
    try {
      final response = await _apiService.get(
        '/api/v1/tenant/analytics/staff-performance',
        queryParameters: {'period': period},
      );

      if (response.data != null && response.data['success'] == true) {
        // Handle nested data structure: { "success": true, "data": [...] }
        final responseData = response.data['data'];
        if (responseData is List) {
          return List<Map<String, dynamic>>.from(responseData);
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
