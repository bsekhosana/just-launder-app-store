import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'fcm_service.dart';
import 'notification_router.dart';

/// FCM Initializer
/// Helper class to initialize FCM with proper configuration
class FcmInitializer {
  /// Initialize FCM at app startup
  /// Call this in main() before runApp()
  static Future<void> initialize({
    required GlobalKey<NavigatorState> navigatorKey,
    required String apiBaseUrl,
    required Function(String) getAuthToken,
  }) async {
    try {
      // Initialize Firebase
      await Firebase.initializeApp();

      // Set navigator key for deep linking
      NotificationRouter.instance.navigatorKey = navigatorKey;

      // Initialize FCM Service
      await FcmService.instance.initialize(
        apiBaseUrl: apiBaseUrl,
        fcmTokenEndpoint: '/api/v1/tenant/fcm-token',
        getAuthToken: getAuthToken,
        onNotificationTap: (data) {
          // Route notification to appropriate screen
          NotificationRouter.instance.route(data);
        },
        onForegroundMessage: (message) {
          debugPrint('📥 Foreground message: ${message.notification?.title}');
          // You can show in-app notification here if needed
        },
        onTokenRefresh: (token) {
          debugPrint('🔄 Token refreshed: $token');
        },
      );

      debugPrint('✅ FCM initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to initialize FCM: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Clean up FCM on logout
  static Future<void> cleanup({
    required String apiBaseUrl,
    required Function(String) getAuthToken,
  }) async {
    try {
      await FcmService.instance.deleteToken(
        apiBaseUrl: apiBaseUrl,
        fcmTokenEndpoint: '/api/v1/tenant/fcm-token',
        getAuthToken: getAuthToken,
      );
      
      debugPrint('✅ FCM cleaned up successfully');
    } catch (e) {
      debugPrint('❌ Failed to cleanup FCM: $e');
    }
  }
}

