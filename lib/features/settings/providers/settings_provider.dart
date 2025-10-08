import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  String _language = 'en';
  String _currency = 'USD';
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _quietHoursEnabled = false;
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 8, minute: 0);

  // Getters
  String get language => _language;
  String get currency => _currency;
  bool get darkMode => _darkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get emailNotifications => _emailNotifications;
  bool get pushNotifications => _pushNotifications;
  bool get quietHoursEnabled => _quietHoursEnabled;
  TimeOfDay get quietHoursStart => _quietHoursStart;
  TimeOfDay get quietHoursEnd => _quietHoursEnd;
  bool get orderNotifications => _emailNotifications;
  bool get paymentNotifications => _emailNotifications;
  bool get staffNotifications => _emailNotifications;
  bool get systemNotifications => _pushNotifications;
  bool get marketingNotifications => _emailNotifications;
  bool get smsNotifications => _pushNotifications;
  String get reportFrequency => 'weekly';
  String get orderUpdateFrequency => 'realtime';

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language') ?? 'en';
    _currency = prefs.getString('currency') ?? 'USD';
    _darkMode = prefs.getBool('darkMode') ?? false;
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    _emailNotifications = prefs.getBool('emailNotifications') ?? true;
    _pushNotifications = prefs.getBool('pushNotifications') ?? true;
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _language = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    notifyListeners();
  }

  Future<void> setCurrency(String currency) async {
    _currency = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currency);
    notifyListeners();
  }

  Future<void> setDarkMode(bool darkMode) async {
    _darkMode = darkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', darkMode);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', enabled);
    notifyListeners();
  }

  Future<void> setEmailNotifications(bool enabled) async {
    _emailNotifications = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('emailNotifications', enabled);
    notifyListeners();
  }

  Future<void> setPushNotifications(bool enabled) async {
    _pushNotifications = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pushNotifications', enabled);
    notifyListeners();
  }

  Future<void> updateQuietHours({
    required bool enabled,
    required TimeOfDay start,
    required TimeOfDay end,
  }) async {
    _quietHoursEnabled = enabled;
    _quietHoursStart = start;
    _quietHoursEnd = end;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('quietHoursEnabled', enabled);
    notifyListeners();
  }

  // Additional toggle methods
  Future<void> toggleQuietHours(bool enabled) async {
    _quietHoursEnabled = enabled;
    notifyListeners();
  }

  Future<void> togglePushNotifications(bool enabled) async {
    await setPushNotifications(enabled);
  }

  Future<void> toggleOrderNotifications(bool enabled) async {
    _emailNotifications = enabled;
    notifyListeners();
  }

  Future<void> togglePaymentNotifications(bool enabled) async {
    _emailNotifications = enabled;
    notifyListeners();
  }

  Future<void> toggleStaffNotifications(bool enabled) async {
    _emailNotifications = enabled;
    notifyListeners();
  }

  Future<void> toggleSystemNotifications(bool enabled) async {
    _emailNotifications = enabled;
    notifyListeners();
  }

  Future<void> toggleSmsNotifications(bool enabled) async {
    _emailNotifications = enabled;
    notifyListeners();
  }

  Future<void> updateReportFrequency(String frequency) async {
    // Implement if needed
    notifyListeners();
  }

  Future<void> updateOrderUpdateFrequency(String frequency) async {
    // Implement if needed
    notifyListeners();
  }

  Future<void> toggleEmailNotifications(bool enabled) async {
    await setEmailNotifications(enabled);
  }

  Future<void> toggleMarketingNotifications(bool enabled) async {
    _emailNotifications = enabled;
    notifyListeners();
  }

  Future<void> exportSettings() async {
    // Implement if needed
    notifyListeners();
  }
}
