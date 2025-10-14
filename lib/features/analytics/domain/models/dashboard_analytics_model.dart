class DashboardAnalyticsModel {
  final int totalOrders;
  final int completedOrders;
  final int pendingOrders;
  final int cancelledOrders;
  final double totalRevenue;
  final double averageOrderValue;
  final int totalCustomers;
  final int newCustomers;
  final double averageDeliveryTime;
  final double customerSatisfaction;
  final double completionRate;
  final double cancellationRate;
  final String period;
  final String startDate;
  final String endDate;

  DashboardAnalyticsModel({
    required this.totalOrders,
    required this.completedOrders,
    required this.pendingOrders,
    required this.cancelledOrders,
    required this.totalRevenue,
    required this.averageOrderValue,
    required this.totalCustomers,
    required this.newCustomers,
    required this.averageDeliveryTime,
    required this.customerSatisfaction,
    required this.completionRate,
    required this.cancellationRate,
    required this.period,
    required this.startDate,
    required this.endDate,
  });

  factory DashboardAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return DashboardAnalyticsModel(
      totalOrders: json['total_orders'] ?? 0,
      completedOrders: json['completed_orders'] ?? 0,
      pendingOrders: json['pending_orders'] ?? 0,
      cancelledOrders: json['cancelled_orders'] ?? 0,
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      averageOrderValue: (json['average_order_value'] ?? 0).toDouble(),
      totalCustomers: json['total_customers'] ?? 0,
      newCustomers: json['new_customers'] ?? 0,
      averageDeliveryTime: (json['average_delivery_time'] ?? 0).toDouble(),
      customerSatisfaction: (json['customer_satisfaction'] ?? 0).toDouble(),
      completionRate: (json['completion_rate'] ?? 0).toDouble(),
      cancellationRate: (json['cancellation_rate'] ?? 0).toDouble(),
      period: json['period'] ?? 'week',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_orders': totalOrders,
      'completed_orders': completedOrders,
      'pending_orders': pendingOrders,
      'cancelled_orders': cancelledOrders,
      'total_revenue': totalRevenue,
      'average_order_value': averageOrderValue,
      'total_customers': totalCustomers,
      'new_customers': newCustomers,
      'average_delivery_time': averageDeliveryTime,
      'customer_satisfaction': customerSatisfaction,
      'completion_rate': completionRate,
      'cancellation_rate': cancellationRate,
      'period': period,
      'start_date': startDate,
      'end_date': endDate,
    };
  }

  String get averageDeliveryTimeFormatted {
    final hours = (averageDeliveryTime / 60).floor();
    final minutes = (averageDeliveryTime % 60).round();
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

