import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../core/services/fcm_service.dart';
import '../../../core/services/api_service.dart';

/// Provider for managing push notifications
class NotificationProvider extends ChangeNotifier {
  final FCMService _fcmService = FCMService();
  final ApiService _apiService = ApiService();

  List<RemoteMessage> _notifications = [];
  int _unreadCount = 0;
  bool _isInitialized = false;
  bool _permissionGranted = false;

  List<RemoteMessage> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isInitialized => _isInitialized;
  bool get permissionGranted => _permissionGranted;
  String? get fcmToken => _fcmService.token;

  /// Initialize notification service
  Future<void> initialize() async {
    try {
      // ApiService auto-initializes, no need to call initialize()

      await _fcmService.initialize(
        onMessage: _handleMessage,
        onTokenRefresh: _handleTokenRefresh,
      );

      _isInitialized = true;
      _permissionGranted = _fcmService.token != null;

      // Send token to backend
      if (_fcmService.token != null) {
        await _sendTokenToBackend(_fcmService.token!);
      }

      debugPrint('✅ NotificationProvider initialized');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to initialize notifications: $e');
    }
  }

  /// Handle incoming message
  void _handleMessage(RemoteMessage message) {
    _notifications.insert(0, message);
    _unreadCount++;
    notifyListeners();

    debugPrint('📩 New notification: ${message.notification?.title}');
  }

  /// Handle token refresh
  Future<void> _handleTokenRefresh(String newToken) async {
    await _sendTokenToBackend(newToken);
    debugPrint('🔄 Token refreshed and sent to backend');
  }

  /// Send FCM token to backend
  Future<void> _sendTokenToBackend(String token) async {
    try {
      await _apiService.post(
        '/api/v1/tenant/fcm-token',
        data: {'fcm_token': token},
      );
      debugPrint('✅ FCM token sent to backend');
    } catch (e) {
      debugPrint('❌ Failed to send FCM token: $e');
    }
  }

  /// Request notification permission
  Future<bool> requestPermission() async {
    _permissionGranted = await _fcmService.requestPermission();
    notifyListeners();
    return _permissionGranted;
  }

  /// Mark notification as read
  void markAsRead(int index) {
    if (index >= 0 && index < _notifications.length) {
      _unreadCount = (_unreadCount - 1).clamp(0, _notifications.length);
      notifyListeners();
    }
  }

  /// Mark all as read
  void markAllAsRead() {
    _unreadCount = 0;
    notifyListeners();
  }

  /// Clear all notifications
  void clearAll() {
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _fcmService.subscribeToTopic(topic);
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcmService.unsubscribeFromTopic(topic);
  }

  /// Clear token on logout
  Future<void> clearToken() async {
    try {
      await _apiService.delete('/api/v1/tenant/fcm-token');
      await _fcmService.deleteToken();
      _notifications.clear();
      _unreadCount = 0;
      _permissionGranted = false;
      notifyListeners();
      debugPrint('✅ FCM token cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear FCM token: $e');
    }
  }
}
