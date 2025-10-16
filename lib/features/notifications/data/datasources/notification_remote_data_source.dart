import '../../../../core/services/api_service.dart';

/// Remote data source for notifications API calls
class NotificationRemoteDataSource {
  final ApiService _apiService;

  NotificationRemoteDataSource({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get all notifications for tenant
  Future<List<Map<String, dynamic>>> getNotifications({
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit.toString();
    if (offset != null) queryParams['offset'] = offset.toString();

    final response = await _apiService.get(
      '/api/v1/tenant/notifications',
      queryParameters: queryParams,
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return List<Map<String, dynamic>>.from(data['data'] as List);
    } else {
      throw Exception('Failed to load notifications: ${response.statusCode}');
    }
  }

  /// Mark a notification as read
  Future<bool> markAsRead(String notificationId) async {
    final response = await _apiService.put(
      '/api/v1/tenant/notifications/$notificationId/read',
    );

    return response.statusCode == 200;
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead() async {
    final response = await _apiService.post(
      '/api/v1/tenant/notifications/mark-all-read',
    );

    return response.statusCode == 200;
  }

  /// Register FCM token
  Future<bool> registerFcmToken(String token) async {
    final response = await _apiService.post(
      '/api/v1/tenant/fcm-token',
      data: {'fcm_token': token, 'device_type': 'mobile'},
    );

    return response.statusCode == 200;
  }

  /// Unregister FCM token
  Future<bool> unregisterFcmToken(String token) async {
    final response = await _apiService.delete(
      '/api/v1/tenant/fcm-token',
      data: {'fcm_token': token},
    );

    return response.statusCode == 200;
  }
}

