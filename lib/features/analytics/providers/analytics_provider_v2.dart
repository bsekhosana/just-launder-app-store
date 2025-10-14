import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';

class AnalyticsProviderV2 with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _error;
  String _selectedBranchId = 'all';
  String _selectedPeriod = 'week'; // day, week, month, year

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedBranchId => _selectedBranchId;
  String get selectedPeriod => _selectedPeriod;

  // Dashboard Analytics
  Map<String, dynamic> _dashboardData = {};
  List<Map<String, dynamic>> _revenueByBranch = [];
  List<Map<String, dynamic>> _timeSeriesData = [];
  List<Map<String, dynamic>> _topServices = [];
  List<Map<String, dynamic>> _topCustomers = [];
  List<Map<String, dynamic>> _staffPerformance = [];

  // Getters
  Map<String, dynamic> get dashboardData => _dashboardData;
  List<Map<String, dynamic>> get revenueByBranch => _revenueByBranch;
  List<Map<String, dynamic>> get timeSeriesData => _timeSeriesData;
  List<Map<String, dynamic>> get topServices => _topServices;
  List<Map<String, dynamic>> get topCustomers => _topCustomers;
  List<Map<String, dynamic>> get staffPerformance => _staffPerformance;

  // Convenience getters for dashboard data
  double get totalRevenue => _dashboardData['total_revenue']?.toDouble() ?? 0.0;
  int get totalOrders => _dashboardData['total_orders'] ?? 0;
  int get completedOrders => _dashboardData['completed_orders'] ?? 0;
  int get pendingOrders => _dashboardData['pending_orders'] ?? 0;
  int get cancelledOrders => _dashboardData['cancelled_orders'] ?? 0;
  double get averageOrderValue =>
      _dashboardData['average_order_value']?.toDouble() ?? 0.0;
  double get customerSatisfaction =>
      _dashboardData['customer_satisfaction']?.toDouble() ?? 0.0;
  int get totalCustomers => _dashboardData['total_customers'] ?? 0;
  int get newCustomers => _dashboardData['new_customers'] ?? 0;
  double get averageDeliveryTime =>
      _dashboardData['average_delivery_time']?.toDouble() ?? 0.0;
  double get completionRate =>
      _dashboardData['completion_rate']?.toDouble() ?? 0.0;
  double get cancellationRate =>
      _dashboardData['cancellation_rate']?.toDouble() ?? 0.0;

  /// Initialize analytics service
  Future<void> initialize() async {
    await _apiService.initialize();
    await loadDashboardAnalytics();
  }

  /// Load dashboard analytics
  Future<void> loadDashboardAnalytics() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.get(
        '/api/v1/tenant/analytics/dashboard',
        queryParameters: {
          'period': _selectedPeriod,
          'branch_id': _selectedBranchId,
        },
      );

      if (response['success'] == true) {
        _dashboardData = response['data'];
        debugPrint('✅ Loaded dashboard analytics');
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Failed to load dashboard analytics: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load revenue by branch
  Future<void> loadRevenueByBranch() async {
    try {
      final response = await _apiService.get(
        '/api/v1/tenant/analytics/revenue-by-branch',
        queryParameters: {'period': _selectedPeriod},
      );

      if (response['success'] == true) {
        _revenueByBranch = List<Map<String, dynamic>>.from(response['data']);
        debugPrint('✅ Loaded revenue by branch');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Failed to load revenue by branch: $e');
    }
  }

  /// Load time series data
  Future<void> loadTimeSeriesData() async {
    try {
      final response = await _apiService.get(
        '/api/v1/tenant/analytics/time-series',
        queryParameters: {'period': _selectedPeriod},
      );

      if (response['success'] == true) {
        _timeSeriesData = List<Map<String, dynamic>>.from(response['data']);
        debugPrint('✅ Loaded time series data');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Failed to load time series data: $e');
    }
  }

  /// Load top services
  Future<void> loadTopServices() async {
    try {
      final response = await _apiService.get(
        '/api/v1/tenant/analytics/top-services',
        queryParameters: {'period': _selectedPeriod, 'limit': 10},
      );

      if (response['success'] == true) {
        _topServices = List<Map<String, dynamic>>.from(response['data']);
        debugPrint('✅ Loaded top services');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Failed to load top services: $e');
    }
  }

  /// Load top customers
  Future<void> loadTopCustomers() async {
    try {
      final response = await _apiService.get(
        '/api/v1/tenant/analytics/top-customers',
        queryParameters: {'period': _selectedPeriod, 'limit': 10},
      );

      if (response['success'] == true) {
        _topCustomers = List<Map<String, dynamic>>.from(response['data']);
        debugPrint('✅ Loaded top customers');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Failed to load top customers: $e');
    }
  }

  /// Load staff performance
  Future<void> loadStaffPerformance() async {
    try {
      final response = await _apiService.get(
        '/api/v1/tenant/analytics/staff-performance',
        queryParameters: {'period': _selectedPeriod},
      );

      if (response['success'] == true) {
        _staffPerformance = List<Map<String, dynamic>>.from(response['data']);
        debugPrint('✅ Loaded staff performance');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Failed to load staff performance: $e');
    }
  }

  /// Load all analytics data
  Future<void> loadAllAnalytics() async {
    await Future.wait([
      loadDashboardAnalytics(),
      loadRevenueByBranch(),
      loadTimeSeriesData(),
      loadTopServices(),
      loadTopCustomers(),
      loadStaffPerformance(),
    ]);
  }

  /// Update selected branch
  void updateSelectedBranch(String branchId) {
    _selectedBranchId = branchId;
    loadDashboardAnalytics();
  }

  /// Update selected period
  void updateSelectedPeriod(String period) {
    _selectedPeriod = period;
    loadAllAnalytics();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Get average delivery time formatted
  String get averageDeliveryTimeFormatted {
    final deliveryTime = averageDeliveryTime;
    final hours = (deliveryTime / 60).floor();
    final minutes = (deliveryTime % 60).round();
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
