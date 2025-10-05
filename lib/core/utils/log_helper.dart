import 'package:flutter/foundation.dart';

/// Debug-only logging utility
/// Only logs when running in debug mode
class LogHelper {
  /// Log info messages (only in debug mode)
  static void info(String message, [String? tag]) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag]' : '[INFO]';
      print('$timestamp $tagPrefix $message');
    }
  }

  /// Log warning messages (only in debug mode)
  static void warning(String message, [String? tag]) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag]' : '[WARNING]';
      print('$timestamp $tagPrefix $message');
    }
  }

  /// Log error messages (only in debug mode)
  static void error(String message, [String? tag, Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag]' : '[ERROR]';
      print('$timestamp $tagPrefix $message');
      
      if (error != null) {
        print('$timestamp $tagPrefix Error: $error');
      }
      
      if (stackTrace != null) {
        print('$timestamp $tagPrefix StackTrace: $stackTrace');
      }
    }
  }

  /// Log debug messages (only in debug mode)
  static void debug(String message, [String? tag]) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag]' : '[DEBUG]';
      print('$timestamp $tagPrefix $message');
    }
  }

  /// Log API request/response (only in debug mode)
  static void api(String message, [String? tag]) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag]' : '[API]';
      print('$timestamp $tagPrefix $message');
    }
  }

  /// Log authentication related messages (only in debug mode)
  static void auth(String message) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      print('$timestamp [AUTH] $message');
    }
  }

  /// Log navigation related messages (only in debug mode)
  static void navigation(String message) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      print('$timestamp [NAV] $message');
    }
  }
}
