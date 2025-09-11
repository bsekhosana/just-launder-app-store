import 'package:flutter/foundation.dart';

class SettingsProvider extends ChangeNotifier {
  // General settings
  String _language = 'English';
  String _currency = 'USD';
  String _timezone = 'UTC';
  bool _darkMode = false;
  bool _autoSync = true;
  bool _locationServices = true;

  // Business settings
  String _businessHours = '24/7';
  bool _autoAcceptOrders = false;
  bool _requireOrderConfirmation = true;
  int _orderTimeoutMinutes = 30;
  bool _enablePriorityDelivery = true;

  // Data settings
  bool _dataBackup = true;
  String _backupFrequency = 'daily';
  bool _analyticsTracking = true;
  bool _crashReporting = true;

  // Security settings
  bool _twoFactorAuth = false;
  bool _sessionTimeout = true;
  int _sessionTimeoutMinutes = 60;
  bool _loginNotifications = true;

  // Notification settings
  bool _orderNotifications = true;
  bool _staffNotifications = true;
  bool _paymentNotifications = true;
  bool _systemNotifications = true;
  bool _marketingNotifications = false;
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;

  // Notification timing
  String _quietHoursStart = '22:00';
  String _quietHoursEnd = '08:00';
  bool _quietHoursEnabled = true;

  // Frequency settings
  String _orderUpdateFrequency = 'immediate';
  String _reportFrequency = 'daily';

  // Getters
  String get language => _language;
  String get currency => _currency;
  String get timezone => _timezone;
  bool get darkMode => _darkMode;
  bool get autoSync => _autoSync;
  bool get locationServices => _locationServices;

  String get businessHours => _businessHours;
  bool get autoAcceptOrders => _autoAcceptOrders;
  bool get requireOrderConfirmation => _requireOrderConfirmation;
  int get orderTimeoutMinutes => _orderTimeoutMinutes;
  bool get enablePriorityDelivery => _enablePriorityDelivery;

  bool get dataBackup => _dataBackup;
  String get backupFrequency => _backupFrequency;
  bool get analyticsTracking => _analyticsTracking;
  bool get crashReporting => _crashReporting;

  bool get twoFactorAuth => _twoFactorAuth;
  bool get sessionTimeout => _sessionTimeout;
  int get sessionTimeoutMinutes => _sessionTimeoutMinutes;
  bool get loginNotifications => _loginNotifications;

  bool get orderNotifications => _orderNotifications;
  bool get staffNotifications => _staffNotifications;
  bool get paymentNotifications => _paymentNotifications;
  bool get systemNotifications => _systemNotifications;
  bool get marketingNotifications => _marketingNotifications;
  bool get pushNotifications => _pushNotifications;
  bool get emailNotifications => _emailNotifications;
  bool get smsNotifications => _smsNotifications;

  String get quietHoursStart => _quietHoursStart;
  String get quietHoursEnd => _quietHoursEnd;
  bool get quietHoursEnabled => _quietHoursEnabled;

  String get orderUpdateFrequency => _orderUpdateFrequency;
  String get reportFrequency => _reportFrequency;

  // General settings methods
  void setLanguage(String language) {
    _language = language;
    notifyListeners();
  }

  void setCurrency(String currency) {
    _currency = currency;
    notifyListeners();
  }

  void setTimezone(String timezone) {
    _timezone = timezone;
    notifyListeners();
  }

  void setDarkMode(bool darkMode) {
    _darkMode = darkMode;
    notifyListeners();
  }

  void setAutoSync(bool autoSync) {
    _autoSync = autoSync;
    notifyListeners();
  }

  void setLocationServices(bool locationServices) {
    _locationServices = locationServices;
    notifyListeners();
  }

  // Business settings methods
  void setBusinessHours(String businessHours) {
    _businessHours = businessHours;
    notifyListeners();
  }

  void setAutoAcceptOrders(bool autoAcceptOrders) {
    _autoAcceptOrders = autoAcceptOrders;
    notifyListeners();
  }

  void setRequireOrderConfirmation(bool requireOrderConfirmation) {
    _requireOrderConfirmation = requireOrderConfirmation;
    notifyListeners();
  }

  void setOrderTimeoutMinutes(int orderTimeoutMinutes) {
    _orderTimeoutMinutes = orderTimeoutMinutes;
    notifyListeners();
  }

  void setEnablePriorityDelivery(bool enablePriorityDelivery) {
    _enablePriorityDelivery = enablePriorityDelivery;
    notifyListeners();
  }

  // Data settings methods
  void setDataBackup(bool dataBackup) {
    _dataBackup = dataBackup;
    notifyListeners();
  }

  void setBackupFrequency(String backupFrequency) {
    _backupFrequency = backupFrequency;
    notifyListeners();
  }

  void setAnalyticsTracking(bool analyticsTracking) {
    _analyticsTracking = analyticsTracking;
    notifyListeners();
  }

  void setCrashReporting(bool crashReporting) {
    _crashReporting = crashReporting;
    notifyListeners();
  }

  // Security settings methods
  void setTwoFactorAuth(bool twoFactorAuth) {
    _twoFactorAuth = twoFactorAuth;
    notifyListeners();
  }

  void setSessionTimeout(bool sessionTimeout) {
    _sessionTimeout = sessionTimeout;
    notifyListeners();
  }

  void setSessionTimeoutMinutes(int sessionTimeoutMinutes) {
    _sessionTimeoutMinutes = sessionTimeoutMinutes;
    notifyListeners();
  }

  void setLoginNotifications(bool loginNotifications) {
    _loginNotifications = loginNotifications;
    notifyListeners();
  }

  // Notification settings methods
  void setOrderNotifications(bool orderNotifications) {
    _orderNotifications = orderNotifications;
    notifyListeners();
  }

  void setStaffNotifications(bool staffNotifications) {
    _staffNotifications = staffNotifications;
    notifyListeners();
  }

  void setPaymentNotifications(bool paymentNotifications) {
    _paymentNotifications = paymentNotifications;
    notifyListeners();
  }

  void setSystemNotifications(bool systemNotifications) {
    _systemNotifications = systemNotifications;
    notifyListeners();
  }

  void setMarketingNotifications(bool marketingNotifications) {
    _marketingNotifications = marketingNotifications;
    notifyListeners();
  }

  void setPushNotifications(bool pushNotifications) {
    _pushNotifications = pushNotifications;
    notifyListeners();
  }

  void setEmailNotifications(bool emailNotifications) {
    _emailNotifications = emailNotifications;
    notifyListeners();
  }

  void setSmsNotifications(bool smsNotifications) {
    _smsNotifications = smsNotifications;
    notifyListeners();
  }

  void setQuietHoursStart(String quietHoursStart) {
    _quietHoursStart = quietHoursStart;
    notifyListeners();
  }

  void setQuietHoursEnd(String quietHoursEnd) {
    _quietHoursEnd = quietHoursEnd;
    notifyListeners();
  }

  void setQuietHoursEnabled(bool quietHoursEnabled) {
    _quietHoursEnabled = quietHoursEnabled;
    notifyListeners();
  }

  void setOrderUpdateFrequency(String orderUpdateFrequency) {
    _orderUpdateFrequency = orderUpdateFrequency;
    notifyListeners();
  }

  void setReportFrequency(String reportFrequency) {
    _reportFrequency = reportFrequency;
    notifyListeners();
  }

  // Reset to defaults
  void resetToDefaults() {
    _language = 'English';
    _currency = 'USD';
    _timezone = 'UTC';
    _darkMode = false;
    _autoSync = true;
    _locationServices = true;

    _businessHours = '24/7';
    _autoAcceptOrders = false;
    _requireOrderConfirmation = true;
    _orderTimeoutMinutes = 30;
    _enablePriorityDelivery = true;

    _dataBackup = true;
    _backupFrequency = 'daily';
    _analyticsTracking = true;
    _crashReporting = true;

    _twoFactorAuth = false;
    _sessionTimeout = true;
    _sessionTimeoutMinutes = 60;
    _loginNotifications = true;

    _orderNotifications = true;
    _staffNotifications = true;
    _paymentNotifications = true;
    _systemNotifications = true;
    _marketingNotifications = false;
    _pushNotifications = true;
    _emailNotifications = true;
    _smsNotifications = false;

    _quietHoursStart = '22:00';
    _quietHoursEnd = '08:00';
    _quietHoursEnabled = true;

    _orderUpdateFrequency = 'immediate';
    _reportFrequency = 'daily';

    notifyListeners();
  }

  // Save settings (mock implementation)
  Future<void> saveSettings() async {
    // TODO: Implement actual settings persistence
    await Future.delayed(const Duration(seconds: 1));
    if (kDebugMode) {
      print('Settings saved successfully');
    }
  }

  // Load settings (mock implementation)
  Future<void> loadSettings() async {
    // TODO: Implement actual settings loading
    await Future.delayed(const Duration(seconds: 1));
    if (kDebugMode) {
      print('Settings loaded successfully');
    }
  }

  // Export settings
  Map<String, dynamic> exportSettings() {
    return {
      'general': {
        'language': _language,
        'currency': _currency,
        'timezone': _timezone,
        'darkMode': _darkMode,
        'autoSync': _autoSync,
        'locationServices': _locationServices,
      },
      'business': {
        'businessHours': _businessHours,
        'autoAcceptOrders': _autoAcceptOrders,
        'requireOrderConfirmation': _requireOrderConfirmation,
        'orderTimeoutMinutes': _orderTimeoutMinutes,
        'enablePriorityDelivery': _enablePriorityDelivery,
      },
      'data': {
        'dataBackup': _dataBackup,
        'backupFrequency': _backupFrequency,
        'analyticsTracking': _analyticsTracking,
        'crashReporting': _crashReporting,
      },
      'security': {
        'twoFactorAuth': _twoFactorAuth,
        'sessionTimeout': _sessionTimeout,
        'sessionTimeoutMinutes': _sessionTimeoutMinutes,
        'loginNotifications': _loginNotifications,
      },
      'notifications': {
        'orderNotifications': _orderNotifications,
        'staffNotifications': _staffNotifications,
        'paymentNotifications': _paymentNotifications,
        'systemNotifications': _systemNotifications,
        'marketingNotifications': _marketingNotifications,
        'pushNotifications': _pushNotifications,
        'emailNotifications': _emailNotifications,
        'smsNotifications': _smsNotifications,
        'quietHoursStart': _quietHoursStart,
        'quietHoursEnd': _quietHoursEnd,
        'quietHoursEnabled': _quietHoursEnabled,
        'orderUpdateFrequency': _orderUpdateFrequency,
        'reportFrequency': _reportFrequency,
      },
    };
  }
}

