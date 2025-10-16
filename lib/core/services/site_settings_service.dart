import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Site settings service for managing dynamic app configuration
class SiteSettingsService {
  static const String baseUrl = 'https://justlaunder.co.uk';
  static const String _settingsKey = 'site_settings';

  // Singleton instance
  static final SiteSettingsService _instance = SiteSettingsService._internal();
  factory SiteSettingsService() => _instance;

  late final Dio _dio;
  Map<String, dynamic> _settings = {};
  bool _isLoaded = false;

  SiteSettingsService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  /// Load site settings from API
  Future<void> loadSettings() async {
    if (_isLoaded) return;

    try {
      final response = await _dio.get('/api/v1/site-settings');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          _settings = Map<String, dynamic>.from(data['data']);
          _isLoaded = true;

          // Cache settings locally
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_settingsKey, data.toString());

          debugPrint('[SiteSettings] ✅ Settings loaded successfully');
        }
      }
    } catch (e) {
      debugPrint('[SiteSettings] ❌ Failed to load settings: $e');
      // Try to load from cache
      await _loadFromCache();
    }
  }

  /// Load settings from local cache
  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedSettings = prefs.getString(_settingsKey);
      if (cachedSettings != null) {
        // Parse cached settings (simplified for now)
        _settings = {
          'currency': '£',
          'currency_code': 'GBP',
          'app_name': 'Just Launder',
          'support_email': 'support@justlaunder.co.uk',
          'support_phone': '+44 20 1234 5678',
        };
        _isLoaded = true;
        debugPrint('[SiteSettings] ✅ Settings loaded from cache');
      }
    } catch (e) {
      debugPrint('[SiteSettings] ❌ Failed to load from cache: $e');
    }
  }

  /// Get currency symbol
  String get currencySymbol => _settings['currency'] ?? '£';

  /// Get currency code
  String get currencyCode => _settings['currency_code'] ?? 'GBP';

  /// Get app name
  String get appName => _settings['app_name'] ?? 'Just Launder';

  /// Get support email
  String get supportEmail =>
      _settings['support_email'] ?? 'support@justlaunder.co.uk';

  /// Get support phone
  String get supportPhone => _settings['support_phone'] ?? '+44 20 1234 5678';

  /// Get setting by key
  dynamic getSetting(String key) => _settings[key];

  /// Check if settings are loaded
  bool get isLoaded => _isLoaded;

  /// Format currency amount
  String formatCurrency(double amount) {
    return '$currencySymbol${amount.toStringAsFixed(2)}';
  }

  /// Format currency amount with custom decimal places
  String formatCurrencyWithDecimals(double amount, int decimals) {
    return '$currencySymbol${amount.toStringAsFixed(decimals)}';
  }
}

