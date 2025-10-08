import 'package:equatable/equatable.dart';

enum LaundretteOrderStatus {
  pending,
  confirmed,
  inProgress,
  readyForPickup,
  completed,
  cancelled,
}

enum OrderPriority { low, normal, high, urgent }

enum PaymentStatus { pending, paid, failed, refunded }

class LaundretteOrder extends Equatable {
  final String id;
  final String orderNumber;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String branchId;
  final String branchName;
  final LaundretteOrderStatus status;
  final List<OrderItem> items;
  final double totalAmount;
  final double tax;
  final String pickupAddress;
  final String deliveryAddress;
  final DateTime pickupDate;
  final DateTime deliveryDate;
  final String? notes;
  final String? driverId;
  final String? driverName;
  final OrderPriority priority;
  final PaymentStatus paymentStatus;
  final String laundretteId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LaundretteOrder({
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
    required this.tax,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.pickupDate,
    required this.deliveryDate,
    this.notes,
    this.driverId,
    this.driverName,
    required this.priority,
    required this.paymentStatus,
    required this.laundretteId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LaundretteOrder.fromJson(Map<String, dynamic> json) {
    return LaundretteOrder(
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
              ?.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (json['total_amount'] as num).toDouble(),
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      pickupAddress: json['pickup_address'] as String,
      deliveryAddress: json['delivery_address'] as String,
      pickupDate: DateTime.parse(json['pickup_date'] as String),
      deliveryDate: DateTime.parse(json['delivery_date'] as String),
      notes: json['notes'] as String?,
      driverId: json['driver_id'] as String?,
      driverName: json['driver_name'] as String?,
      priority: _parsePriority(json['priority']),
      paymentStatus: _parsePaymentStatus(json['payment_status']),
      laundretteId: json['laundrette_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static LaundretteOrderStatus _parseOrderStatus(dynamic status) {
    if (status is String) {
      switch (status.toLowerCase()) {
        case 'pending':
          return LaundretteOrderStatus.pending;
        case 'confirmed':
          return LaundretteOrderStatus.confirmed;
        case 'in_progress':
          return LaundretteOrderStatus.inProgress;
        case 'ready_for_pickup':
          return LaundretteOrderStatus.readyForPickup;
        case 'completed':
          return LaundretteOrderStatus.completed;
        case 'cancelled':
          return LaundretteOrderStatus.cancelled;
        default:
          return LaundretteOrderStatus.pending;
      }
    }
    return LaundretteOrderStatus.pending;
  }

  static OrderPriority _parsePriority(dynamic priority) {
    if (priority is String) {
      switch (priority.toLowerCase()) {
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
    return OrderPriority.normal;
  }

  static PaymentStatus _parsePaymentStatus(dynamic status) {
    if (status is String) {
      switch (status.toLowerCase()) {
        case 'pending':
          return PaymentStatus.pending;
        case 'paid':
          return PaymentStatus.paid;
        case 'failed':
          return PaymentStatus.failed;
        case 'refunded':
          return PaymentStatus.refunded;
        default:
          return PaymentStatus.pending;
      }
    }
    return PaymentStatus.pending;
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
    tax,
    pickupAddress,
    deliveryAddress,
    pickupDate,
    deliveryDate,
    notes,
    driverId,
    driverName,
    priority,
    paymentStatus,
    laundretteId,
    createdAt,
    updatedAt,
  ];
}

class OrderItem extends Equatable {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String? description;

  const OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.description,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, quantity, price, description];
}
