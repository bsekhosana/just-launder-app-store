import 'package:flutter/material.dart';

/// Notification Router
/// Handles deep linking from push notifications to specific screens
class NotificationRouter {
  static final NotificationRouter instance = NotificationRouter._internal();
  
  factory NotificationRouter() => instance;
  
  NotificationRouter._internal();

  // Global navigator key - must be set in main app
  GlobalKey<NavigatorState>? navigatorKey;

  /// Route notification to appropriate screen based on notification type
  Future<void> route(Map<String, dynamic> data) async {
    if (navigatorKey?.currentContext == null) {
      debugPrint('⚠️ Navigator key not set or context is null');
      return;
    }

    final context = navigatorKey!.currentContext!;
    final type = data['type'] as String?;
    
    debugPrint('🧭 Routing notification of type: $type');
    debugPrint('Notification data: $data');

    switch (type) {
      case 'order_approved':
      case 'order_rejected':
      case 'order_status_changed':
      case 'order_assigned':
      case 'order_picked_up':
      case 'order_delivered':
        await _navigateToOrderDetails(context, data);
        break;

      case 'order_awaiting_approval':
      case 'order_approval_requested':
        await _navigateToOrderApproval(context, data);
        break;

      case 'driver_assigned':
        await _navigateToTracking(context, data);
        break;

      case 'wallet_refund':
      case 'wallet_withdrawal':
        await _navigateToWallet(context, data);
        break;

      case 'new_promotion':
      case 'special_offer':
        await _navigateToPromotions(context, data);
        break;

      case 'profile_update':
      case 'verification_required':
        await _navigateToProfile(context, data);
        break;

      case 'general':
      default:
        await _navigateToNotifications(context, data);
        break;
    }
  }

  /// Navigate to order details screen
  Future<void> _navigateToOrderDetails(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      final orderSlug = data['order_slug'] as String?;
      
      if (orderSlug == null) {
        debugPrint('⚠️ Order slug is null');
        return;
      }

      // Navigate to order details
      // Replace with your actual navigation logic
      debugPrint('📍 Navigating to order details: $orderSlug');
      
      // Example:
      // Navigator.of(context).pushNamed(
      //   '/order-details',
      //   arguments: {'orderSlug': orderSlug},
      // );
    } catch (e) {
      debugPrint('❌ Error navigating to order details: $e');
    }
  }

  /// Navigate to order approval screen
  Future<void> _navigateToOrderApproval(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      final orderSlug = data['order_slug'] as String?;
      
      if (orderSlug == null) {
        debugPrint('⚠️ Order slug is null');
        return;
      }

      debugPrint('📍 Navigating to order approval: $orderSlug');
      
      // Example:
      // Navigator.of(context).pushNamed(
      //   '/order-approval',
      //   arguments: {'orderSlug': orderSlug},
      // );
    } catch (e) {
      debugPrint('❌ Error navigating to order approval: $e');
    }
  }

  /// Navigate to tracking screen
  Future<void> _navigateToTracking(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      final orderSlug = data['order_slug'] as String?;
      
      if (orderSlug == null) {
        debugPrint('⚠️ Order slug is null');
        return;
      }

      debugPrint('📍 Navigating to tracking: $orderSlug');
      
      // Example:
      // Navigator.of(context).pushNamed(
      //   '/tracking',
      //   arguments: {'orderSlug': orderSlug},
      // );
    } catch (e) {
      debugPrint('❌ Error navigating to tracking: $e');
    }
  }

  /// Navigate to wallet screen
  Future<void> _navigateToWallet(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      debugPrint('📍 Navigating to wallet');
      
      // Example:
      // Navigator.of(context).pushNamed('/wallet');
    } catch (e) {
      debugPrint('❌ Error navigating to wallet: $e');
    }
  }

  /// Navigate to promotions screen
  Future<void> _navigateToPromotions(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      debugPrint('📍 Navigating to promotions');
      
      // Example:
      // Navigator.of(context).pushNamed('/promotions');
    } catch (e) {
      debugPrint('❌ Error navigating to promotions: $e');
    }
  }

  /// Navigate to profile screen
  Future<void> _navigateToProfile(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      debugPrint('📍 Navigating to profile');
      
      // Example:
      // Navigator.of(context).pushNamed('/profile');
    } catch (e) {
      debugPrint('❌ Error navigating to profile: $e');
    }
  }

  /// Navigate to notifications screen
  Future<void> _navigateToNotifications(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      debugPrint('📍 Navigating to notifications');
      
      // Example:
      // Navigator.of(context).pushNamed('/notifications');
    } catch (e) {
      debugPrint('❌ Error navigating to notifications: $e');
    }
  }
}

