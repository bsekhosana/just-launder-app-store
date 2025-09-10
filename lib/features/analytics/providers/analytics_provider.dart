import 'package:flutter/foundation.dart';
import '../../../data/models/laundrette_order.dart';
import '../../../data/models/laundrette_branch.dart';
import '../../../data/models/staff_member.dart';

class AnalyticsProvider with ChangeNotifier {
  bool _isLoading = false;
  DateTime _selectedDateRange = DateTime.now();
  String _selectedBranchId = 'all';
  String _selectedPeriod = 'week'; // day, week, month, year

  bool get isLoading => _isLoading;
  DateTime get selectedDateRange => _selectedDateRange;
  String get selectedBranchId => _selectedBranchId;
  String get selectedPeriod => _selectedPeriod;

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
  double _driverEfficiency = 0.0;
  Map<String, double> _revenueByBranch = {};
  Map<String, int> _ordersByBranch = {};
  Map<String, double> _revenueByDay = {};
  Map<String, int> _ordersByDay = {};
  List<Map<String, dynamic>> _topServices = [];
  List<Map<String, dynamic>> _topCustomers = [];
  List<Map<String, dynamic>> _staffPerformance = [];

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
  double get driverEfficiency => _driverEfficiency;
  Map<String, double> get revenueByBranch => _revenueByBranch;
  Map<String, int> get ordersByBranch => _ordersByBranch;
  Map<String, double> get revenueByDay => _revenueByDay;
  Map<String, int> get ordersByDay => _ordersByDay;
  List<Map<String, dynamic>> get topServices => _topServices;
  List<Map<String, dynamic>> get topCustomers => _topCustomers;
  List<Map<String, dynamic>> get staffPerformance => _staffPerformance;

  /// Load analytics data
  Future<void> loadAnalytics({
    required List<LaundretteOrder> orders,
    required List<LaundretteBranch> branches,
    required List<StaffMember> staff,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Filter orders based on selected criteria
      final filteredOrders = _filterOrders(orders);

      // Calculate analytics
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
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
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
    _driverEfficiency = 85.0; // Mock value
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
      if (member.role == StaffRole.driver) {
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
}
