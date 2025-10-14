import 'package:flutter/material.dart';
import '../domain/models/dashboard_analytics_model.dart';
import '../domain/repositories/analytics_repository.dart';

class AnalyticsProviderClean with ChangeNotifier {
  final AnalyticsRepository repository;

  AnalyticsProviderClean({required this.repository});

  // State
  bool _isLoading = false;
  String? _error;
  String _selectedBranchId = 'all';
  String _selectedPeriod = 'week';

  // Data
  DashboardAnalyticsModel? _dashboardData;
  List<Map<String, dynamic>> _revenueByBranch = [];
  List<Map<String, dynamic>> _timeSeriesData = [];
  List<Map<String, dynamic>> _topServices = [];
  List<Map<String, dynamic>> _topCustomers = [];
  List<Map<String, dynamic>> _staffPerformance = [];

  // Getters - State
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedBranchId => _selectedBranchId;
  String get selectedPeriod => _selectedPeriod;

  // Getters - Data
  DashboardAnalyticsModel? get dashboardData => _dashboardData;
  List<Map<String, dynamic>> get revenueByBranch => _revenueByBranch;
  List<Map<String, dynamic>> get timeSeriesData => _timeSeriesData;
  List<Map<String, dynamic>> get topServices => _topServices;
  List<Map<String, dynamic>> get topCustomers => _topCustomers;
  List<Map<String, dynamic>> get staffPerformance => _staffPerformance;

  // Convenience getters
  double get totalRevenue => _dashboardData?.totalRevenue ?? 0.0;
  int get totalOrders => _dashboardData?.totalOrders ?? 0;
  int get completedOrders => _dashboardData?.completedOrders ?? 0;
  int get pendingOrders => _dashboardData?.pendingOrders ?? 0;
  int get cancelledOrders => _dashboardData?.cancelledOrders ?? 0;
  double get averageOrderValue => _dashboardData?.averageOrderValue ?? 0.0;
  double get customerSatisfaction => _dashboardData?.customerSatisfaction ?? 0.0;
  int get totalCustomers => _dashboardData?.totalCustomers ?? 0;
  int get newCustomers => _dashboardData?.newCustomers ?? 0;
  double get averageDeliveryTime => _dashboardData?.averageDeliveryTime ?? 0.0;
  double get completionRate => _dashboardData?.completionRate ?? 0.0;
  double get cancellationRate => _dashboardData?.cancellationRate ?? 0.0;
  String get averageDeliveryTimeFormatted =>
      _dashboardData?.averageDeliveryTimeFormatted ?? '0m';

  /// Load dashboard analytics
  Future<void> loadDashboardAnalytics() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _dashboardData = await repository.getDashboardAnalytics(
        period: _selectedPeriod,
        branchId: _selectedBranchId != 'all' ? _selectedBranchId : null,
      );

      debugPrint('✅ Loaded dashboard analytics');
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
      _revenueByBranch = await repository.getRevenueByBranch(
        period: _selectedPeriod,
      );
      debugPrint('✅ Loaded revenue by branch');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to load revenue by branch: $e');
    }
  }

  /// Load time series data
  Future<void> loadTimeSeriesData() async {
    try {
      _timeSeriesData = await repository.getTimeSeriesData(
        period: _selectedPeriod,
      );
      debugPrint('✅ Loaded time series data');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to load time series data: $e');
    }
  }

  /// Load top services
  Future<void> loadTopServices() async {
    try {
      _topServices = await repository.getTopServices(
        period: _selectedPeriod,
        limit: 10,
      );
      debugPrint('✅ Loaded top services');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to load top services: $e');
    }
  }

  /// Load top customers
  Future<void> loadTopCustomers() async {
    try {
      _topCustomers = await repository.getTopCustomers(
        period: _selectedPeriod,
        limit: 10,
      );
      debugPrint('✅ Loaded top customers');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to load top customers: $e');
    }
  }

  /// Load staff performance
  Future<void> loadStaffPerformance() async {
    try {
      _staffPerformance = await repository.getStaffPerformance(
        period: _selectedPeriod,
      );
      debugPrint('✅ Loaded staff performance');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to load staff performance: $e');
    }
  }

  /// Load all analytics
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

  /// Refresh all data
  Future<void> refresh() async {
    await loadAllAnalytics();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

