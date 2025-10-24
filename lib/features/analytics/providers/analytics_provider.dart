import 'package:flutter/foundation.dart';
import '../../../data/models/laundrette_order.dart';
import '../../branches/data/models/laundrette_branch.dart';
import '../../../data/models/staff_member.dart';
import '../data/datasources/analytics_remote_data_source.dart';
import '../data/datasources/recent_activity_remote_data_source.dart';

class AnalyticsProvider with ChangeNotifier {
  final AnalyticsRemoteDataSource _dataSource = AnalyticsRemoteDataSource();
  final RecentActivityRemoteDataSource _activityDataSource =
      RecentActivityRemoteDataSource();

  bool _isLoading = false;
  DateTime _selectedDateRange = DateTime.now();
  String _selectedBranchId = 'all';
  String _selectedPeriod = 'week'; // day, week, month, year
  String _selectedOrderStatus = 'all';
  DateTime? _startDate;
  DateTime? _endDate;

  bool get isLoading => _isLoading;
  DateTime get selectedDateRange => _selectedDateRange;
  String get selectedBranchId => _selectedBranchId;
  String get selectedPeriod => _selectedPeriod;
  String get selectedOrderStatus => _selectedOrderStatus;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  // Analytics data
  double _totalRevenue = 0.0;
  int _totalOrders = 0;
  int _completedOrders = 0;
  int _pendingOrders = 0;
  int _cancelledOrders = 0;
  double _averageOrderValue = 0.0;
  double _customerSatisfaction = 0.0;
  int _totalCustomers = 0;
  int _newCustomers = 0;
  double _deliveryTime = 0.0;
  int _totalDeliveries = 0;
  double _staffEfficiency = 0.0;
  Map<String, double> _revenueByBranch = {};
  Map<String, int> _ordersByBranch = {};
  Map<String, double> _revenueByDay = {};
  Map<String, int> _ordersByDay = {};
  List<Map<String, dynamic>> _topServices = [];
  List<Map<String, dynamic>> _topCustomers = [];
  List<Map<String, dynamic>> _staffPerformance = [];
  List<Map<String, dynamic>> _recentActivity = [];

  // Getters
  double get totalRevenue => _totalRevenue;
  int get totalOrders => _totalOrders;
  int get completedOrders => _completedOrders;
  int get pendingOrders => _pendingOrders;
  int get cancelledOrders => _cancelledOrders;
  double get averageOrderValue => _averageOrderValue;
  double get customerSatisfaction => _customerSatisfaction;
  int get totalCustomers => _totalCustomers;
  int get newCustomers => _newCustomers;
  double get deliveryTime => _deliveryTime;
  int get totalDeliveries => _totalDeliveries;
  double get staffEfficiency => _staffEfficiency;
  Map<String, double> get revenueByBranch => _revenueByBranch;
  Map<String, int> get ordersByBranch => _ordersByBranch;
  Map<String, double> get revenueByDay => _revenueByDay;
  Map<String, int> get ordersByDay => _ordersByDay;
  List<Map<String, dynamic>> get topServices => _topServices;
  List<Map<String, dynamic>> get topCustomers => _topCustomers;
  List<Map<String, dynamic>> get staffPerformance => _staffPerformance;
  List<Map<String, dynamic>> get recentActivity => _recentActivity;

  /// Load analytics data from API
  Future<void> loadAnalytics({
    required List<LaundretteOrder> orders,
    required List<LaundretteBranch> branches,
    required List<StaffMember> staff,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load dashboard analytics from API
      final dashboardData = await _dataSource.getDashboardAnalytics(
        period: _selectedPeriod,
        branchId: _selectedBranchId != 'all' ? _selectedBranchId : null,
      );

      // Load additional data from API
      final revenueByBranchData = await _dataSource.getRevenueByBranch(
        period: _selectedPeriod,
      );
      final timeSeriesData = await _dataSource.getTimeSeriesData(
        period: _selectedPeriod,
      );
      final topServicesData = await _dataSource.getTopServices(
        period: _selectedPeriod,
      );
      final topCustomersData = await _dataSource.getTopCustomers(
        period: _selectedPeriod,
      );
      final staffPerformanceData = await _dataSource.getStaffPerformance(
        period: _selectedPeriod,
      );
      final recentActivityData = await _activityDataSource.getRecentActivity();

      // Update analytics data from API response
      _updateFromApiData(
        dashboardData,
        revenueByBranchData,
        timeSeriesData,
        topServicesData,
        topCustomersData,
        staffPerformanceData,
        recentActivityData,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading analytics: $e');
      // Fallback to local calculation if API fails
      _loadAnalyticsFromLocalData(orders, branches, staff);
    }
  }

  /// Update analytics data from API response
  void _updateFromApiData(
    Map<String, dynamic> dashboardData,
    List<Map<String, dynamic>> revenueByBranchData,
    List<Map<String, dynamic>> timeSeriesData,
    List<Map<String, dynamic>> topServicesData,
    List<Map<String, dynamic>> topCustomersData,
    List<Map<String, dynamic>> staffPerformanceData,
    List<Map<String, dynamic>> recentActivityData,
  ) {
    // Update dashboard metrics
    _totalRevenue = (dashboardData['total_revenue'] ?? 0.0).toDouble();
    _totalOrders = dashboardData['total_orders'] ?? 0;
    _completedOrders = dashboardData['completed_orders'] ?? 0;
    _pendingOrders = dashboardData['pending_orders'] ?? 0;
    _cancelledOrders = dashboardData['cancelled_orders'] ?? 0;
    _averageOrderValue =
        (dashboardData['average_order_value'] ?? 0.0).toDouble();
    _customerSatisfaction =
        (dashboardData['customer_satisfaction'] ?? 0.0).toDouble();
    _totalCustomers = dashboardData['total_customers'] ?? 0;
    _newCustomers = dashboardData['new_customers'] ?? 0;
    _deliveryTime = (dashboardData['average_delivery_time'] ?? 0.0).toDouble();
    _totalDeliveries = dashboardData['total_deliveries'] ?? 0;
    _staffEfficiency = (dashboardData['staff_efficiency'] ?? 0.0).toDouble();

    // Update revenue by branch
    _revenueByBranch.clear();
    for (final item in revenueByBranchData) {
      _revenueByBranch[item['branch_name'] ?? 'Unknown'] =
          (item['revenue'] ?? 0.0).toDouble();
    }

    // Update time series data
    _revenueByDay.clear();
    _ordersByDay.clear();
    for (final item in timeSeriesData) {
      final date = item['date'] ?? '';
      _revenueByDay[date] = (item['revenue'] ?? 0.0).toDouble();
      _ordersByDay[date] = item['orders'] ?? 0;
    }

    // Update top services
    _topServices = topServicesData;

    // Update top customers
    _topCustomers = topCustomersData;

    // Update staff performance
    _staffPerformance = staffPerformanceData;

    // Update recent activity
    _recentActivity = recentActivityData;
  }

  /// Fallback to local calculation if API fails
  void _loadAnalyticsFromLocalData(
    List<LaundretteOrder> orders,
    List<LaundretteBranch> branches,
    List<StaffMember> staff,
  ) {
      // Filter orders based on selected criteria
      final filteredOrders = _filterOrders(orders);

    // Calculate analytics from local data
      _calculateOrderMetrics(filteredOrders);
      _calculateRevenueMetrics(filteredOrders);
      _calculateCustomerMetrics(filteredOrders);
      _calculateDeliveryMetrics(filteredOrders);
      _calculateBranchMetrics(filteredOrders, branches);
      _calculateTimeSeriesData(filteredOrders);
      _calculateTopServices(filteredOrders);
      _calculateTopCustomers(filteredOrders);
      _calculateStaffPerformance(filteredOrders, staff);

      _isLoading = false;
      notifyListeners();
  }

  /// Filter orders based on selected criteria
  List<LaundretteOrder> _filterOrders(List<LaundretteOrder> orders) {
    var filtered = orders;

    // Filter by branch
    if (_selectedBranchId != 'all') {
      filtered =
          filtered
              .where((order) => order.branchId == _selectedBranchId)
              .toList();
    }

    // Filter by date range
    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedPeriod) {
      case 'day':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'week':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'year':
        startDate = DateTime(now.year, 1, 1);
        break;
      default:
        startDate = now.subtract(const Duration(days: 7));
    }

    filtered =
        filtered
            .where(
              (order) =>
                  order.createdAt.isAfter(startDate) &&
                  order.createdAt.isBefore(now.add(const Duration(days: 1))),
            )
            .toList();

    return filtered;
  }

  /// Calculate order-related metrics
  void _calculateOrderMetrics(List<LaundretteOrder> orders) {
    _totalOrders = orders.length;
    _completedOrders =
        orders.where((o) => o.status == LaundretteOrderStatus.delivered).length;
    _pendingOrders =
        orders
            .where(
              (o) =>
                  o.status == LaundretteOrderStatus.pending ||
                  o.status == LaundretteOrderStatus.approved ||
                  o.status == LaundretteOrderStatus.confirmed,
            )
            .length;
    _cancelledOrders =
        orders
            .where(
              (o) =>
                  o.status == LaundretteOrderStatus.cancelled ||
                  o.status == LaundretteOrderStatus.declined,
            )
            .length;
  }

  /// Calculate revenue-related metrics
  void _calculateRevenueMetrics(List<LaundretteOrder> orders) {
    _totalRevenue = orders.fold(0.0, (sum, order) => sum + order.total);
    _averageOrderValue = _totalOrders > 0 ? _totalRevenue / _totalOrders : 0.0;
  }

  /// Calculate customer-related metrics
  void _calculateCustomerMetrics(List<LaundretteOrder> orders) {
    final uniqueCustomers = orders.map((o) => o.customerId).toSet();
    _totalCustomers = uniqueCustomers.length;

    // Calculate new customers (orders from last 7 days)
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final recentOrders =
        orders.where((o) => o.createdAt.isAfter(weekAgo)).toList();
    final recentCustomers = recentOrders.map((o) => o.customerId).toSet();
    _newCustomers = recentCustomers.length;

    // Mock customer satisfaction (would come from ratings)
    _customerSatisfaction = 4.2; // Mock value
  }

  /// Calculate delivery-related metrics
  void _calculateDeliveryMetrics(List<LaundretteOrder> orders) {
    final deliveredOrders =
        orders
            .where(
              (o) =>
                  o.status == LaundretteOrderStatus.delivered &&
                  o.actualDeliveryTime != null,
            )
            .toList();

    _totalDeliveries = deliveredOrders.length;

    if (deliveredOrders.isNotEmpty) {
      double totalDeliveryTime = 0.0;
      for (final order in deliveredOrders) {
        if (order.actualDeliveryTime != null &&
            order.actualPickupTime != null) {
          final deliveryDuration = order.actualDeliveryTime!.difference(
            order.actualPickupTime!,
          );
          totalDeliveryTime += deliveryDuration.inMinutes.toDouble();
        }
      }
      _deliveryTime = totalDeliveryTime / deliveredOrders.length;
    }

    // Mock driver efficiency
    _staffEfficiency = 85.0; // Mock value
  }

  /// Calculate branch-specific metrics
  void _calculateBranchMetrics(
    List<LaundretteOrder> orders,
    List<LaundretteBranch> branches,
  ) {
    _revenueByBranch.clear();
    _ordersByBranch.clear();

    for (final branch in branches) {
      final branchOrders =
          orders.where((o) => o.branchId == branch.id).toList();
      _revenueByBranch[branch.name] = branchOrders.fold(
        0.0,
        (sum, order) => sum + order.total,
      );
      _ordersByBranch[branch.name] = branchOrders.length;
    }
  }

  /// Calculate time series data
  void _calculateTimeSeriesData(List<LaundretteOrder> orders) {
    _revenueByDay.clear();
    _ordersByDay.clear();

    // Group orders by day
    final ordersByDate = <String, List<LaundretteOrder>>{};
    for (final order in orders) {
      final dateKey =
          '${order.createdAt.year}-${order.createdAt.month.toString().padLeft(2, '0')}-${order.createdAt.day.toString().padLeft(2, '0')}';
      ordersByDate[dateKey] ??= [];
      ordersByDate[dateKey]!.add(order);
    }

    // Calculate daily metrics
    for (final entry in ordersByDate.entries) {
      _revenueByDay[entry.key] = entry.value.fold(
        0.0,
        (sum, order) => sum + order.total,
      );
      _ordersByDay[entry.key] = entry.value.length;
    }
  }

  /// Calculate top services
  void _calculateTopServices(List<LaundretteOrder> orders) {
    final serviceCount = <String, int>{};

    for (final order in orders) {
      for (final entry in order.orderItems.entries) {
        final service = entry.key;
        final quantity = entry.value as int? ?? 1;
        serviceCount[service] = (serviceCount[service] ?? 0) + quantity;
      }
    }

    _topServices =
        serviceCount.entries
            .map((e) => {'service': e.key, 'count': e.value})
            .toList()
          ..sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));
  }

  /// Calculate top customers
  void _calculateTopCustomers(List<LaundretteOrder> orders) {
    final customerOrders = <String, List<LaundretteOrder>>{};

    for (final order in orders) {
      customerOrders[order.customerId] ??= [];
      customerOrders[order.customerId]!.add(order);
    }

    _topCustomers =
        customerOrders.entries
            .map(
              (e) => {
                'customerId': e.key,
                'customerName': e.value.first.customerName,
                'orderCount': e.value.length,
                'totalSpent': e.value.fold(
                  0.0,
                  (sum, order) => sum + order.total,
                ),
              },
            )
            .toList()
          ..sort(
            (a, b) => (b['totalSpent'] as double).compareTo(
              a['totalSpent'] as double,
            ),
          );
  }

  /// Calculate staff performance
  void _calculateStaffPerformance(
    List<LaundretteOrder> orders,
    List<StaffMember> staff,
  ) {
    _staffPerformance.clear();

    for (final member in staff) {
      if (member.role == StaffRole.staff) {
        final driverOrders =
            orders.where((o) => o.driverId == member.id).toList();
        final completedOrders =
            driverOrders
                .where((o) => o.status == LaundretteOrderStatus.delivered)
                .length;

        _staffPerformance.add({
          'staffId': member.id,
          'name': member.fullName,
          'role': member.role.toString(),
          'totalOrders': driverOrders.length,
          'completedOrders': completedOrders,
          'completionRate':
              driverOrders.isNotEmpty
                  ? (completedOrders / driverOrders.length) * 100
                  : 0.0,
          'totalRevenue': driverOrders.fold(
            0.0,
            (sum, order) => sum + order.total,
          ),
        });
      }
    }

    _staffPerformance.sort(
      (a, b) => (b['completionRate'] as double).compareTo(
        a['completionRate'] as double,
      ),
    );
  }

  /// Update selected branch
  void updateSelectedBranch(String branchId) {
    _selectedBranchId = branchId;
    notifyListeners();
  }

  /// Update selected period
  void updateSelectedPeriod(String period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  /// Update selected date range
  void updateSelectedDateRange(DateTime dateRange) {
    _selectedDateRange = dateRange;
    notifyListeners();
  }

  /// Get completion rate
  double get completionRate {
    return _totalOrders > 0 ? (_completedOrders / _totalOrders) * 100 : 0.0;
  }

  /// Get cancellation rate
  double get cancellationRate {
    return _totalOrders > 0 ? (_cancelledOrders / _totalOrders) * 100 : 0.0;
  }

  /// Get average delivery time in minutes
  double get averageDeliveryTimeMinutes {
    return _deliveryTime;
  }

  /// Get average delivery time formatted
  String get averageDeliveryTimeFormatted {
    final hours = (_deliveryTime / 60).floor();
    final minutes = (_deliveryTime % 60).round();
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Update selected order status
  void updateSelectedOrderStatus(String status) {
    _selectedOrderStatus = status;
    notifyListeners();
  }

  /// Update start date
  void updateStartDate(DateTime date) {
    _startDate = date;
    notifyListeners();
  }

  /// Update end date
  void updateEndDate(DateTime date) {
    _endDate = date;
    notifyListeners();
  }

  /// Reset all filters
  void resetFilters() {
    _selectedBranchId = 'all';
    _selectedPeriod = 'week';
    _selectedOrderStatus = 'all';
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }
}
