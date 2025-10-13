/// Branch configuration model for payment and operational settings
class BranchConfigurationModel {
  final String branchId;
  final bool autoApproveOrders;
  final bool enableBundleDiscount;
  final double bundleDiscountPercentage;
  final int maxConcurrentOrders;
  final bool supportsPriorityDelivery;
  final double priorityDeliveryFee;
  final bool acceptsOnlinePayments;
  final bool acceptsCashPayments;
  final Map<String, double> servicePricing;
  final Map<String, double> bagPricing;
  final DateTime? updatedAt;

  const BranchConfigurationModel({
    required this.branchId,
    required this.autoApproveOrders,
    required this.enableBundleDiscount,
    required this.bundleDiscountPercentage,
    required this.maxConcurrentOrders,
    required this.supportsPriorityDelivery,
    required this.priorityDeliveryFee,
    required this.acceptsOnlinePayments,
    required this.acceptsCashPayments,
    required this.servicePricing,
    required this.bagPricing,
    this.updatedAt,
  });

  factory BranchConfigurationModel.fromJson(Map<String, dynamic> json) {
    return BranchConfigurationModel(
      branchId: json['branch_id'].toString(),
      autoApproveOrders: json['auto_approve_orders'] as bool? ?? false,
      enableBundleDiscount: json['enable_bundle_discount'] as bool? ?? false,
      bundleDiscountPercentage:
          (json['bundle_discount_percentage'] as num?)?.toDouble() ?? 0.0,
      maxConcurrentOrders: json['max_concurrent_orders'] as int? ?? 50,
      supportsPriorityDelivery:
          json['supports_priority_delivery'] as bool? ?? false,
      priorityDeliveryFee:
          (json['priority_delivery_fee'] as num?)?.toDouble() ?? 0.0,
      acceptsOnlinePayments: json['accepts_online_payments'] as bool? ?? true,
      acceptsCashPayments: json['accepts_cash_payments'] as bool? ?? false,
      servicePricing: Map<String, double>.from(
        (json['service_pricing'] as Map?)?.map(
              (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
            ) ??
            {},
      ),
      bagPricing: Map<String, double>.from(
        (json['bag_pricing'] as Map?)?.map(
              (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
            ) ??
            {},
      ),
      updatedAt: json['updated_at'] != null
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
      'max_concurrent_orders': maxConcurrentOrders,
      'supports_priority_delivery': supportsPriorityDelivery,
      'priority_delivery_fee': priorityDeliveryFee,
      'accepts_online_payments': acceptsOnlinePayments,
      'accepts_cash_payments': acceptsCashPayments,
      'service_pricing': servicePricing,
      'bag_pricing': bagPricing,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  BranchConfigurationModel copyWith({
    String? branchId,
    bool? autoApproveOrders,
    bool? enableBundleDiscount,
    double? bundleDiscountPercentage,
    int? maxConcurrentOrders,
    bool? supportsPriorityDelivery,
    double? priorityDeliveryFee,
    bool? acceptsOnlinePayments,
    bool? acceptsCashPayments,
    Map<String, double>? servicePricing,
    Map<String, double>? bagPricing,
    DateTime? updatedAt,
  }) {
    return BranchConfigurationModel(
      branchId: branchId ?? this.branchId,
      autoApproveOrders: autoApproveOrders ?? this.autoApproveOrders,
      enableBundleDiscount: enableBundleDiscount ?? this.enableBundleDiscount,
      bundleDiscountPercentage:
          bundleDiscountPercentage ?? this.bundleDiscountPercentage,
      maxConcurrentOrders: maxConcurrentOrders ?? this.maxConcurrentOrders,
      supportsPriorityDelivery:
          supportsPriorityDelivery ?? this.supportsPriorityDelivery,
      priorityDeliveryFee: priorityDeliveryFee ?? this.priorityDeliveryFee,
      acceptsOnlinePayments:
          acceptsOnlinePayments ?? this.acceptsOnlinePayments,
      acceptsCashPayments: acceptsCashPayments ?? this.acceptsCashPayments,
      servicePricing: servicePricing ?? this.servicePricing,
      bagPricing: bagPricing ?? this.bagPricing,
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
      recentTransactions: (json['recent_transactions'] as List?)
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

