import 'package:equatable/equatable.dart';

/// Order status from tenant perspective
enum TenantOrderStatus {
  pending,
  confirmed,
  pickedUp,
  inProgress,
  readyForDelivery,
  outForDelivery,
  delivered,
  completed,
  cancelled,
  onHold,
  returned,
}

/// Order priority levels
enum OrderPriority { normal, high, urgent, express }

/// Payment status
enum PaymentStatus { pending, paid, failed, refunded, partiallyRefunded }

/// Order tag types
enum OrderTagType { location, status, priority, service, custom }

/// Order tag model
class OrderTagModel extends Equatable {
  final String id;
  final String orderId;
  final OrderTagType type;
  final String value;
  final String? description;
  final DateTime createdAt;

  const OrderTagModel({
    required this.id,
    required this.orderId,
    required this.type,
    required this.value,
    this.description,
    required this.createdAt,
  });

  factory OrderTagModel.fromJson(Map<String, dynamic> json) {
    return OrderTagModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      type: OrderTagType.values.firstWhere(
        (e) => e.name == json['tag_type'],
        orElse: () => OrderTagType.custom,
      ),
      value: json['tag_value'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'tag_type': type.name,
      'tag_value': value,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, orderId, type, value, description, createdAt];
}

/// Order status history model
class OrderStatusHistoryModel extends Equatable {
  final String id;
  final String orderId;
  final TenantOrderStatus status;
  final String? notes;
  final String? changedByType;
  final String? changedById;
  final DateTime statusChangedAt;

  const OrderStatusHistoryModel({
    required this.id,
    required this.orderId,
    required this.status,
    this.notes,
    this.changedByType,
    this.changedById,
    required this.statusChangedAt,
  });

  factory OrderStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusHistoryModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      status: TenantOrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TenantOrderStatus.pending,
      ),
      notes: json['notes'] as String?,
      changedByType: json['changed_by_type'] as String?,
      changedById: json['changed_by_id'] as String?,
      statusChangedAt: DateTime.parse(json['status_changed_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'status': status.name,
      'notes': notes,
      'changed_by_type': changedByType,
      'changed_by_id': changedById,
      'status_changed_at': statusChangedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    orderId,
    status,
    notes,
    changedByType,
    changedById,
    statusChangedAt,
  ];
}

/// Order assignment model
class OrderAssignmentModel extends Equatable {
  final String id;
  final String orderId;
  final String driverId;
  final DateTime assignedAt;
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;
  final String? rejectionReason;
  final String status;

  const OrderAssignmentModel({
    required this.id,
    required this.orderId,
    required this.driverId,
    required this.assignedAt,
    this.acceptedAt,
    this.rejectedAt,
    this.rejectionReason,
    required this.status,
  });

  factory OrderAssignmentModel.fromJson(Map<String, dynamic> json) {
    return OrderAssignmentModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      driverId: json['driver_id'] as String,
      assignedAt: DateTime.parse(json['assigned_at'] as String),
      acceptedAt:
          json['accepted_at'] != null
              ? DateTime.parse(json['accepted_at'] as String)
              : null,
      rejectedAt:
          json['rejected_at'] != null
              ? DateTime.parse(json['rejected_at'] as String)
              : null,
      rejectionReason: json['rejection_reason'] as String?,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'driver_id': driverId,
      'assigned_at': assignedAt.toIso8601String(),
      'accepted_at': acceptedAt?.toIso8601String(),
      'rejected_at': rejectedAt?.toIso8601String(),
      'rejection_reason': rejectionReason,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [
    id,
    orderId,
    driverId,
    assignedAt,
    acceptedAt,
    rejectedAt,
    rejectionReason,
    status,
  ];
}

/// Order item model
class OrderItemModel extends Equatable {
  final String id;
  final String orderId;
  final String itemType;
  final double weight;
  final List<String> services;
  final double price;
  final Map<String, dynamic> metadata;

  const OrderItemModel({
    required this.id,
    required this.orderId,
    required this.itemType,
    required this.weight,
    required this.services,
    required this.price,
    required this.metadata,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      itemType: json['item_type'] as String,
      weight: (json['weight'] as num).toDouble(),
      services: List<String>.from(json['services'] as List),
      price: (json['price'] as num).toDouble(),
      metadata: Map<String, dynamic>.from(json['metadata'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'item_type': itemType,
      'weight': weight,
      'services': services,
      'price': price,
      'metadata': metadata,
    };
  }

  @override
  List<Object?> get props => [
    id,
    orderId,
    itemType,
    weight,
    services,
    price,
    metadata,
  ];
}

/// Tenant order model
class TenantOrderModel extends Equatable {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String branchId;
  final String branchName;
  final TenantOrderStatus status;
  final OrderPriority priority;
  final PaymentStatus paymentStatus;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String? notes;
  final String? specialInstructions;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? scheduledPickupTime;
  final DateTime? actualPickupTime;
  final DateTime? estimatedDeliveryTime;
  final DateTime? actualDeliveryTime;
  final String? pickupAddress;
  final String? deliveryAddress;
  final List<OrderItemModel> orderItems;
  final List<OrderTagModel> tags;
  final List<OrderStatusHistoryModel> statusHistory;
  final List<OrderAssignmentModel> assignments;
  final Map<String, dynamic> metadata;

  const TenantOrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.branchId,
    required this.branchName,
    required this.status,
    required this.priority,
    required this.paymentStatus,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    this.notes,
    this.specialInstructions,
    this.driverId,
    this.driverName,
    this.driverPhone,
    required this.createdAt,
    required this.updatedAt,
    this.scheduledPickupTime,
    this.actualPickupTime,
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.pickupAddress,
    this.deliveryAddress,
    required this.orderItems,
    required this.tags,
    required this.statusHistory,
    required this.assignments,
    required this.metadata,
  });

  /// Check if order is pending approval
  bool get isPendingApproval => status == TenantOrderStatus.pending;

  /// Check if order is confirmed
  bool get isConfirmed => status == TenantOrderStatus.confirmed;

  /// Check if order is picked up
  bool get isPickedUp => status == TenantOrderStatus.pickedUp;

  /// Check if order is in progress
  bool get isInProgress => status == TenantOrderStatus.inProgress;

  /// Check if order is ready for delivery
  bool get isReadyForDelivery => status == TenantOrderStatus.readyForDelivery;

  /// Check if order is out for delivery
  bool get isOutForDelivery => status == TenantOrderStatus.outForDelivery;

  /// Check if order is delivered
  bool get isDelivered => status == TenantOrderStatus.delivered;

  /// Check if order is completed
  bool get isCompleted => status == TenantOrderStatus.completed;

  /// Check if order is cancelled
  bool get isCancelled => status == TenantOrderStatus.cancelled;

  /// Check if order is on hold
  bool get isOnHold => status == TenantOrderStatus.onHold;

  /// Check if order is returned
  bool get isReturned => status == TenantOrderStatus.returned;

  /// Check if order is high priority
  bool get isHighPriority =>
      priority == OrderPriority.high || priority == OrderPriority.urgent;

  /// Check if payment is completed
  bool get isPaid => paymentStatus == PaymentStatus.paid;

  /// Get order age in hours
  int get orderAgeHours {
    return DateTime.now().difference(createdAt).inHours;
  }

  /// Get estimated completion time
  DateTime? get estimatedCompletionTime {
    if (actualPickupTime != null) {
      // Add processing time based on priority
      final processingHours =
          priority == OrderPriority.express
              ? 6
              : priority == OrderPriority.urgent
              ? 12
              : priority == OrderPriority.high
              ? 18
              : 24;
      return actualPickupTime!.add(Duration(hours: processingHours));
    }
    return null;
  }

  /// Get status display text
  String get statusDisplayText {
    switch (status) {
      case TenantOrderStatus.pending:
        return 'Pending';
      case TenantOrderStatus.confirmed:
        return 'Confirmed';
      case TenantOrderStatus.pickedUp:
        return 'Picked Up';
      case TenantOrderStatus.inProgress:
        return 'In Progress';
      case TenantOrderStatus.readyForDelivery:
        return 'Ready for Delivery';
      case TenantOrderStatus.outForDelivery:
        return 'Out for Delivery';
      case TenantOrderStatus.delivered:
        return 'Delivered';
      case TenantOrderStatus.completed:
        return 'Completed';
      case TenantOrderStatus.cancelled:
        return 'Cancelled';
      case TenantOrderStatus.onHold:
        return 'On Hold';
      case TenantOrderStatus.returned:
        return 'Returned';
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
      case OrderPriority.express:
        return 'Express';
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
      case PaymentStatus.partiallyRefunded:
        return 'Partially Refunded';
    }
  }

  /// Get status color
  String get statusColor {
    switch (status) {
      case TenantOrderStatus.pending:
        return 'warning';
      case TenantOrderStatus.confirmed:
        return 'info';
      case TenantOrderStatus.pickedUp:
        return 'primary';
      case TenantOrderStatus.inProgress:
        return 'success';
      case TenantOrderStatus.readyForDelivery:
        return 'warning';
      case TenantOrderStatus.outForDelivery:
        return 'primary';
      case TenantOrderStatus.delivered:
        return 'success';
      case TenantOrderStatus.completed:
        return 'success';
      case TenantOrderStatus.cancelled:
        return 'error';
      case TenantOrderStatus.onHold:
        return 'warning';
      case TenantOrderStatus.returned:
        return 'error';
    }
  }

  /// Get priority color
  String get priorityColor {
    switch (priority) {
      case OrderPriority.normal:
        return 'neutral';
      case OrderPriority.high:
        return 'warning';
      case OrderPriority.urgent:
        return 'error';
      case OrderPriority.express:
        return 'primary';
    }
  }

  /// Get payment status color
  String get paymentStatusColor {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return 'warning';
      case PaymentStatus.paid:
        return 'success';
      case PaymentStatus.failed:
        return 'error';
      case PaymentStatus.refunded:
        return 'neutral';
      case PaymentStatus.partiallyRefunded:
        return 'warning';
    }
  }

  /// Get tags by type
  List<OrderTagModel> getTagsByType(OrderTagType type) {
    return tags.where((tag) => tag.type == type).toList();
  }

  /// Get location tags
  List<OrderTagModel> get locationTags => getTagsByType(OrderTagType.location);

  /// Get status tags
  List<OrderTagModel> get statusTags => getTagsByType(OrderTagType.status);

  /// Get priority tags
  List<OrderTagModel> get priorityTags => getTagsByType(OrderTagType.priority);

  /// Get service tags
  List<OrderTagModel> get serviceTags => getTagsByType(OrderTagType.service);

  /// Get custom tags
  List<OrderTagModel> get customTags => getTagsByType(OrderTagType.custom);

  /// Create TenantOrderModel from JSON
  factory TenantOrderModel.fromJson(Map<String, dynamic> json) {
    return TenantOrderModel(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      customerName: json['customer_name'] as String,
      customerPhone: json['customer_phone'] as String,
      customerEmail: json['customer_email'] as String,
      branchId: json['branch_id'] as String,
      branchName: json['branch_name'] as String,
      status: TenantOrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TenantOrderStatus.pending,
      ),
      priority: OrderPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => OrderPriority.normal,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == json['payment_status'],
        orElse: () => PaymentStatus.pending,
      ),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['delivery_fee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      notes: json['notes'] as String?,
      specialInstructions: json['special_instructions'] as String?,
      driverId: json['driver_id'] as String?,
      driverName: json['driver_name'] as String?,
      driverPhone: json['driver_phone'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      scheduledPickupTime:
          json['scheduled_pickup_time'] != null
              ? DateTime.parse(json['scheduled_pickup_time'] as String)
              : null,
      actualPickupTime:
          json['actual_pickup_time'] != null
              ? DateTime.parse(json['actual_pickup_time'] as String)
              : null,
      estimatedDeliveryTime:
          json['estimated_delivery_time'] != null
              ? DateTime.parse(json['estimated_delivery_time'] as String)
              : null,
      actualDeliveryTime:
          json['actual_delivery_time'] != null
              ? DateTime.parse(json['actual_delivery_time'] as String)
              : null,
      pickupAddress: json['pickup_address'] as String?,
      deliveryAddress: json['delivery_address'] as String?,
      orderItems:
          (json['order_items'] as List?)
              ?.map(
                (item) => OrderItemModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      tags:
          (json['tags'] as List?)
              ?.map(
                (tag) => OrderTagModel.fromJson(tag as Map<String, dynamic>),
              )
              .toList() ??
          [],
      statusHistory:
          (json['status_history'] as List?)
              ?.map(
                (history) => OrderStatusHistoryModel.fromJson(
                  history as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      assignments:
          (json['assignments'] as List?)
              ?.map(
                (assignment) => OrderAssignmentModel.fromJson(
                  assignment as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  /// Convert TenantOrderModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_email': customerEmail,
      'branch_id': branchId,
      'branch_name': branchName,
      'status': status.name,
      'priority': priority.name,
      'payment_status': paymentStatus.name,
      'subtotal': subtotal,
      'delivery_fee': deliveryFee,
      'total': total,
      'notes': notes,
      'special_instructions': specialInstructions,
      'driver_id': driverId,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'scheduled_pickup_time': scheduledPickupTime?.toIso8601String(),
      'actual_pickup_time': actualPickupTime?.toIso8601String(),
      'estimated_delivery_time': estimatedDeliveryTime?.toIso8601String(),
      'actual_delivery_time': actualDeliveryTime?.toIso8601String(),
      'pickup_address': pickupAddress,
      'delivery_address': deliveryAddress,
      'order_items': orderItems.map((item) => item.toJson()).toList(),
      'tags': tags.map((tag) => tag.toJson()).toList(),
      'status_history':
          statusHistory.map((history) => history.toJson()).toList(),
      'assignments':
          assignments.map((assignment) => assignment.toJson()).toList(),
      'metadata': metadata,
    };
  }

  /// Create a copy of TenantOrderModel with updated fields
  TenantOrderModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? branchId,
    String? branchName,
    TenantOrderStatus? status,
    OrderPriority? priority,
    PaymentStatus? paymentStatus,
    double? subtotal,
    double? deliveryFee,
    double? total,
    String? notes,
    String? specialInstructions,
    String? driverId,
    String? driverName,
    String? driverPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? scheduledPickupTime,
    DateTime? actualPickupTime,
    DateTime? estimatedDeliveryTime,
    DateTime? actualDeliveryTime,
    String? pickupAddress,
    String? deliveryAddress,
    List<OrderItemModel>? orderItems,
    List<OrderTagModel>? tags,
    List<OrderStatusHistoryModel>? statusHistory,
    List<OrderAssignmentModel>? assignments,
    Map<String, dynamic>? metadata,
  }) {
    return TenantOrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      notes: notes ?? this.notes,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      scheduledPickupTime: scheduledPickupTime ?? this.scheduledPickupTime,
      actualPickupTime: actualPickupTime ?? this.actualPickupTime,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      actualDeliveryTime: actualDeliveryTime ?? this.actualDeliveryTime,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      orderItems: orderItems ?? this.orderItems,
      tags: tags ?? this.tags,
      statusHistory: statusHistory ?? this.statusHistory,
      assignments: assignments ?? this.assignments,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
    id,
    customerId,
    customerName,
    customerPhone,
    customerEmail,
    branchId,
    branchName,
    status,
    priority,
    paymentStatus,
    subtotal,
    deliveryFee,
    total,
    notes,
    specialInstructions,
    driverId,
    driverName,
    driverPhone,
    createdAt,
    updatedAt,
    scheduledPickupTime,
    actualPickupTime,
    estimatedDeliveryTime,
    actualDeliveryTime,
    pickupAddress,
    deliveryAddress,
    orderItems,
    tags,
    statusHistory,
    assignments,
    metadata,
  ];
}
