import 'package:equatable/equatable.dart';

enum TenantOrderStatus {
  pending,
  confirmed,
  inProgress,
  readyForPickup,
  completed,
  cancelled,
}

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
  final List<OrderItemModel> items;
  final double totalAmount;
  final String pickupAddress;
  final String deliveryAddress;
  final DateTime pickupDate;
  final DateTime deliveryDate;
  final String? notes;
  final String? driverId;
  final String? driverName;
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
    required this.items,
    required this.totalAmount,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.pickupDate,
    required this.deliveryDate,
    this.notes,
    this.driverId,
    this.driverName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TenantOrderModel.fromJson(Map<String, dynamic> json) {
    return TenantOrderModel(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      customerId: json['customer_id'] as String,
      customerName: json['customer_name'] as String,
      customerEmail: json['customer_email'] as String,
      customerPhone: json['customer_phone'] as String,
      branchId: json['branch_id'] as String,
      branchName: json['branch_name'] as String,
      status: _parseOrderStatus(json['status']),
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (item) => OrderItemModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      totalAmount: (json['total_amount'] as num).toDouble(),
      pickupAddress: json['pickup_address'] as String,
      deliveryAddress: json['delivery_address'] as String,
      pickupDate: DateTime.parse(json['pickup_date'] as String),
      deliveryDate: DateTime.parse(json['delivery_date'] as String),
      notes: json['notes'] as String?,
      driverId: json['driver_id'] as String?,
      driverName: json['driver_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static TenantOrderStatus _parseOrderStatus(dynamic status) {
    if (status is String) {
      switch (status.toLowerCase()) {
        case 'pending':
          return TenantOrderStatus.pending;
        case 'confirmed':
          return TenantOrderStatus.confirmed;
        case 'in_progress':
          return TenantOrderStatus.inProgress;
        case 'ready_for_pickup':
          return TenantOrderStatus.readyForPickup;
        case 'completed':
          return TenantOrderStatus.completed;
        case 'cancelled':
          return TenantOrderStatus.cancelled;
        default:
          return TenantOrderStatus.pending;
      }
    }
    return TenantOrderStatus.pending;
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
      'items': items.map((item) => item.toJson()).toList(),
      'total_amount': totalAmount,
      'pickup_address': pickupAddress,
      'delivery_address': deliveryAddress,
      'pickup_date': pickupDate.toIso8601String(),
      'delivery_date': deliveryDate.toIso8601String(),
      'notes': notes,
      'driver_id': driverId,
      'driver_name': driverName,
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
    items,
    totalAmount,
    pickupAddress,
    deliveryAddress,
    pickupDate,
    deliveryDate,
    notes,
    driverId,
    driverName,
    createdAt,
    updatedAt,
  ];
}

class OrderItemModel extends Equatable {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String? description;

  const OrderItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.description,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [id, name, quantity, price, description];
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
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      type: _parseTagType(json['type']),
      value: json['value'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static OrderTagType _parseTagType(dynamic type) {
    if (type is String) {
      switch (type.toLowerCase()) {
        case 'priority':
          return OrderTagType.priority;
        case 'special_handling':
          return OrderTagType.specialHandling;
        case 'fragile':
          return OrderTagType.fragile;
        default:
          return OrderTagType.priority;
      }
    }
    return OrderTagType.priority;
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

enum OrderTagType { priority, specialHandling, fragile }

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
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      status: TenantOrderModel._parseOrderStatus(json['status']),
      notes: json['notes'] as String?,
      updatedBy: json['updated_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
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
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      driverId: json['driver_id'] as String,
      driverName: json['driver_name'] as String,
      assignedAt: DateTime.parse(json['assigned_at'] as String),
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
