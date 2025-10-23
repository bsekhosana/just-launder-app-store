import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('🔔 Background message received: ${message.messageId}');
  debugPrint('Background message data: ${message.data}');
  
  // Handle the message
  await FcmService.instance._handleBackgroundMessage(message);
}

/// Generic FCM Service for handling push notifications
/// Features:
/// - Foreground and background notification handling
/// - Local notifications with custom sounds
/// - Deep linking and navigation
/// - Notification actions
/// - Token management with backend sync
/// - Permission handling
/// - Notification history
class FcmService {
  // Singleton instance
  static final FcmService instance = FcmService._internal();
  
  factory FcmService() => instance;
  
  FcmService._internal();

  // Firebase Messaging instance
  FirebaseMessaging? _firebaseMessaging;
  
  // Local notifications plugin
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Notification navigation callback
  Function(Map<String, dynamic>)? _onNotificationTap;
  
  // Notification received callback (foreground)
  Function(RemoteMessage)? _onForegroundMessage;

  // Token refresh callback
  Function(String)? _onTokenRefresh;

  // Stream controllers for notification events
  final StreamController<RemoteMessage> _messageStreamController =
      StreamController<RemoteMessage>.broadcast();
  
  final StreamController<NotificationResponse> _notificationResponseController =
      StreamController<NotificationResponse>.broadcast();

  // Getters for streams
  Stream<RemoteMessage> get onMessage => _messageStreamController.stream;
  Stream<NotificationResponse> get onNotificationResponse =>
      _notificationResponseController.stream;

  // Notification channel IDs
  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';
  static const String _channelDescription =
      'This channel is used for important notifications.';

  /// Initialize FCM Service
  /// Should be called at app startup
  Future<void> initialize({
    required String apiBaseUrl,
    required String fcmTokenEndpoint,
    required Function(String) getAuthToken,
    Function(Map<String, dynamic>)? onNotificationTap,
    Function(RemoteMessage)? onForegroundMessage,
    Function(String)? onTokenRefresh,
  }) async {
    try {
      debugPrint('🚀 Initializing FCM Service...');
      
      _firebaseMessaging = FirebaseMessaging.instance;
      _onNotificationTap = onNotificationTap;
      _onForegroundMessage = onForegroundMessage;
      _onTokenRefresh = onTokenRefresh;

    // Initialize local notifications
    await _initializeLocalNotifications();

      // Request permissions
      await _requestPermissions();

      // Get FCM token and save to backend
      await _getFCMToken(apiBaseUrl, fcmTokenEndpoint, getAuthToken);

    // Set up message handlers
    _setupMessageHandlers();

      // Handle token refresh
      _setupTokenRefreshHandler(apiBaseUrl, fcmTokenEndpoint, getAuthToken);

      // Handle notification tap when app is terminated
      _handleInitialMessage();

      debugPrint('✅ FCM Service initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to initialize FCM Service: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidInitializationSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    
    const darwinInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _onLocalNotificationTap,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      final androidPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        ),
      );
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    if (_firebaseMessaging == null) return;

    try {
      final settings = await _firebaseMessaging!.requestPermission(
      alert: true,
        announcement: false,
      badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      sound: true,
      );

      debugPrint('📱 Notification permission status: ${settings.authorizationStatus}');
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('✅ User granted notification permissions');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        debugPrint('✅ User granted provisional notification permissions');
      } else {
        debugPrint('⚠️ User declined or has not accepted notification permissions');
      }
    } catch (e) {
      debugPrint('❌ Error requesting notification permissions: $e');
    }
  }

  /// Get FCM token and save to backend
  Future<void> _getFCMToken(
    String apiBaseUrl,
    String fcmTokenEndpoint,
    Function(String) getAuthToken,
  ) async {
    try {
      final token = await _firebaseMessaging?.getToken();
      
      if (token != null) {
        debugPrint('📱 FCM Token: $token');
        
        // Save token to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', token);
        
        // Save token to backend
        await _saveFCMTokenToBackend(
          token,
          apiBaseUrl,
          fcmTokenEndpoint,
          getAuthToken,
        );
      } else {
        debugPrint('⚠️ FCM Token is null');
      }
    } catch (e) {
      debugPrint('❌ Error getting FCM token: $e');
    }
  }

  /// Save FCM token to backend
  Future<void> _saveFCMTokenToBackend(
    String token,
    String apiBaseUrl,
    String fcmTokenEndpoint,
    Function(String) getAuthToken,
  ) async {
    try {
      final authToken = getAuthToken('');
      
      if (authToken.isEmpty) {
        debugPrint('⚠️ Auth token is empty, skipping FCM token sync');
        return;
      }

      final url = Uri.parse('$apiBaseUrl$fcmTokenEndpoint');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ FCM token saved to backend successfully');
      } else {
        debugPrint('⚠️ Failed to save FCM token to backend: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error saving FCM token to backend: $e');
    }
  }

  /// Set up message handlers
  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('🔔 Foreground message received: ${message.messageId}');
      debugPrint('Message data: ${message.data}');
      debugPrint('Message notification: ${message.notification?.title}');

      // Add to stream
      _messageStreamController.add(message);

      // Call custom handler if provided
      _onForegroundMessage?.call(message);

      // Show local notification
      _showLocalNotification(message);
    });

    // Handle background messages (app in background but not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🔔 Background message opened: ${message.messageId}');
      _handleNotificationTap(message.data);
    });
  }

  /// Handle background messages
  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    debugPrint('📥 Handling background message: ${message.messageId}');
    
    // Save to notification history
    await _saveNotificationToHistory(message);
  }

  /// Set up token refresh handler
  void _setupTokenRefreshHandler(
    String apiBaseUrl,
    String fcmTokenEndpoint,
    Function(String) getAuthToken,
  ) {
    _firebaseMessaging?.onTokenRefresh.listen((String newToken) {
      debugPrint('🔄 FCM Token refreshed: $newToken');
      
      // Save to backend
      _saveFCMTokenToBackend(newToken, apiBaseUrl, fcmTokenEndpoint, getAuthToken);
      
      // Call custom handler if provided
      _onTokenRefresh?.call(newToken);
    });
  }

  /// Handle initial message (app opened from terminated state via notification)
  void _handleInitialMessage() {
    _firebaseMessaging?.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('🔔 App opened from terminated state via notification');
        _handleNotificationTap(message.data);
      }
    });
  }

  /// Show local notification for foreground messages
  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
    final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null) {
        await _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              _channelName,
              channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
              icon: android?.smallIcon ?? '@mipmap/launcher_icon',
              playSound: true,
              enableVibration: true,
      showWhen: true,
            ),
            iOS: const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    } catch (e) {
      debugPrint('❌ Error showing local notification: $e');
    }
  }

  /// Handle local notification tap
  @pragma('vm:entry-point')
  static void _onLocalNotificationTap(NotificationResponse response) {
    debugPrint('🔔 Local notification tapped');
    
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        instance._handleNotificationTap(data);
        instance._notificationResponseController.add(response);
      } catch (e) {
        debugPrint('❌ Error parsing notification payload: $e');
      }
    }
  }

  /// Handle notification tap - performs navigation/deep linking
  void _handleNotificationTap(Map<String, dynamic> data) {
    debugPrint('👆 Notification tapped with data: $data');
    
    // Call custom handler if provided
    _onNotificationTap?.call(data);
  }

  /// Save notification to history for later retrieval
  Future<void> _saveNotificationToHistory(RemoteMessage message) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList('notification_history') ?? [];
      
      final notificationData = {
        'id': message.messageId,
        'title': message.notification?.title,
        'body': message.notification?.body,
        'data': message.data,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      history.add(jsonEncode(notificationData));
      
      // Keep only last 50 notifications
      if (history.length > 50) {
        history.removeRange(0, history.length - 50);
      }
      
      await prefs.setStringList('notification_history', history);
    } catch (e) {
      debugPrint('❌ Error saving notification to history: $e');
    }
  }

  /// Get notification history
  Future<List<Map<String, dynamic>>> getNotificationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList('notification_history') ?? [];
      
      return history
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList()
          .reversed
          .toList();
    } catch (e) {
      debugPrint('❌ Error getting notification history: $e');
      return [];
    }
  }

  /// Clear notification history
  Future<void> clearNotificationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('notification_history');
    } catch (e) {
      debugPrint('❌ Error clearing notification history: $e');
    }
  }

  /// Delete FCM token from backend and local storage
  Future<void> deleteToken({
    required String apiBaseUrl,
    required String fcmTokenEndpoint,
    required Function(String) getAuthToken,
  }) async {
    try {
      final authToken = getAuthToken('');
      
      if (authToken.isNotEmpty) {
        final url = Uri.parse('$apiBaseUrl$fcmTokenEndpoint');
        
        await http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        );
      }

      // Delete from Firebase
      await _firebaseMessaging?.deleteToken();
      
      // Delete from local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('fcm_token');
      
      debugPrint('✅ FCM token deleted successfully');
    } catch (e) {
      debugPrint('❌ Error deleting FCM token: $e');
    }
  }

  /// Get current FCM token
  Future<String?> getToken() async {
    return await _firebaseMessaging?.getToken();
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging?.subscribeToTopic(topic);
    debugPrint('✅ Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('❌ Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging?.unsubscribeFromTopic(topic);
    debugPrint('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('❌ Error unsubscribing from topic: $e');
    }
  }

  /// Dispose streams
  void dispose() {
    _messageStreamController.close();
    _notificationResponseController.close();
  }
}
