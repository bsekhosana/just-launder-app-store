import 'package:flutter/foundation.dart';

/// Settings provider to manage all app settings and preferences
class SettingsProvider with ChangeNotifier {
  // General Settings
  String _language = 'English';
  String _currency = 'GBP';
  String _timezone = 'GMT';
  bool _darkMode = false;
  bool _autoSync = true;
  bool _locationServices = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  // Security Settings
  bool _biometricAuth = false;
  bool _pinEnabled = false;
  String _pinCode = '';
  bool _sessionTimeout = true;
  int _sessionTimeoutMinutes = 30;
  bool _loginNotifications = true;
  bool _twoFactorAuth = false;

  // Notification Settings
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _orderNotifications = true;
  bool _staffNotifications = true;
  bool _paymentNotifications = true;
  bool _systemNotifications = true;
  bool _marketingNotifications = false;
  bool _quietHoursEnabled = false;
  String _quietHoursStart = '22:00';
  String _quietHoursEnd = '08:00';
  String _orderUpdateFrequency = 'immediate';
  String _reportFrequency = 'daily';

  // Business Settings
  String _businessHours = '24/7';
  bool _autoAcceptOrders = false;
  bool _requireOrderConfirmation = true;
  int _orderTimeoutMinutes = 30;
  bool _enablePriorityDelivery = true;
  bool _enableCustomerRating = true;
  bool _enableOrderTracking = true;
  bool _enableLoyaltyProgram = false;

  // Data & Privacy Settings
  bool _dataBackup = true;
  String _backupFrequency = 'daily';
  bool _analyticsTracking = true;
  bool _crashReporting = true;
  bool _dataSharing = false;
  bool _marketingEmails = false;

  // Payment Settings
  String _defaultPaymentMethod = 'card';
  bool _savePaymentMethods = true;
  bool _autoPayment = false;
  double _minimumOrderAmount = 5.0;
  bool _enableTips = true;
  double _defaultTipPercentage = 10.0;

  // Staff Settings
  bool _staffScheduling = true;
  bool _shiftNotifications = true;
  bool _performanceTracking = true;
  bool _timeTracking = true;
  bool _breakTracking = true;
  int _maxWorkingHours = 8;
  int _breakDurationMinutes = 30;

  // Inventory Settings
  bool _lowStockAlerts = true;
  bool _autoReorder = false;
  int _lowStockThreshold = 10;
  bool _expiryAlerts = true;
  int _expiryAlertDays = 7;

  // Customer Settings
  bool _customerProfiles = true;
  bool _customerHistory = true;
  bool _customerPreferences = true;
  bool _loyaltyPoints = false;
  bool _customerFeedback = true;
  bool _referralProgram = false;

  // Getters
  String get language => _language;
  String get currency => _currency;
  String get timezone => _timezone;
  bool get darkMode => _darkMode;
  bool get autoSync => _autoSync;
  bool get locationServices => _locationServices;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  bool get biometricAuth => _biometricAuth;
  bool get pinEnabled => _pinEnabled;
  String get pinCode => _pinCode;
  bool get sessionTimeout => _sessionTimeout;
  int get sessionTimeoutMinutes => _sessionTimeoutMinutes;
  bool get loginNotifications => _loginNotifications;
  bool get twoFactorAuth => _twoFactorAuth;

  bool get pushNotifications => _pushNotifications;
  bool get emailNotifications => _emailNotifications;
  bool get smsNotifications => _smsNotifications;
  bool get orderNotifications => _orderNotifications;
  bool get staffNotifications => _staffNotifications;
  bool get paymentNotifications => _paymentNotifications;
  bool get systemNotifications => _systemNotifications;
  bool get marketingNotifications => _marketingNotifications;
  bool get quietHoursEnabled => _quietHoursEnabled;
  String get quietHoursStart => _quietHoursStart;
  String get quietHoursEnd => _quietHoursEnd;
  String get orderUpdateFrequency => _orderUpdateFrequency;
  String get reportFrequency => _reportFrequency;

  String get businessHours => _businessHours;
  bool get autoAcceptOrders => _autoAcceptOrders;
  bool get requireOrderConfirmation => _requireOrderConfirmation;
  int get orderTimeoutMinutes => _orderTimeoutMinutes;
  bool get enablePriorityDelivery => _enablePriorityDelivery;
  bool get enableCustomerRating => _enableCustomerRating;
  bool get enableOrderTracking => _enableOrderTracking;
  bool get enableLoyaltyProgram => _enableLoyaltyProgram;

  bool get dataBackup => _dataBackup;
  String get backupFrequency => _backupFrequency;
  bool get analyticsTracking => _analyticsTracking;
  bool get crashReporting => _crashReporting;
  bool get dataSharing => _dataSharing;
  bool get marketingEmails => _marketingEmails;

  String get defaultPaymentMethod => _defaultPaymentMethod;
  bool get savePaymentMethods => _savePaymentMethods;
  bool get autoPayment => _autoPayment;
  double get minimumOrderAmount => _minimumOrderAmount;
  bool get enableTips => _enableTips;
  double get defaultTipPercentage => _defaultTipPercentage;

  bool get staffScheduling => _staffScheduling;
  bool get shiftNotifications => _shiftNotifications;
  bool get performanceTracking => _performanceTracking;
  bool get timeTracking => _timeTracking;
  bool get breakTracking => _breakTracking;
  int get maxWorkingHours => _maxWorkingHours;
  int get breakDurationMinutes => _breakDurationMinutes;

  bool get lowStockAlerts => _lowStockAlerts;
  bool get autoReorder => _autoReorder;
  int get lowStockThreshold => _lowStockThreshold;
  bool get expiryAlerts => _expiryAlerts;
  int get expiryAlertDays => _expiryAlertDays;

  bool get customerProfiles => _customerProfiles;
  bool get customerHistory => _customerHistory;
  bool get customerPreferences => _customerPreferences;
  bool get loyaltyPoints => _loyaltyPoints;
  bool get customerFeedback => _customerFeedback;
  bool get referralProgram => _referralProgram;

  // Methods to update settings
  void updateLanguage(String language) {
    _language = language;
    notifyListeners();
  }

  void updateCurrency(String currency) {
    _currency = currency;
    notifyListeners();
  }

  void updateTimezone(String timezone) {
    _timezone = timezone;
    notifyListeners();
  }

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }

  void toggleAutoSync() {
    _autoSync = !_autoSync;
    notifyListeners();
  }

  void toggleLocationServices() {
    _locationServices = !_locationServices;
    notifyListeners();
  }

  void toggleSoundEnabled() {
    _soundEnabled = !_soundEnabled;
    notifyListeners();
  }

  void toggleVibrationEnabled() {
    _vibrationEnabled = !_vibrationEnabled;
    notifyListeners();
  }

  void toggleBiometricAuth() {
    _biometricAuth = !_biometricAuth;
    notifyListeners();
  }

  void togglePinEnabled() {
    _pinEnabled = !_pinEnabled;
    notifyListeners();
  }

  void updatePinCode(String pinCode) {
    _pinCode = pinCode;
    notifyListeners();
  }

  void toggleSessionTimeout() {
    _sessionTimeout = !_sessionTimeout;
    notifyListeners();
  }

  void updateSessionTimeoutMinutes(int minutes) {
    _sessionTimeoutMinutes = minutes;
    notifyListeners();
  }

  void toggleLoginNotifications() {
    _loginNotifications = !_loginNotifications;
    notifyListeners();
  }

  void toggleTwoFactorAuth() {
    _twoFactorAuth = !_twoFactorAuth;
    notifyListeners();
  }

  // Notification settings
  void togglePushNotifications() {
    _pushNotifications = !_pushNotifications;
    notifyListeners();
  }

  void toggleEmailNotifications() {
    _emailNotifications = !_emailNotifications;
    notifyListeners();
  }

  void toggleSmsNotifications() {
    _smsNotifications = !_smsNotifications;
    notifyListeners();
  }

  void toggleOrderNotifications() {
    _orderNotifications = !_orderNotifications;
    notifyListeners();
  }

  void toggleStaffNotifications() {
    _staffNotifications = !_staffNotifications;
    notifyListeners();
  }

  void togglePaymentNotifications() {
    _paymentNotifications = !_paymentNotifications;
    notifyListeners();
  }

  void toggleSystemNotifications() {
    _systemNotifications = !_systemNotifications;
    notifyListeners();
  }

  void toggleMarketingNotifications() {
    _marketingNotifications = !_marketingNotifications;
    notifyListeners();
  }

  void toggleQuietHours() {
    _quietHoursEnabled = !_quietHoursEnabled;
    notifyListeners();
  }

  void updateQuietHours(String start, String end) {
    _quietHoursStart = start;
    _quietHoursEnd = end;
    notifyListeners();
  }

  void updateOrderUpdateFrequency(String frequency) {
    _orderUpdateFrequency = frequency;
    notifyListeners();
  }

  void updateReportFrequency(String frequency) {
    _reportFrequency = frequency;
    notifyListeners();
  }

  // Business settings
  void updateBusinessHours(String hours) {
    _businessHours = hours;
    notifyListeners();
  }

  void toggleAutoAcceptOrders() {
    _autoAcceptOrders = !_autoAcceptOrders;
    notifyListeners();
  }

  void toggleRequireOrderConfirmation() {
    _requireOrderConfirmation = !_requireOrderConfirmation;
    notifyListeners();
  }

  void updateOrderTimeoutMinutes(int minutes) {
    _orderTimeoutMinutes = minutes;
    notifyListeners();
  }

  void toggleEnablePriorityDelivery() {
    _enablePriorityDelivery = !_enablePriorityDelivery;
    notifyListeners();
  }

  void toggleEnableCustomerRating() {
    _enableCustomerRating = !_enableCustomerRating;
    notifyListeners();
  }

  void toggleEnableOrderTracking() {
    _enableOrderTracking = !_enableOrderTracking;
    notifyListeners();
  }

  void toggleEnableLoyaltyProgram() {
    _enableLoyaltyProgram = !_enableLoyaltyProgram;
    notifyListeners();
  }

  // Data & Privacy settings
  void toggleDataBackup() {
    _dataBackup = !_dataBackup;
    notifyListeners();
  }

  void updateBackupFrequency(String frequency) {
    _backupFrequency = frequency;
    notifyListeners();
  }

  void toggleAnalyticsTracking() {
    _analyticsTracking = !_analyticsTracking;
    notifyListeners();
  }

  void toggleCrashReporting() {
    _crashReporting = !_crashReporting;
    notifyListeners();
  }

  void toggleDataSharing() {
    _dataSharing = !_dataSharing;
    notifyListeners();
  }

  void toggleMarketingEmails() {
    _marketingEmails = !_marketingEmails;
    notifyListeners();
  }

  // Payment settings
  void updateDefaultPaymentMethod(String method) {
    _defaultPaymentMethod = method;
    notifyListeners();
  }

  void toggleSavePaymentMethods() {
    _savePaymentMethods = !_savePaymentMethods;
    notifyListeners();
  }

  void toggleAutoPayment() {
    _autoPayment = !_autoPayment;
    notifyListeners();
  }

  void updateMinimumOrderAmount(double amount) {
    _minimumOrderAmount = amount;
    notifyListeners();
  }

  void toggleEnableTips() {
    _enableTips = !_enableTips;
    notifyListeners();
  }

  void updateDefaultTipPercentage(double percentage) {
    _defaultTipPercentage = percentage;
    notifyListeners();
  }

  // Staff settings
  void toggleStaffScheduling() {
    _staffScheduling = !_staffScheduling;
    notifyListeners();
  }

  void toggleShiftNotifications() {
    _shiftNotifications = !_shiftNotifications;
    notifyListeners();
  }

  void togglePerformanceTracking() {
    _performanceTracking = !_performanceTracking;
    notifyListeners();
  }

  void toggleTimeTracking() {
    _timeTracking = !_timeTracking;
    notifyListeners();
  }

  void toggleBreakTracking() {
    _breakTracking = !_breakTracking;
    notifyListeners();
  }

  void updateMaxWorkingHours(int hours) {
    _maxWorkingHours = hours;
    notifyListeners();
  }

  void updateBreakDurationMinutes(int minutes) {
    _breakDurationMinutes = minutes;
    notifyListeners();
  }

  // Inventory settings
  void toggleLowStockAlerts() {
    _lowStockAlerts = !_lowStockAlerts;
    notifyListeners();
  }

  void toggleAutoReorder() {
    _autoReorder = !_autoReorder;
    notifyListeners();
  }

  void updateLowStockThreshold(int threshold) {
    _lowStockThreshold = threshold;
    notifyListeners();
  }

  void toggleExpiryAlerts() {
    _expiryAlerts = !_expiryAlerts;
    notifyListeners();
  }

  void updateExpiryAlertDays(int days) {
    _expiryAlertDays = days;
    notifyListeners();
  }

  // Customer settings
  void toggleCustomerProfiles() {
    _customerProfiles = !_customerProfiles;
    notifyListeners();
  }

  void toggleCustomerHistory() {
    _customerHistory = !_customerHistory;
    notifyListeners();
  }

  void toggleCustomerPreferences() {
    _customerPreferences = !_customerPreferences;
    notifyListeners();
  }

  void toggleLoyaltyPoints() {
    _loyaltyPoints = !_loyaltyPoints;
    notifyListeners();
  }

  void toggleCustomerFeedback() {
    _customerFeedback = !_customerFeedback;
    notifyListeners();
  }

  void toggleReferralProgram() {
    _referralProgram = !_referralProgram;
    notifyListeners();
  }

  // Reset to defaults
  void resetToDefaults() {
    _language = 'English';
    _currency = 'GBP';
    _timezone = 'GMT';
    _darkMode = false;
    _autoSync = true;
    _locationServices = true;
    _soundEnabled = true;
    _vibrationEnabled = true;
    _biometricAuth = false;
    _pinEnabled = false;
    _pinCode = '';
    _sessionTimeout = true;
    _sessionTimeoutMinutes = 30;
    _loginNotifications = true;
    _twoFactorAuth = false;
    _pushNotifications = true;
    _emailNotifications = true;
    _smsNotifications = false;
    _orderNotifications = true;
    _staffNotifications = true;
    _paymentNotifications = true;
    _systemNotifications = true;
    _marketingNotifications = false;
    _quietHoursEnabled = false;
    _quietHoursStart = '22:00';
    _quietHoursEnd = '08:00';
    _orderUpdateFrequency = 'immediate';
    _reportFrequency = 'daily';
    _businessHours = '24/7';
    _autoAcceptOrders = false;
    _requireOrderConfirmation = true;
    _orderTimeoutMinutes = 30;
    _enablePriorityDelivery = true;
    _enableCustomerRating = true;
    _enableOrderTracking = true;
    _enableLoyaltyProgram = false;
    _dataBackup = true;
    _backupFrequency = 'daily';
    _analyticsTracking = true;
    _crashReporting = true;
    _dataSharing = false;
    _marketingEmails = false;
    _defaultPaymentMethod = 'card';
    _savePaymentMethods = true;
    _autoPayment = false;
    _minimumOrderAmount = 5.0;
    _enableTips = true;
    _defaultTipPercentage = 10.0;
    _staffScheduling = true;
    _shiftNotifications = true;
    _performanceTracking = true;
    _timeTracking = true;
    _breakTracking = true;
    _maxWorkingHours = 8;
    _breakDurationMinutes = 30;
    _lowStockAlerts = true;
    _autoReorder = false;
    _lowStockThreshold = 10;
    _expiryAlerts = true;
    _expiryAlertDays = 7;
    _customerProfiles = true;
    _customerHistory = true;
    _customerPreferences = true;
    _loyaltyPoints = false;
    _customerFeedback = true;
    _referralProgram = false;

    notifyListeners();
  }

  // Export settings
  Map<String, dynamic> exportSettings() {
    return {
      'language': _language,
      'currency': _currency,
      'timezone': _timezone,
      'darkMode': _darkMode,
      'autoSync': _autoSync,
      'locationServices': _locationServices,
      'soundEnabled': _soundEnabled,
      'vibrationEnabled': _vibrationEnabled,
      'biometricAuth': _biometricAuth,
      'pinEnabled': _pinEnabled,
      'sessionTimeout': _sessionTimeout,
      'sessionTimeoutMinutes': _sessionTimeoutMinutes,
      'loginNotifications': _loginNotifications,
      'twoFactorAuth': _twoFactorAuth,
      'pushNotifications': _pushNotifications,
      'emailNotifications': _emailNotifications,
      'smsNotifications': _smsNotifications,
      'orderNotifications': _orderNotifications,
      'staffNotifications': _staffNotifications,
      'paymentNotifications': _paymentNotifications,
      'systemNotifications': _systemNotifications,
      'marketingNotifications': _marketingNotifications,
      'quietHoursEnabled': _quietHoursEnabled,
      'quietHoursStart': _quietHoursStart,
      'quietHoursEnd': _quietHoursEnd,
      'orderUpdateFrequency': _orderUpdateFrequency,
      'reportFrequency': _reportFrequency,
      'businessHours': _businessHours,
      'autoAcceptOrders': _autoAcceptOrders,
      'requireOrderConfirmation': _requireOrderConfirmation,
      'orderTimeoutMinutes': _orderTimeoutMinutes,
      'enablePriorityDelivery': _enablePriorityDelivery,
      'enableCustomerRating': _enableCustomerRating,
      'enableOrderTracking': _enableOrderTracking,
      'enableLoyaltyProgram': _enableLoyaltyProgram,
      'dataBackup': _dataBackup,
      'backupFrequency': _backupFrequency,
      'analyticsTracking': _analyticsTracking,
      'crashReporting': _crashReporting,
      'dataSharing': _dataSharing,
      'marketingEmails': _marketingEmails,
      'defaultPaymentMethod': _defaultPaymentMethod,
      'savePaymentMethods': _savePaymentMethods,
      'autoPayment': _autoPayment,
      'minimumOrderAmount': _minimumOrderAmount,
      'enableTips': _enableTips,
      'defaultTipPercentage': _defaultTipPercentage,
      'staffScheduling': _staffScheduling,
      'shiftNotifications': _shiftNotifications,
      'performanceTracking': _performanceTracking,
      'timeTracking': _timeTracking,
      'breakTracking': _breakTracking,
      'maxWorkingHours': _maxWorkingHours,
      'breakDurationMinutes': _breakDurationMinutes,
      'lowStockAlerts': _lowStockAlerts,
      'autoReorder': _autoReorder,
      'lowStockThreshold': _lowStockThreshold,
      'expiryAlerts': _expiryAlerts,
      'expiryAlertDays': _expiryAlertDays,
      'customerProfiles': _customerProfiles,
      'customerHistory': _customerHistory,
      'customerPreferences': _customerPreferences,
      'loyaltyPoints': _loyaltyPoints,
      'customerFeedback': _customerFeedback,
      'referralProgram': _referralProgram,
    };
  }

  // Import settings
  void importSettings(Map<String, dynamic> settings) {
    _language = settings['language'] ?? 'English';
    _currency = settings['currency'] ?? 'GBP';
    _timezone = settings['timezone'] ?? 'GMT';
    _darkMode = settings['darkMode'] ?? false;
    _autoSync = settings['autoSync'] ?? true;
    _locationServices = settings['locationServices'] ?? true;
    _soundEnabled = settings['soundEnabled'] ?? true;
    _vibrationEnabled = settings['vibrationEnabled'] ?? true;
    _biometricAuth = settings['biometricAuth'] ?? false;
    _pinEnabled = settings['pinEnabled'] ?? false;
    _sessionTimeout = settings['sessionTimeout'] ?? true;
    _sessionTimeoutMinutes = settings['sessionTimeoutMinutes'] ?? 30;
    _loginNotifications = settings['loginNotifications'] ?? true;
    _twoFactorAuth = settings['twoFactorAuth'] ?? false;
    _pushNotifications = settings['pushNotifications'] ?? true;
    _emailNotifications = settings['emailNotifications'] ?? true;
    _smsNotifications = settings['smsNotifications'] ?? false;
    _orderNotifications = settings['orderNotifications'] ?? true;
    _staffNotifications = settings['staffNotifications'] ?? true;
    _paymentNotifications = settings['paymentNotifications'] ?? true;
    _systemNotifications = settings['systemNotifications'] ?? true;
    _marketingNotifications = settings['marketingNotifications'] ?? false;
    _quietHoursEnabled = settings['quietHoursEnabled'] ?? false;
    _quietHoursStart = settings['quietHoursStart'] ?? '22:00';
    _quietHoursEnd = settings['quietHoursEnd'] ?? '08:00';
    _orderUpdateFrequency = settings['orderUpdateFrequency'] ?? 'immediate';
    _reportFrequency = settings['reportFrequency'] ?? 'daily';
    _businessHours = settings['businessHours'] ?? '24/7';
    _autoAcceptOrders = settings['autoAcceptOrders'] ?? false;
    _requireOrderConfirmation = settings['requireOrderConfirmation'] ?? true;
    _orderTimeoutMinutes = settings['orderTimeoutMinutes'] ?? 30;
    _enablePriorityDelivery = settings['enablePriorityDelivery'] ?? true;
    _enableCustomerRating = settings['enableCustomerRating'] ?? true;
    _enableOrderTracking = settings['enableOrderTracking'] ?? true;
    _enableLoyaltyProgram = settings['enableLoyaltyProgram'] ?? false;
    _dataBackup = settings['dataBackup'] ?? true;
    _backupFrequency = settings['backupFrequency'] ?? 'daily';
    _analyticsTracking = settings['analyticsTracking'] ?? true;
    _crashReporting = settings['crashReporting'] ?? true;
    _dataSharing = settings['dataSharing'] ?? false;
    _marketingEmails = settings['marketingEmails'] ?? false;
    _defaultPaymentMethod = settings['defaultPaymentMethod'] ?? 'card';
    _savePaymentMethods = settings['savePaymentMethods'] ?? true;
    _autoPayment = settings['autoPayment'] ?? false;
    _minimumOrderAmount = (settings['minimumOrderAmount'] ?? 5.0).toDouble();
    _enableTips = settings['enableTips'] ?? true;
    _defaultTipPercentage =
        (settings['defaultTipPercentage'] ?? 10.0).toDouble();
    _staffScheduling = settings['staffScheduling'] ?? true;
    _shiftNotifications = settings['shiftNotifications'] ?? true;
    _performanceTracking = settings['performanceTracking'] ?? true;
    _timeTracking = settings['timeTracking'] ?? true;
    _breakTracking = settings['breakTracking'] ?? true;
    _maxWorkingHours = settings['maxWorkingHours'] ?? 8;
    _breakDurationMinutes = settings['breakDurationMinutes'] ?? 30;
    _lowStockAlerts = settings['lowStockAlerts'] ?? true;
    _autoReorder = settings['autoReorder'] ?? false;
    _lowStockThreshold = settings['lowStockThreshold'] ?? 10;
    _expiryAlerts = settings['expiryAlerts'] ?? true;
    _expiryAlertDays = settings['expiryAlertDays'] ?? 7;
    _customerProfiles = settings['customerProfiles'] ?? true;
    _customerHistory = settings['customerHistory'] ?? true;
    _customerPreferences = settings['customerPreferences'] ?? true;
    _loyaltyPoints = settings['loyaltyPoints'] ?? false;
    _customerFeedback = settings['customerFeedback'] ?? true;
    _referralProgram = settings['referralProgram'] ?? false;

    notifyListeners();
  }
}
