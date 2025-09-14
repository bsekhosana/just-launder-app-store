// Removed unused import

/// Mock service for settings data and functionality
class SettingsMockService {
  static final SettingsMockService _instance = SettingsMockService._internal();
  factory SettingsMockService() => _instance;
  SettingsMockService._internal();

  // Mock data for different settings categories
  static const Map<String, dynamic> mockSettingsData = {
    'general': {
      'languages': [
        {'code': 'en', 'name': 'English', 'nativeName': 'English'},
        {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español'},
        {'code': 'fr', 'name': 'French', 'nativeName': 'Français'},
        {'code': 'de', 'name': 'German', 'nativeName': 'Deutsch'},
        {'code': 'it', 'name': 'Italian', 'nativeName': 'Italiano'},
        {'code': 'pt', 'name': 'Portuguese', 'nativeName': 'Português'},
        {'code': 'nl', 'name': 'Dutch', 'nativeName': 'Nederlands'},
        {'code': 'sv', 'name': 'Swedish', 'nativeName': 'Svenska'},
      ],
      'currencies': [
        {'code': 'GBP', 'name': 'British Pound', 'symbol': '£'},
        {'code': 'USD', 'name': 'US Dollar', 'symbol': '\$'},
        {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
        {'code': 'CAD', 'name': 'Canadian Dollar', 'symbol': 'C\$'},
        {'code': 'AUD', 'name': 'Australian Dollar', 'symbol': 'A\$'},
        {'code': 'JPY', 'name': 'Japanese Yen', 'symbol': '¥'},
        {'code': 'CHF', 'name': 'Swiss Franc', 'symbol': 'CHF'},
        {'code': 'SEK', 'name': 'Swedish Krona', 'symbol': 'kr'},
      ],
      'timezones': [
        {'code': 'GMT', 'name': 'Greenwich Mean Time', 'offset': '+00:00'},
        {'code': 'BST', 'name': 'British Summer Time', 'offset': '+01:00'},
        {'code': 'EST', 'name': 'Eastern Standard Time', 'offset': '-05:00'},
        {'code': 'PST', 'name': 'Pacific Standard Time', 'offset': '-08:00'},
        {'code': 'CET', 'name': 'Central European Time', 'offset': '+01:00'},
        {'code': 'JST', 'name': 'Japan Standard Time', 'offset': '+09:00'},
        {
          'code': 'AEST',
          'name': 'Australian Eastern Standard Time',
          'offset': '+10:00',
        },
        {'code': 'IST', 'name': 'Indian Standard Time', 'offset': '+05:30'},
      ],
    },
    'business': {
      'businessHours': [
        {'value': '24/7', 'label': '24/7 (Always Open)'},
        {'value': '9-6', 'label': '9:00 AM - 6:00 PM'},
        {'value': '8-8', 'label': '8:00 AM - 8:00 PM'},
        {'value': '10-10', 'label': '10:00 AM - 10:00 PM'},
        {'value': 'custom', 'label': 'Custom Hours'},
      ],
      'orderTimeouts': [
        {'minutes': 5, 'label': '5 minutes'},
        {'minutes': 10, 'label': '10 minutes'},
        {'minutes': 15, 'label': '15 minutes'},
        {'minutes': 30, 'label': '30 minutes'},
        {'minutes': 60, 'label': '1 hour'},
        {'minutes': 120, 'label': '2 hours'},
      ],
      'sessionTimeouts': [
        {'minutes': 15, 'label': '15 minutes'},
        {'minutes': 30, 'label': '30 minutes'},
        {'minutes': 60, 'label': '1 hour'},
        {'minutes': 120, 'label': '2 hours'},
        {'minutes': 240, 'label': '4 hours'},
        {'minutes': 480, 'label': '8 hours'},
      ],
    },
    'notifications': {
      'frequencies': [
        {'value': 'immediate', 'label': 'Immediate'},
        {'value': 'hourly', 'label': 'Hourly'},
        {'value': 'daily', 'label': 'Daily'},
        {'value': 'weekly', 'label': 'Weekly'},
        {'value': 'monthly', 'label': 'Monthly'},
      ],
      'quietHours': [
        {'start': '22:00', 'end': '08:00', 'label': '10 PM - 8 AM'},
        {'start': '23:00', 'end': '07:00', 'label': '11 PM - 7 AM'},
        {'start': '00:00', 'end': '06:00', 'label': '12 AM - 6 AM'},
        {'start': '21:00', 'end': '09:00', 'label': '9 PM - 9 AM'},
      ],
    },
    'backup': {
      'frequencies': [
        {'value': 'hourly', 'label': 'Hourly'},
        {'value': 'daily', 'label': 'Daily'},
        {'value': 'weekly', 'label': 'Weekly'},
        {'value': 'monthly', 'label': 'Monthly'},
      ],
      'types': [
        {'value': 'full', 'label': 'Full Backup'},
        {'value': 'incremental', 'label': 'Incremental Backup'},
        {'value': 'differential', 'label': 'Differential Backup'},
      ],
    },
    'payment': {
      'methods': [
        {'value': 'card', 'label': 'Credit/Debit Card', 'icon': 'credit_card'},
        {'value': 'bank', 'label': 'Bank Transfer', 'icon': 'account_balance'},
        {'value': 'paypal', 'label': 'PayPal', 'icon': 'paypal'},
        {'value': 'apple', 'label': 'Apple Pay', 'icon': 'apple'},
        {'value': 'google', 'label': 'Google Pay', 'icon': 'google'},
        {'value': 'cash', 'label': 'Cash', 'icon': 'money'},
      ],
      'tipPercentages': [5, 10, 15, 18, 20, 25],
      'minimumAmounts': [1.0, 2.0, 5.0, 10.0, 15.0, 20.0],
    },
    'staff': {
      'maxWorkingHours': [4, 6, 8, 10, 12, 16],
      'breakDurations': [15, 30, 45, 60, 90, 120],
      'shiftTypes': [
        {'value': 'morning', 'label': 'Morning Shift (6 AM - 2 PM)'},
        {'value': 'afternoon', 'label': 'Afternoon Shift (2 PM - 10 PM)'},
        {'value': 'night', 'label': 'Night Shift (10 PM - 6 AM)'},
        {'value': 'full', 'label': 'Full Day (8 AM - 6 PM)'},
        {'value': 'flexible', 'label': 'Flexible Hours'},
      ],
    },
    'inventory': {
      'stockThresholds': [1, 5, 10, 15, 20, 25, 50, 100],
      'expiryAlerts': [1, 3, 7, 14, 30, 60],
      'categories': [
        {'value': 'detergents', 'label': 'Detergents & Soaps'},
        {'value': 'fabric_softeners', 'label': 'Fabric Softeners'},
        {'value': 'bleaches', 'label': 'Bleaches & Stain Removers'},
        {'value': 'bags', 'label': 'Laundry Bags'},
        {'value': 'hangers', 'label': 'Hangers & Accessories'},
        {'value': 'maintenance', 'label': 'Machine Maintenance'},
      ],
    },
    'customer': {
      'loyaltyPrograms': [
        {'value': 'points', 'label': 'Points-based System'},
        {'value': 'stamps', 'label': 'Stamp Card System'},
        {'value': 'tiered', 'label': 'Tiered Membership'},
        {'value': 'referral', 'label': 'Referral Rewards'},
      ],
      'feedbackTypes': [
        {'value': 'rating', 'label': 'Star Rating'},
        {'value': 'review', 'label': 'Text Reviews'},
        {'value': 'survey', 'label': 'Quick Surveys'},
        {'value': 'nps', 'label': 'Net Promoter Score'},
      ],
    },
  };

  // Mock app information
  static const Map<String, dynamic> appInfo = {
    'name': 'Laundrex Business',
    'version': '1.0.0',
    'buildNumber': '100',
    'releaseDate': '2024-01-15',
    'description':
        'Comprehensive laundrette management platform for modern businesses',
    'features': [
      'Order Management',
      'Staff Scheduling',
      'Inventory Tracking',
      'Analytics Dashboard',
      'Customer Management',
      'Payment Processing',
      'Multi-location Support',
      'Real-time Notifications',
    ],
    'support': {
      'email': 'support@laundrex.com',
      'phone': '+44 20 1234 5678',
      'website': 'https://laundrex.com',
      'helpCenter': 'https://help.laundrex.com',
      'statusPage': 'https://status.laundrex.com',
    },
    'legal': {
      'privacyPolicy': 'https://laundrex.com/privacy',
      'termsOfService': 'https://laundrex.com/terms',
      'cookiePolicy': 'https://laundrex.com/cookies',
      'gdprCompliance': 'https://laundrex.com/gdpr',
    },
  };

  // Mock system information
  static const Map<String, dynamic> systemInfo = {
    'deviceInfo': {
      'platform': 'iOS/Android',
      'osVersion': 'iOS 17.0 / Android 14',
      'deviceModel': 'iPhone 15 Pro / Pixel 8',
      'appVersion': '1.0.0',
    },
    'storage': {
      'totalSpace': '256 GB',
      'usedSpace': '45.2 GB',
      'availableSpace': '210.8 GB',
      'appSize': '125.4 MB',
      'cacheSize': '12.3 MB',
      'dataSize': '89.7 MB',
    },
    'performance': {
      'cpuUsage': '15%',
      'memoryUsage': '2.1 GB',
      'batteryLevel': '87%',
      'networkType': 'WiFi',
      'signalStrength': 'Excellent',
    },
  };

  // Mock help topics
  static const List<Map<String, dynamic>> helpTopics = [
    {
      'category': 'Getting Started',
      'topics': [
        {'title': 'Setting up your account', 'url': '/help/setup'},
        {'title': 'Creating your first branch', 'url': '/help/branches'},
        {'title': 'Adding staff members', 'url': '/help/staff'},
        {'title': 'Processing your first order', 'url': '/help/orders'},
      ],
    },
    {
      'category': 'Order Management',
      'topics': [
        {'title': 'Creating and managing orders', 'url': '/help/orders/create'},
        {'title': 'Order status tracking', 'url': '/help/orders/tracking'},
        {'title': 'Payment processing', 'url': '/help/orders/payment'},
        {'title': 'Order analytics', 'url': '/help/orders/analytics'},
      ],
    },
    {
      'category': 'Staff Management',
      'topics': [
        {'title': 'Adding and removing staff', 'url': '/help/staff/manage'},
        {'title': 'Setting up schedules', 'url': '/help/staff/schedules'},
        {'title': 'Performance tracking', 'url': '/help/staff/performance'},
        {'title': 'Payroll management', 'url': '/help/staff/payroll'},
      ],
    },
    {
      'category': 'Inventory',
      'topics': [
        {'title': 'Setting up inventory', 'url': '/help/inventory/setup'},
        {'title': 'Low stock alerts', 'url': '/help/inventory/alerts'},
        {'title': 'Expiry tracking', 'url': '/help/inventory/expiry'},
        {'title': 'Reordering supplies', 'url': '/help/inventory/reorder'},
      ],
    },
    {
      'category': 'Analytics & Reports',
      'topics': [
        {
          'title': 'Understanding your dashboard',
          'url': '/help/analytics/dashboard',
        },
        {'title': 'Revenue reports', 'url': '/help/analytics/revenue'},
        {'title': 'Customer insights', 'url': '/help/analytics/customers'},
        {'title': 'Performance metrics', 'url': '/help/analytics/performance'},
      ],
    },
    {
      'category': 'Troubleshooting',
      'topics': [
        {'title': 'Common issues', 'url': '/help/troubleshooting/common'},
        {'title': 'App not responding', 'url': '/help/troubleshooting/app'},
        {'title': 'Sync problems', 'url': '/help/troubleshooting/sync'},
        {'title': 'Payment issues', 'url': '/help/troubleshooting/payments'},
      ],
    },
  ];

  // Mock FAQ data
  static const List<Map<String, dynamic>> faqs = [
    {
      'question': 'How do I create a new order?',
      'answer':
          'To create a new order, go to the Orders tab and tap the "+" button. Fill in the customer details, select services, and confirm the order.',
      'category': 'Orders',
    },
    {
      'question': 'How can I track my inventory?',
      'answer':
          'Use the Inventory section to monitor stock levels. Set up low stock alerts to be notified when items need reordering.',
      'category': 'Inventory',
    },
    {
      'question': 'How do I schedule staff shifts?',
      'answer':
          'Go to Staff Management, select a staff member, and use the scheduling feature to assign shifts and working hours.',
      'category': 'Staff',
    },
    {
      'question': 'What payment methods are supported?',
      'answer':
          'We support credit/debit cards, bank transfers, PayPal, Apple Pay, Google Pay, and cash payments.',
      'category': 'Payments',
    },
    {
      'question': 'How do I view analytics?',
      'answer':
          'The Analytics dashboard provides insights into revenue, orders, customer satisfaction, and staff performance.',
      'category': 'Analytics',
    },
    {
      'question': 'Can I use the app offline?',
      'answer':
          'Basic functionality is available offline, but full features require an internet connection for data sync.',
      'category': 'General',
    },
    {
      'question': 'How do I backup my data?',
      'answer':
          'Data is automatically backed up to the cloud. You can also export data manually from Settings > Data & Privacy.',
      'category': 'Data',
    },
    {
      'question': 'How do I contact support?',
      'answer':
          'You can reach support via email at support@laundrex.com or call +44 20 1234 5678.',
      'category': 'Support',
    },
  ];

  // Mock notification templates
  static const List<Map<String, dynamic>> notificationTemplates = [
    {
      'type': 'order_created',
      'title': 'New Order Received',
      'body': 'Order #{orderNumber} has been created for {customerName}',
      'enabled': true,
    },
    {
      'type': 'order_ready',
      'title': 'Order Ready for Pickup',
      'body': 'Order #{orderNumber} is ready for pickup',
      'enabled': true,
    },
    {
      'type': 'payment_received',
      'title': 'Payment Received',
      'body': 'Payment of £{amount} received for order #{orderNumber}',
      'enabled': true,
    },
    {
      'type': 'low_stock',
      'title': 'Low Stock Alert',
      'body': '{itemName} is running low (only {quantity} left)',
      'enabled': true,
    },
    {
      'type': 'staff_shift',
      'title': 'Shift Reminder',
      'body': 'Your shift starts in 30 minutes',
      'enabled': true,
    },
    {
      'type': 'system_update',
      'title': 'System Update',
      'body': 'A new app update is available',
      'enabled': false,
    },
  ];

  // Methods to get mock data
  static List<Map<String, dynamic>> getLanguages() {
    return List<Map<String, dynamic>>.from(
      mockSettingsData['general']['languages'],
    );
  }

  static List<Map<String, dynamic>> getCurrencies() {
    return List<Map<String, dynamic>>.from(
      mockSettingsData['general']['currencies'],
    );
  }

  static List<Map<String, dynamic>> getTimezones() {
    return List<Map<String, dynamic>>.from(
      mockSettingsData['general']['timezones'],
    );
  }

  static List<Map<String, dynamic>> getBusinessHours() {
    return List<Map<String, dynamic>>.from(
      mockSettingsData['business']['businessHours'],
    );
  }

  static List<Map<String, dynamic>> getOrderTimeouts() {
    return List<Map<String, dynamic>>.from(
      mockSettingsData['business']['orderTimeouts'],
    );
  }

  static List<Map<String, dynamic>> getSessionTimeouts() {
    return List<Map<String, dynamic>>.from(
      mockSettingsData['business']['sessionTimeouts'],
    );
  }

  static List<Map<String, dynamic>> getNotificationFrequencies() {
    return List<Map<String, dynamic>>.from(
      mockSettingsData['notifications']['frequencies'],
    );
  }

  static List<Map<String, dynamic>> getQuietHours() {
    return List<Map<String, dynamic>>.from(
      mockSettingsData['notifications']['quietHours'],
    );
  }

  static List<Map<String, dynamic>> getBackupFrequencies() {
    return List<Map<String, dynamic>>.from(
      mockSettingsData['backup']['frequencies'],
    );
  }

  static List<Map<String, dynamic>> getPaymentMethods() {
    return List<Map<String, dynamic>>.from(
      mockSettingsData['payment']['methods'],
    );
  }

  static List<int> getTipPercentages() {
    return List<int>.from(mockSettingsData['payment']['tipPercentages']);
  }

  static List<double> getMinimumAmounts() {
    return List<double>.from(mockSettingsData['payment']['minimumAmounts']);
  }

  static List<int> getMaxWorkingHours() {
    return List<int>.from(mockSettingsData['staff']['maxWorkingHours']);
  }

  static List<int> getBreakDurations() {
    return List<int>.from(mockSettingsData['staff']['breakDurations']);
  }

  static List<Map<String, dynamic>> getShiftTypes() {
    return List<Map<String, dynamic>>.from(
      mockSettingsData['staff']['shiftTypes'],
    );
  }

  static List<int> getStockThresholds() {
    return List<int>.from(mockSettingsData['inventory']['stockThresholds']);
  }

  static List<int> getExpiryAlerts() {
    return List<int>.from(mockSettingsData['inventory']['expiryAlerts']);
  }

  static List<Map<String, dynamic>> getInventoryCategories() {
    return List<Map<String, dynamic>>.from(
      mockSettingsData['inventory']['categories'],
    );
  }

  static List<Map<String, dynamic>> getLoyaltyPrograms() {
    return List<Map<String, dynamic>>.from(
      mockSettingsData['customer']['loyaltyPrograms'],
    );
  }

  static List<Map<String, dynamic>> getFeedbackTypes() {
    return List<Map<String, dynamic>>.from(
      mockSettingsData['customer']['feedbackTypes'],
    );
  }

  static Map<String, dynamic> getAppInfo() {
    return Map<String, dynamic>.from(appInfo);
  }

  static Map<String, dynamic> getSystemInfo() {
    return Map<String, dynamic>.from(systemInfo);
  }

  static List<Map<String, dynamic>> getHelpTopics() {
    return List<Map<String, dynamic>>.from(helpTopics);
  }

  static List<Map<String, dynamic>> getFAQs() {
    return List<Map<String, dynamic>>.from(faqs);
  }

  static List<Map<String, dynamic>> getNotificationTemplates() {
    return List<Map<String, dynamic>>.from(notificationTemplates);
  }

  // Mock methods for settings operations
  static Future<bool> saveSettings(Map<String, dynamic> settings) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<Map<String, dynamic>> loadSettings() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return {};
  }

  static Future<bool> resetSettings() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<bool> exportSettings() async {
    // Simulate export operation
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  static Future<bool> importSettings(Map<String, dynamic> settings) async {
    // Simulate import operation
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  static Future<bool> testNotification() async {
    // Simulate sending test notification
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<bool> clearCache() async {
    // Simulate cache clearing
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<bool> clearData() async {
    // Simulate data clearing
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  static Future<bool> checkForUpdates() async {
    // Simulate update check
    await Future.delayed(const Duration(seconds: 2));
    return false; // No updates available
  }

  static Future<String> getAppVersion() async {
    // Simulate version check
    await Future.delayed(const Duration(milliseconds: 500));
    return '1.0.0';
  }

  static Future<Map<String, dynamic>> getAppUsage() async {
    // Simulate usage statistics
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'totalOrders': 1247,
      'totalRevenue': 45678.90,
      'totalCustomers': 892,
      'totalStaff': 12,
      'appOpenings': 3456,
      'averageSessionTime': 12.5,
      'lastActive': DateTime.now().subtract(const Duration(hours: 2)),
    };
  }
}
