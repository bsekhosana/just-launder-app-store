# 🔔 FCM Implementation Guide

## Overview
This guide explains how to implement Firebase Cloud Messaging (FCM) for push notifications in the Just Launder Tenant App.

## Features Implemented
- ✅ Foreground and background notification handling
- ✅ Local notifications with custom sounds
- ✅ Deep linking and navigation
- ✅ Notification actions
- ✅ Token management with backend sync
- ✅ Permission handling
- ✅ Notification history

## Prerequisites

### 1. Add Firebase to your Flutter project
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Configure Firebase for Flutter
flutterfire configure
```

### 2. Add Dependencies to `pubspec.yaml`
```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.9
  flutter_local_notifications: ^16.3.0
  shared_preferences: ^2.2.2
  http: ^1.1.2
```

### 3. Update Android Configuration

#### `android/app/build.gradle.kts`
Already updated with new package name: `just.launder.tenant`

#### `android/app/src/main/AndroidManifest.xml`
Add these permissions inside `<manifest>` tag:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

Add inside `<application>` tag:
```xml
<meta-data
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="high_importance_channel" />

<meta-data
    android:name="com.google.firebase.messaging.default_notification_icon"
    android:resource="@mipmap/launcher_icon" />

<meta-data
    android:name="com.google.firebase.messaging.default_notification_color"
    android:resource="@color/notification_color" />
```

#### `android/app/src/main/res/values/colors.xml`
Create this file:
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="notification_color">#00BCD4</color>
</resources>
```

### 4. Update iOS Configuration (When Ready)

#### `ios/Runner/Info.plist`
Add these keys:
```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

## Implementation Steps

### Step 1: Update `main.dart`

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/services/fcm_service.dart';
import 'core/services/fcm_initializer.dart';
import 'firebase_options.dart';

// Background message handler - MUST be top-level
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FcmService.instance._handleBackgroundMessage(message);
}

// Global navigator key for deep linking
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // Initialize FCM (will be called after user logs in)
  // See Step 2 for implementation
  
  runApp(MyApp(navigatorKey: navigatorKey));
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  
  const MyApp({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Important for deep linking
      title: 'Just Launder',
      // ... rest of your app configuration
    );
  }
}
```

### Step 2: Initialize FCM After Login

In your login success handler or app initialization (after user is authenticated):

```dart
import 'core/services/fcm_initializer.dart';
import 'core/services/auth_service.dart'; // Your auth service

// After successful login
await FcmInitializer.initialize(
  navigatorKey: navigatorKey,
  apiBaseUrl: 'https://justlaunder.co.uk',
  getAuthToken: (context) {
    // Return the user's auth token
    return AuthService.instance.token ?? '';
  },
);
```

### Step 3: Update Notification Router

Edit `lib/core/services/notification_router.dart` to match your app's navigation:

```dart
Future<void> _navigateToOrderDetails(
  BuildContext context,
  Map<String, dynamic> data,
) async {
  final orderSlug = data['order_slug'] as String?;
  
  if (orderSlug == null) return;

  // Replace with your actual navigation
  Navigator.of(context).pushNamed(
    '/order-details',
    arguments: {'orderSlug': orderSlug},
  );
}

// Update other navigation methods similarly
```

### Step 4: Handle Logout

When user logs out, clean up FCM:

```dart
import 'core/services/fcm_initializer.dart';

// On logout
await FcmInitializer.cleanup(
  apiBaseUrl: 'https://justlaunder.co.uk',
  getAuthToken: (context) => AuthService.instance.token ?? '',
);
```

### Step 5: Listen to Notification Events (Optional)

```dart
import 'core/services/fcm_service.dart';

// Listen to foreground messages
FcmService.instance.onMessage.listen((message) {
  print('Received message: ${message.notification?.title}');
  // Show in-app notification or update UI
});

// Listen to notification taps
FcmService.instance.onNotificationResponse.listen((response) {
  print('Notification tapped: ${response.payload}');
});
```

## Backend API Endpoints

The FCM service expects these endpoints:

### Save FCM Token
```http
POST /api/v1/tenant/fcm-token
Authorization: Bearer {token}
Content-Type: application/json

{
  "token": "fcm_device_token"
}
```

### Delete FCM Token
```http
DELETE /api/v1/tenant/fcm-token
Authorization: Bearer {token}
```

## Notification Payload Structure

Backend should send notifications with this structure:

```json
{
  "notification": {
    "title": "Order Approved",
    "body": "Your order #ORD-123 has been approved"
  },
  "data": {
    "type": "order_approved",
    "priority": "high",
    "order_id": "123",
    "order_slug": "ORD-123",
    "url": "https://justlaunder.co.uk/orders/ORD-123",
    "click_action": "FLUTTER_NOTIFICATION_CLICK"
  }
}
```

### Supported Notification Types
- `order_approved`
- `order_rejected`
- `order_status_changed`
- `order_assigned`
- `order_awaiting_approval`
- `driver_assigned`
- `order_picked_up`
- `order_delivered`
- `wallet_refund`
- `wallet_withdrawal`
- `new_promotion`
- `profile_update`
- `general`

## Testing

### Test FCM Token Registration
```dart
final token = await FcmService.instance.getToken();
print('FCM Token: $token');
```

### Test Notification History
```dart
final history = await FcmService.instance.getNotificationHistory();
print('Notification count: ${history.length}');
```

### Test Topic Subscription
```dart
await FcmService.instance.subscribeToTopic('all_customers');
await FcmService.instance.unsubscribeFromTopic('all_customers');
```

## Troubleshooting

### Notifications not showing on Android
1. Check notification permissions are granted
2. Verify notification channel is created
3. Check FCM token is saved to backend
4. Test with Firebase Console test message

### Notifications not showing on iOS
1. Enable Push Notifications capability in Xcode
2. Configure APNs certificate in Firebase Console
3. Test on physical device (simulator doesn't support push)

### Deep linking not working
1. Verify `navigatorKey` is set correctly
2. Check notification data contains correct `type` field
3. Update `NotificationRouter` with your route names

### Token not syncing with backend
1. Check API endpoint is correct
2. Verify auth token is valid
3. Check network connectivity
4. Review backend logs for errors

## Advanced Features

### Custom Notification Sounds
Place sound files in:
- Android: `android/app/src/main/res/raw/notification.mp3`
- iOS: Add to Xcode project

### Notification Actions
```dart
// Show notification with actions
await _localNotifications.show(
  0,
  'Order Ready',
  'Your order is ready for pickup',
  NotificationDetails(
    android: AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      actions: [
        AndroidNotificationAction('view', 'View Order'),
        AndroidNotificationAction('track', 'Track'),
      ],
    ),
  ),
);
```

### Badge Count (iOS)
```dart
await FirebaseMessaging.instance.setApplicationBadge(5);
```

## Notes

- FCM initialization happens **after** user login
- Token is automatically synced with backend
- Notifications are stored in local history (last 50)
- Background handler must be top-level function
- Deep linking requires `navigatorKey` to be set

## Support

For issues or questions:
1. Check Firebase Console for device registration
2. Review backend notification logs
3. Test with Firebase Cloud Messaging test tool
4. Check Flutter logs for error messages

