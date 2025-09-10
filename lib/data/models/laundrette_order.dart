import 'package:equatable/equatable.dart';

/// Order status from laundrette perspective
enum LaundretteOrderStatus {
  pending,        // Order received, waiting for approval
  approved,       // Order approved by laundrette
  declined,       // Order declined by laundrette
  confirmed,      // Order confirmed and scheduled
  pickedUp,       // Order picked up from customer
  inProgress,     // Order being processed
  ready,          // Order ready for delivery
  outForDelivery, // Order out for delivery
  delivered,      // Order delivered to customer
  cancelled,      // Order cancelled
}

/// Priority levels for orders
enum OrderPriority {
  normal,
  high,
  urgent,
}

/// Payment status
enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

/// Laundrette order model representing an order from laundrette perspective
class LaundretteOrder extends Equatable {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String branchId;
  final String branchName;
  final LaundretteOrderStatus status;
  final OrderPriority priority;
  final PaymentStatus paymentStatus;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String? declineReason;
  final String? notes;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final DateTime createdAt;
  final DateTime? scheduledPickupTime;
  final DateTime? actualPickupTime;
  final DateTime? estimatedDeliveryTime;
  final DateTime? actualDeliveryTime;
  final String? pickupAddress;
  final String? deliveryAddress;
  final Map<String, dynamic> orderItems; // Bag details and services
  final Map<String, dynamic> metadata;
  final DateTime updatedAt;

  const LaundretteOrder({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.branchId,
    required this.branchName,
    required this.status,
    required this.priority,
    required this.paymentStatus,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    this.declineReason,
    this.notes,
    this.driverId,
    this.driverName,
    this.driverPhone,
    required this.createdAt,
    this.scheduledPickupTime,
    this.actualPickupTime,
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.pickupAddress,
    this.deliveryAddress,
    required this.orderItems,
    required this.metadata,
    required this.updatedAt,
  });

  /// Check if order is pending approval
  bool get isPendingApproval => status == LaundretteOrderStatus.pending;

  /// Check if order is approved
  bool get isApproved => status == LaundretteOrderStatus.approved;

  /// Check if order is declined
  bool get isDeclined => status == LaundretteOrderStatus.declined;

  /// Check if order is in progress
  bool get isInProgress => status == LaundretteOrderStatus.inProgress;

  /// Check if order is completed
  bool get isCompleted => status == LaundretteOrderStatus.delivered;

  /// Check if order is cancelled
  bool get isCancelled => status == LaundretteOrderStatus.cancelled;

  /// Check if order is high priority
  bool get isHighPriority => priority == OrderPriority.high || priority == OrderPriority.urgent;

  /// Check if payment is completed
  bool get isPaid => paymentStatus == PaymentStatus.paid;

  /// Get order age in hours
  int get orderAgeHours {
    return DateTime.now().difference(createdAt).inHours;
  }

  /// Get estimated completion time
  DateTime? get estimatedCompletionTime {
    if (actualPickupTime != null) {
      // Add 24-48 hours for processing
      final processingHours = priority == OrderPriority.urgent ? 12 : 
                             priority == OrderPriority.high ? 18 : 24;
      return actualPickupTime!.add(Duration(hours: processingHours));
    }
    return null;
  }

  /// Get status display text
  String get statusDisplayText {
    switch (status) {
      case LaundretteOrderStatus.pending:
        return 'Pending Approval';
      case LaundretteOrderStatus.approved:
        return 'Approved';
      case LaundretteOrderStatus.declined:
        return 'Declined';
      case LaundretteOrderStatus.confirmed:
        return 'Confirmed';
      case LaundretteOrderStatus.pickedUp:
        return 'Picked Up';
      case LaundretteOrderStatus.inProgress:
        return 'In Progress';
      case LaundretteOrderStatus.ready:
        return 'Ready';
      case LaundretteOrderStatus.outForDelivery:
        return 'Out for Delivery';
      case LaundretteOrderStatus.delivered:
        return 'Delivered';
      case LaundretteOrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Get priority display text
  String get priorityDisplayText {
    switch (priority) {
      case OrderPriority.normal:
        return 'Normal';
      case OrderPriority.high:
        return 'High';
      case OrderPriority.urgent:
        return 'Urgent';
    }
  }

  /// Get payment status display text
  String get paymentStatusDisplayText {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }

  /// Get metadata value by key
  dynamic getMetadata(String key) => metadata[key];

  /// Set metadata value
  Map<String, dynamic> updateMetadata(String key, dynamic value) {
    final updatedMetadata = Map<String, dynamic>.from(metadata);
    updatedMetadata[key] = value;
    return updatedMetadata;
  }

  /// Create LaundretteOrder from JSON
  factory LaundretteOrder.fromJson(Map<String, dynamic> json) {
    return LaundretteOrder(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      branchId: json['branchId'] as String,
      branchName: json['branchName'] as String,
      status: LaundretteOrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => LaundretteOrderStatus.pending,
      ),
      priority: OrderPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => OrderPriority.normal,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == json['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      declineReason: json['declineReason'] as String?,
      notes: json['notes'] as String?,
      driverId: json['driverId'] as String?,
      driverName: json['driverName'] as String?,
      driverPhone: json['driverPhone'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      scheduledPickupTime: json['scheduledPickupTime'] != null
          ? DateTime.parse(json['scheduledPickupTime'] as String)
          : null,
      actualPickupTime: json['actualPickupTime'] != null
          ? DateTime.parse(json['actualPickupTime'] as String)
          : null,
      estimatedDeliveryTime: json['estimatedDeliveryTime'] != null
          ? DateTime.parse(json['estimatedDeliveryTime'] as String)
          : null,
      actualDeliveryTime: json['actualDeliveryTime'] != null
          ? DateTime.parse(json['actualDeliveryTime'] as String)
          : null,
      pickupAddress: json['pickupAddress'] as String?,
      deliveryAddress: json['deliveryAddress'] as String?,
      orderItems: Map<String, dynamic>.from(json['orderItems'] as Map),
      metadata: Map<String, dynamic>.from(json['metadata'] as Map),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert LaundretteOrder to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'branchId': branchId,
      'branchName': branchName,
      'status': status.name,
      'priority': priority.name,
      'paymentStatus': paymentStatus.name,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'declineReason': declineReason,
      'notes': notes,
      'driverId': driverId,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'createdAt': createdAt.toIso8601String(),
      'scheduledPickupTime': scheduledPickupTime?.toIso8601String(),
      'actualPickupTime': actualPickupTime?.toIso8601String(),
      'estimatedDeliveryTime': estimatedDeliveryTime?.toIso8601String(),
      'actualDeliveryTime': actualDeliveryTime?.toIso8601String(),
      'pickupAddress': pickupAddress,
      'deliveryAddress': deliveryAddress,
      'orderItems': orderItems,
      'metadata': metadata,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy of LaundretteOrder with updated fields
  LaundretteOrder copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? branchId,
    String? branchName,
    LaundretteOrderStatus? status,
    OrderPriority? priority,
    PaymentStatus? paymentStatus,
    double? subtotal,
    double? deliveryFee,
    double? total,
    String? declineReason,
    String? notes,
    String? driverId,
    String? driverName,
    String? driverPhone,
    DateTime? createdAt,
    DateTime? scheduledPickupTime,
    DateTime? actualPickupTime,
    DateTime? estimatedDeliveryTime,
    DateTime? actualDeliveryTime,
    String? pickupAddress,
    String? deliveryAddress,
    Map<String, dynamic>? orderItems,
    Map<String, dynamic>? metadata,
    DateTime? updatedAt,
  }) {
    return LaundretteOrder(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      declineReason: declineReason ?? this.declineReason,
      notes: notes ?? this.notes,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      createdAt: createdAt ?? this.createdAt,
      scheduledPickupTime: scheduledPickupTime ?? this.scheduledPickupTime,
      actualPickupTime: actualPickupTime ?? this.actualPickupTime,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      actualDeliveryTime: actualDeliveryTime ?? this.actualDeliveryTime,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      orderItems: orderItems ?? this.orderItems,
      metadata: metadata ?? this.metadata,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        customerId,
        customerName,
        customerPhone,
        branchId,
        branchName,
        status,
        priority,
        paymentStatus,
        subtotal,
        deliveryFee,
        total,
        declineReason,
        notes,
        driverId,
        driverName,
        driverPhone,
        createdAt,
        scheduledPickupTime,
        actualPickupTime,
        estimatedDeliveryTime,
        actualDeliveryTime,
        pickupAddress,
        deliveryAddress,
        orderItems,
        metadata,
        updatedAt,
      ];
}
