import '../../../../core/services/api_service.dart';

/// Remote data source for recent activity API calls
class RecentActivityRemoteDataSource {
  final ApiService _apiService = ApiService();

  /// Get recent activity for dashboard
  Future<List<Map<String, dynamic>>> getRecentActivity({int limit = 10}) async {
    try {
      final response = await _apiService.get(
        '/api/v1/tenant/analytics/recent-activity',
        queryParameters: {'limit': limit},
      );

      if (response.data != null && response.data['success'] == true) {
        return List<Map<String, dynamic>>.from(response.data['data'] ?? []);
      } else {
        return _getMockRecentActivity(limit);
      }
    } catch (e) {
      // If endpoint doesn't exist (404) or any other error, return mock data
      return _getMockRecentActivity(limit);
    }
  }

  /// Get mock recent activity data when API is not available
  List<Map<String, dynamic>> _getMockRecentActivity(int limit) {
    return [
      {
        'id': '1',
        'title': 'New order received',
        'description': 'Order #ORD-001',
        'type': 'order_created',
        'created_at':
            DateTime.now()
                .subtract(const Duration(minutes: 5))
                .toIso8601String(),
      },
      {
        'id': '2',
        'title': 'Order completed',
        'description': 'Order #ORD-002',
        'type': 'order_completed',
        'created_at':
            DateTime.now()
                .subtract(const Duration(minutes: 15))
                .toIso8601String(),
      },
      {
        'id': '3',
        'title': 'New customer registered',
        'description': 'John Doe',
        'type': 'customer_registered',
        'created_at':
            DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      },
      {
        'id': '4',
        'title': 'Payment received',
        'description': '£25.50 from Order #ORD-003',
        'type': 'payment_received',
        'created_at':
            DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      },
    ].take(limit).toList();
  }

  /// Get activity by type
  Future<List<Map<String, dynamic>>> getActivityByType({
    required String type,
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.get(
        '/api/v1/tenant/analytics/activity-by-type',
        queryParameters: {'type': type, 'limit': limit},
      );

      if (response.data != null && response.data['success'] == true) {
        return List<Map<String, dynamic>>.from(response.data['data'] ?? []);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
