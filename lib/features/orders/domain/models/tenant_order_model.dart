import 'package:equatable/equatable.dart';

/// Order status enum matching backend OrderStatus enum
enum TenantOrderStatus {
  pending,
  paid,
  awaitingApproval,
  approvalExpired,
  poorResponseTime,
  approved,
  declined,
  modified,
  inProgress,
  assigned,
  pickedUp,
  processing,
  ready,
  outForDelivery,
  delivered,
  cancelled,
  processingRefund,
  expired,
  extensionRequested,
  extensionApproved,
  extensionDeclined,
}

/// Order priority enum
enum OrderPriority { low, normal, high, urgent }

/// Payment status enum
enum PaymentStatus { pending, paid, failed, refunded, partiallyRefunded }

/// Order tag type enum
enum OrderTagType { location, status, priority, service, custom }

class TenantOrderModel extends Equatable {
  final String id;
  final String orderNumber;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String branchId;
  final String branchName;
  final TenantOrderStatus status;
  final OrderPriority priority;
  final PaymentStatus paymentStatus;
  final List<OrderItemModel> items;
  final double totalAmount;
  final double subtotal;
  final double deliveryFee;
  // Address fields - can be either ID or full address object
  final String? addressId; // Delivery address ID
  final String? pickupAddressId; // Pickup address ID
  final String pickupAddress; // Fallback string representation
  final String deliveryAddress; // Fallback string representation
  final DateTime pickupDate;
  final DateTime deliveryDate;
  final String? notes;
  final String? specialInstructions;
  // Driver fields - support both pickup and delivery drivers
  final String? deliveryDriverId;
  final String? pickupDriverId;
  final String? driverId; // For backward compatibility
  final String? driverName;
  final String? driverPhone;
  final List<OrderTagModel> tags;
  final List<OrderStatusHistoryModel> statusHistory;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TenantOrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.branchId,
    required this.branchName,
    required this.status,
    this.priority = OrderPriority.normal,
    this.paymentStatus = PaymentStatus.pending,
    required this.items,
    required this.totalAmount,
    this.subtotal = 0.0,
    this.deliveryFee = 0.0,
    this.addressId,
    this.pickupAddressId,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.pickupDate,
    required this.deliveryDate,
    this.notes,
    this.specialInstructions,
    this.deliveryDriverId,
    this.pickupDriverId,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.tags = const [],
    this.statusHistory = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory TenantOrderModel.fromJson(Map<String, dynamic> json) {
    return TenantOrderModel(
      id: json['id']?.toString() ?? '',
      orderNumber:
          json['order_number'] as String? ?? json['slug'] as String? ?? '',
      customerId: json['customer_id']?.toString() ?? '',
      customerName: json['customer_name'] as String? ?? 'Unknown',
      customerEmail: json['customer_email'] as String? ?? '',
      customerPhone: json['customer_phone'] as String? ?? '',
      branchId: json['branch_id']?.toString() ?? '',
      branchName: json['branch_name'] as String? ?? '',
      status: _parseOrderStatus(json['status']),
      priority: _parsePriority(json['priority']),
      paymentStatus: _parsePaymentStatus(json['payment_status']),
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (item) => OrderItemModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          (json['order_items'] as List<dynamic>?)
              ?.map(
                (item) => OrderItemModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      subtotal:
          (json['subtotal'] as num?)?.toDouble() ??
          (json['total_amount'] as num?)?.toDouble() ??
          0.0,
      deliveryFee:
          (json['delivery_fee'] as num?)?.toDouble() ??
          (json['pickup_fee'] as num?)?.toDouble() ??
          0.0,
      // Handle address IDs
      addressId: json['address_id']?.toString(),
      pickupAddressId: json['pickup_address_id']?.toString(),
      // Handle address objects or fallback to strings
      pickupAddress: _extractAddress(json, 'pickup_address'),
      deliveryAddress: _extractAddress(
        json,
        'delivery_address',
        addressKey: 'address',
      ),
      pickupDate:
          json['pickup_date'] != null
              ? DateTime.parse(json['pickup_date'] as String)
              : (json['pickup_time'] != null
                  ? DateTime.parse(json['pickup_time'] as String)
                  : DateTime.now()),
      deliveryDate:
          json['delivery_date'] != null
              ? DateTime.parse(json['delivery_date'] as String)
              : (json['delivery_time'] != null
                  ? DateTime.parse(json['delivery_time'] as String)
                  : DateTime.now().add(const Duration(days: 1))),
      notes: json['notes'] as String?,
      specialInstructions: json['special_instructions'] as String?,
      // Handle driver IDs - support both old and new structure
      deliveryDriverId: json['delivery_driver_id']?.toString(),
      pickupDriverId: json['pickup_driver_id']?.toString(),
      driverId:
          json['driver_id']?.toString() ??
          json['delivery_driver_id']?.toString(),
      driverName:
          json['driver_name'] as String? ??
          _extractDriverName(json, 'delivery_driver'),
      driverPhone:
          json['driver_phone'] as String? ??
          _extractDriverPhone(json, 'delivery_driver'),
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map(
                (tag) => OrderTagModel.fromJson(tag as Map<String, dynamic>),
              )
              .toList() ??
          [],
      statusHistory:
          (json['status_history'] as List<dynamic>?)
              ?.map(
                (history) => OrderStatusHistoryModel.fromJson(
                  history as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : DateTime.now(),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : DateTime.now(),
    );
  }

  /// Extract address from JSON - handles both string and object formats
  static String _extractAddress(
    Map<String, dynamic> json,
    String key, {
    String? addressKey,
  }) {
    // Try direct string field first
    if (json[key] is String) {
      return json[key] as String;
    }

    // Try address object
    final addressData = json[addressKey ?? key];
    if (addressData is Map<String, dynamic>) {
      // Build address string from components
      final parts =
          <String>[
            addressData['house_number'] ?? '',
            addressData['street'] ?? addressData['address_line_1'] ?? '',
            addressData['address_line_2'] ?? '',
            addressData['city'] ?? '',
            addressData['postal_code'] ?? addressData['postcode'] ?? '',
          ].where((p) => p.toString().isNotEmpty).toList();

      return parts.join(', ');
    }

    return '';
  }

  /// Extract driver name from driver object
  static String? _extractDriverName(Map<String, dynamic> json, String key) {
    final driverData = json[key];
    if (driverData is Map<String, dynamic>) {
      return driverData['name'] as String?;
    }
    return null;
  }

  /// Extract driver phone from driver object
  static String? _extractDriverPhone(Map<String, dynamic> json, String key) {
    final driverData = json[key];
    if (driverData is Map<String, dynamic>) {
      return driverData['phone'] as String?;
    }
    return null;
  }

  static TenantOrderStatus _parseOrderStatus(dynamic status) {
    if (status == null) return TenantOrderStatus.pending;

    final statusStr = status.toString().toLowerCase().replaceAll('_', '');

    switch (statusStr) {
      case 'pending':
        return TenantOrderStatus.pending;
      case 'paid':
        return TenantOrderStatus.paid;
      case 'awaitingapproval':
        return TenantOrderStatus.awaitingApproval;
      case 'approvalexpired':
        return TenantOrderStatus.approvalExpired;
      case 'poorresponsetime':
        return TenantOrderStatus.poorResponseTime;
      case 'approved':
        return TenantOrderStatus.approved;
      case 'declined':
        return TenantOrderStatus.declined;
      case 'modified':
        return TenantOrderStatus.modified;
      case 'inprogress':
        return TenantOrderStatus.inProgress;
      case 'assigned':
        return TenantOrderStatus.assigned;
      case 'pickedup':
        return TenantOrderStatus.pickedUp;
      case 'processing':
        return TenantOrderStatus.processing;
      case 'ready':
        return TenantOrderStatus.ready;
      case 'outfordelivery':
        return TenantOrderStatus.outForDelivery;
      case 'delivered':
        return TenantOrderStatus.delivered;
      case 'cancelled':
        return TenantOrderStatus.cancelled;
      case 'processingrefund':
        return TenantOrderStatus.processingRefund;
      case 'expired':
        return TenantOrderStatus.expired;
      case 'extensionrequested':
        return TenantOrderStatus.extensionRequested;
      case 'extensionapproved':
        return TenantOrderStatus.extensionApproved;
      case 'extensiondeclined':
        return TenantOrderStatus.extensionDeclined;
      default:
        return TenantOrderStatus.pending;
    }
  }

  static OrderPriority _parsePriority(dynamic priority) {
    if (priority == null) return OrderPriority.normal;

    switch (priority.toString().toLowerCase()) {
      case 'low':
        return OrderPriority.low;
      case 'normal':
        return OrderPriority.normal;
      case 'high':
        return OrderPriority.high;
      case 'urgent':
        return OrderPriority.urgent;
      default:
        return OrderPriority.normal;
    }
  }

  static PaymentStatus _parsePaymentStatus(dynamic paymentStatus) {
    if (paymentStatus == null) return PaymentStatus.pending;

    switch (paymentStatus.toString().toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'paid':
        return PaymentStatus.paid;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      case 'partially_refunded':
        return PaymentStatus.partiallyRefunded;
      default:
        return PaymentStatus.pending;
    }
  }

  // Convenience getters
  String get statusDisplayText => _getStatusDisplayText(status);
  String get priorityDisplayText => _getPriorityDisplayText(priority);
  String get paymentStatusDisplayText =>
      _getPaymentStatusDisplayText(paymentStatus);
  double get total => totalAmount;
  List<OrderItemModel> get orderItems => items;

  // Status check helpers
  bool get isPendingApproval => status == TenantOrderStatus.awaitingApproval;
  bool get isConfirmed => status == TenantOrderStatus.approved;
  bool get isPickedUp => status == TenantOrderStatus.pickedUp;
  bool get isInProgress =>
      status == TenantOrderStatus.inProgress ||
      status == TenantOrderStatus.processing;
  bool get isReadyForDelivery => status == TenantOrderStatus.ready;
  bool get isReadyForPickup => status == TenantOrderStatus.ready;
  bool get isOutForDelivery => status == TenantOrderStatus.outForDelivery;
  bool get isDelivered => status == TenantOrderStatus.delivered;
  bool get isCancelled => status == TenantOrderStatus.cancelled;
  bool get isCompleted => status == TenantOrderStatus.delivered;

  // Backward compatibility aliases for old status names
  static const confirmed = TenantOrderStatus.approved;
  static const readyForPickup = TenantOrderStatus.ready;
  static const readyForDelivery = TenantOrderStatus.ready;
  static const completed = TenantOrderStatus.delivered;

  static String _getStatusDisplayText(TenantOrderStatus status) {
    switch (status) {
      case TenantOrderStatus.pending:
        return 'Pending';
      case TenantOrderStatus.paid:
        return 'Paid';
      case TenantOrderStatus.awaitingApproval:
        return 'Awaiting Approval';
      case TenantOrderStatus.approvalExpired:
        return 'Approval Expired';
      case TenantOrderStatus.poorResponseTime:
        return 'Poor Response Time';
      case TenantOrderStatus.approved:
        return 'Approved';
      case TenantOrderStatus.declined:
        return 'Declined';
      case TenantOrderStatus.modified:
        return 'Modified';
      case TenantOrderStatus.inProgress:
        return 'In Progress';
      case TenantOrderStatus.assigned:
        return 'Assigned';
      case TenantOrderStatus.pickedUp:
        return 'Picked Up';
      case TenantOrderStatus.processing:
        return 'Processing';
      case TenantOrderStatus.ready:
        return 'Ready';
      case TenantOrderStatus.outForDelivery:
        return 'Out for Delivery';
      case TenantOrderStatus.delivered:
        return 'Delivered';
      case TenantOrderStatus.cancelled:
        return 'Cancelled';
      case TenantOrderStatus.processingRefund:
        return 'Processing Refund';
      case TenantOrderStatus.expired:
        return 'Expired';
      case TenantOrderStatus.extensionRequested:
        return 'Extension Requested';
      case TenantOrderStatus.extensionApproved:
        return 'Extension Approved';
      case TenantOrderStatus.extensionDeclined:
        return 'Extension Declined';
    }
  }

  static String _getPriorityDisplayText(OrderPriority priority) {
    switch (priority) {
      case OrderPriority.low:
        return 'Low';
      case OrderPriority.normal:
        return 'Normal';
      case OrderPriority.high:
        return 'High';
      case OrderPriority.urgent:
        return 'Urgent';
    }
  }

  static String _getPaymentStatusDisplayText(PaymentStatus paymentStatus) {
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'branch_id': branchId,
      'branch_name': branchName,
      'status': status.name,
      'priority': priority.name,
      'payment_status': paymentStatus.name,
      'items': items.map((item) => item.toJson()).toList(),
      'total_amount': totalAmount,
      'subtotal': subtotal,
      'delivery_fee': deliveryFee,
      'pickup_address': pickupAddress,
      'delivery_address': deliveryAddress,
      'pickup_date': pickupDate.toIso8601String(),
      'delivery_date': deliveryDate.toIso8601String(),
      'notes': notes,
      'special_instructions': specialInstructions,
      'driver_id': driverId,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'tags': tags.map((tag) => tag.toJson()).toList(),
      'status_history':
          statusHistory.map((history) => history.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    customerId,
    customerName,
    customerEmail,
    customerPhone,
    branchId,
    branchName,
    status,
    priority,
    paymentStatus,
    items,
    totalAmount,
    subtotal,
    deliveryFee,
    pickupAddress,
    deliveryAddress,
    pickupDate,
    deliveryDate,
    notes,
    specialInstructions,
    driverId,
    driverName,
    driverPhone,
    tags,
    statusHistory,
    createdAt,
    updatedAt,
  ];
}

class OrderItemModel extends Equatable {
  final String id;
  final String name;
  final String itemType;
  final int quantity;
  final double price;
  final double weight;
  final List<String> services;
  final String? description;

  const OrderItemModel({
    required this.id,
    required this.name,
    this.itemType = 'general',
    required this.quantity,
    required this.price,
    this.weight = 0.0,
    this.services = const [],
    this.description,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? json['item_name'] as String? ?? '',
      itemType:
          json['item_type'] as String? ?? json['type'] as String? ?? 'general',
      quantity: json['quantity'] as int? ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      services:
          (json['services'] as List<dynamic>?)
              ?.map((s) => s.toString())
              .toList() ??
          [],
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'item_type': itemType,
      'quantity': quantity,
      'price': price,
      'weight': weight,
      'services': services,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    itemType,
    quantity,
    price,
    weight,
    services,
    description,
  ];
}

class OrderTagModel extends Equatable {
  final String id;
  final String orderId;
  final OrderTagType type;
  final String value;
  final DateTime createdAt;

  const OrderTagModel({
    required this.id,
    required this.orderId,
    required this.type,
    required this.value,
    required this.createdAt,
  });

  factory OrderTagModel.fromJson(Map<String, dynamic> json) {
    return OrderTagModel(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      type: _parseTagType(json['type']),
      value: json['value'] as String? ?? '',
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : DateTime.now(),
    );
  }

  static OrderTagType _parseTagType(dynamic type) {
    if (type is String) {
      switch (type.toLowerCase()) {
        case 'location':
          return OrderTagType.location;
        case 'status':
          return OrderTagType.status;
        case 'priority':
          return OrderTagType.priority;
        case 'service':
          return OrderTagType.service;
        case 'custom':
          return OrderTagType.custom;
        default:
          return OrderTagType.custom;
      }
    }
    return OrderTagType.custom;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'type': type.name,
      'value': value,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, orderId, type, value, createdAt];
}

class OrderStatusHistoryModel extends Equatable {
  final String id;
  final String orderId;
  final TenantOrderStatus status;
  final String? notes;
  final String? updatedBy;
  final DateTime createdAt;

  const OrderStatusHistoryModel({
    required this.id,
    required this.orderId,
    required this.status,
    this.notes,
    this.updatedBy,
    required this.createdAt,
  });

  factory OrderStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusHistoryModel(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      status: TenantOrderModel._parseOrderStatus(json['status']),
      notes: json['notes'] as String?,
      updatedBy: json['updated_by'] as String?,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'status': status.name,
      'notes': notes,
      'updated_by': updatedBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, orderId, status, notes, updatedBy, createdAt];
}

class OrderAssignmentModel extends Equatable {
  final String id;
  final String orderId;
  final String driverId;
  final String driverName;
  final DateTime assignedAt;
  final String? notes;

  const OrderAssignmentModel({
    required this.id,
    required this.orderId,
    required this.driverId,
    required this.driverName,
    required this.assignedAt,
    this.notes,
  });

  factory OrderAssignmentModel.fromJson(Map<String, dynamic> json) {
    return OrderAssignmentModel(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      driverId: json['driver_id']?.toString() ?? '',
      driverName: json['driver_name'] as String? ?? 'Unknown',
      assignedAt:
          json['assigned_at'] != null
              ? DateTime.parse(json['assigned_at'] as String)
              : DateTime.now(),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'driver_id': driverId,
      'driver_name': driverName,
      'assigned_at': assignedAt.toIso8601String(),
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
    id,
    orderId,
    driverId,
    driverName,
    assignedAt,
    notes,
  ];
}
