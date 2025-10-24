/// Branch configuration model for payment and operational settings
class BranchConfigurationModel {
  final String branchId;
  final bool autoApproveOrders;
  
  // Business rules
  final bool enableBundleDiscount;
  final double bundleDiscountPercentage;
  final bool enableRushService;
  final double rushServiceFeePercentage;
  
  // Operational settings
  final int processingTimeHours;
  final double? minimumOrderValue;
  final double? maximumOrderValue;
  final double? serviceRadiusKm;
  final int maxConcurrentOrders;
  
  // Payment settings
  final bool acceptsOnlinePayments;
  final bool acceptsCashPayments;
  
  // Legacy fields (deprecated)
  final bool supportsPriorityDelivery;
  final double priorityDeliveryFee;
  final Map<String, double> servicePricing;
  final Map<String, double> bagPricing;
  
  final DateTime? updatedAt;

  const BranchConfigurationModel({
    required this.branchId,
    required this.autoApproveOrders,
    required this.enableBundleDiscount,
    required this.bundleDiscountPercentage,
    this.enableRushService = true,
    this.rushServiceFeePercentage = 50.0,
    this.processingTimeHours = 24,
    this.minimumOrderValue,
    this.maximumOrderValue,
    this.serviceRadiusKm,
    required this.maxConcurrentOrders,
    this.supportsPriorityDelivery = false,
    this.priorityDeliveryFee = 0.0,
    required this.acceptsOnlinePayments,
    required this.acceptsCashPayments,
    this.servicePricing = const {},
    this.bagPricing = const {},
    this.updatedAt,
  });

  factory BranchConfigurationModel.fromJson(Map<String, dynamic> json) {
    return BranchConfigurationModel(
      branchId: json['branch_id'].toString(),
      autoApproveOrders: json['auto_approve_orders'] as bool? ?? false,
      enableBundleDiscount: json['enable_bundle_discount'] as bool? ?? true,
      bundleDiscountPercentage:
          (json['bundle_discount_percentage'] as num?)?.toDouble() ?? 10.0,
      enableRushService: json['enable_rush_service'] as bool? ?? true,
      rushServiceFeePercentage:
          (json['rush_service_fee_percentage'] as num?)?.toDouble() ?? 50.0,
      processingTimeHours: json['processing_time_hours'] as int? ?? 24,
      minimumOrderValue:
          (json['minimum_order_value'] as num?)?.toDouble(),
      maximumOrderValue:
          (json['maximum_order_value'] as num?)?.toDouble(),
      serviceRadiusKm:
          (json['service_radius_km'] as num?)?.toDouble(),
      maxConcurrentOrders: json['max_concurrent_orders'] as int? ?? 50,
      supportsPriorityDelivery:
          json['supports_priority_delivery'] as bool? ?? false,
      priorityDeliveryFee:
          (json['priority_delivery_fee'] as num?)?.toDouble() ?? 0.0,
      acceptsOnlinePayments: json['accepts_online_payments'] as bool? ?? true,
      acceptsCashPayments: json['accepts_cash_payments'] as bool? ?? false,
      servicePricing: Map<String, double>.from(
        (json['service_pricing'] as Map?)?.map(
              (key, value) =>
                  MapEntry(key.toString(), (value as num).toDouble()),
            ) ??
            {},
      ),
      bagPricing: Map<String, double>.from(
        (json['bag_pricing'] as Map?)?.map(
              (key, value) =>
                  MapEntry(key.toString(), (value as num).toDouble()),
            ) ??
            {},
      ),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId,
      'auto_approve_orders': autoApproveOrders,
      'enable_bundle_discount': enableBundleDiscount,
      'bundle_discount_percentage': bundleDiscountPercentage,
      'enable_rush_service': enableRushService,
      'rush_service_fee_percentage': rushServiceFeePercentage,
      'processing_time_hours': processingTimeHours,
      'minimum_order_value': minimumOrderValue,
      'maximum_order_value': maximumOrderValue,
      'service_radius_km': serviceRadiusKm,
      'max_concurrent_orders': maxConcurrentOrders,
      'accepts_online_payments': acceptsOnlinePayments,
      'accepts_cash_payments': acceptsCashPayments,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  BranchConfigurationModel copyWith({
    String? branchId,
    bool? autoApproveOrders,
    bool? enableBundleDiscount,
    double? bundleDiscountPercentage,
    bool? enableRushService,
    double? rushServiceFeePercentage,
    int? processingTimeHours,
    double? minimumOrderValue,
    double? maximumOrderValue,
    double? serviceRadiusKm,
    int? maxConcurrentOrders,
    bool? acceptsOnlinePayments,
    bool? acceptsCashPayments,
    DateTime? updatedAt,
  }) {
    return BranchConfigurationModel(
      branchId: branchId ?? this.branchId,
      autoApproveOrders: autoApproveOrders ?? this.autoApproveOrders,
      enableBundleDiscount: enableBundleDiscount ?? this.enableBundleDiscount,
      bundleDiscountPercentage:
          bundleDiscountPercentage ?? this.bundleDiscountPercentage,
      enableRushService: enableRushService ?? this.enableRushService,
      rushServiceFeePercentage:
          rushServiceFeePercentage ?? this.rushServiceFeePercentage,
      processingTimeHours: processingTimeHours ?? this.processingTimeHours,
      minimumOrderValue: minimumOrderValue ?? this.minimumOrderValue,
      maximumOrderValue: maximumOrderValue ?? this.maximumOrderValue,
      serviceRadiusKm: serviceRadiusKm ?? this.serviceRadiusKm,
      maxConcurrentOrders: maxConcurrentOrders ?? this.maxConcurrentOrders,
      acceptsOnlinePayments:
          acceptsOnlinePayments ?? this.acceptsOnlinePayments,
      acceptsCashPayments: acceptsCashPayments ?? this.acceptsCashPayments,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Payment dashboard summary model
class PaymentDashboardModel {
  final double totalRevenue;
  final double todayRevenue;
  final double weekRevenue;
  final double monthRevenue;
  final double pendingPayouts;
  final double completedPayouts;
  final int totalOrders;
  final int paidOrders;
  final int pendingPaymentOrders;
  final int refundRequests;
  final List<RecentTransactionModel> recentTransactions;

  const PaymentDashboardModel({
    required this.totalRevenue,
    required this.todayRevenue,
    required this.weekRevenue,
    required this.monthRevenue,
    required this.pendingPayouts,
    required this.completedPayouts,
    required this.totalOrders,
    required this.paidOrders,
    required this.pendingPaymentOrders,
    required this.refundRequests,
    required this.recentTransactions,
  });

  factory PaymentDashboardModel.fromJson(Map<String, dynamic> json) {
    return PaymentDashboardModel(
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      todayRevenue: (json['today_revenue'] as num).toDouble(),
      weekRevenue: (json['week_revenue'] as num).toDouble(),
      monthRevenue: (json['month_revenue'] as num).toDouble(),
      pendingPayouts: (json['pending_payouts'] as num).toDouble(),
      completedPayouts: (json['completed_payouts'] as num).toDouble(),
      totalOrders: json['total_orders'] as int,
      paidOrders: json['paid_orders'] as int,
      pendingPaymentOrders: json['pending_payment_orders'] as int,
      refundRequests: json['refund_requests'] as int,
      recentTransactions:
          (json['recent_transactions'] as List?)
              ?.map((tx) => RecentTransactionModel.fromJson(tx))
              .toList() ??
          [],
    );
  }

  String get formattedTotalRevenue => '£${totalRevenue.toStringAsFixed(2)}';
  String get formattedTodayRevenue => '£${todayRevenue.toStringAsFixed(2)}';
  String get formattedWeekRevenue => '£${weekRevenue.toStringAsFixed(2)}';
  String get formattedMonthRevenue => '£${monthRevenue.toStringAsFixed(2)}';
}

/// Recent transaction model
class RecentTransactionModel {
  final String id;
  final String orderId;
  final String orderSlug;
  final double amount;
  final String type;
  final String status;
  final DateTime createdAt;

  const RecentTransactionModel({
    required this.id,
    required this.orderId,
    required this.orderSlug,
    required this.amount,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  factory RecentTransactionModel.fromJson(Map<String, dynamic> json) {
    return RecentTransactionModel(
      id: json['id'].toString(),
      orderId: json['order_id'].toString(),
      orderSlug: json['order_slug'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  String get formattedAmount => '£${amount.toStringAsFixed(2)}';

  bool get isCompleted => status == 'completed';
  bool get isPending => status == 'pending';
  bool get isFailed => status == 'failed';
}
