import 'package:equatable/equatable.dart';

/// Subscription plan types
enum SubscriptionType { business, private }

/// Subscription tiers for business plans
enum BusinessTier { starter, professional, enterprise, unlimited }

/// Subscription tiers for private plans
enum PrivateTier { basic, premium }

/// Subscription model representing a laundrette's subscription plan
class Subscription extends Equatable {
  final String id;
  final String laundretteId;
  final SubscriptionType type;
  final BusinessTier? businessTier;
  final PrivateTier? privateTier;
  final String name;
  final String description;
  final double monthlyPrice;
  final String currency;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final Map<String, dynamic> features;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Subscription({
    required this.id,
    required this.laundretteId,
    required this.type,
    this.businessTier,
    this.privateTier,
    required this.name,
    required this.description,
    required this.monthlyPrice,
    required this.currency,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.features,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get the current tier based on subscription type
  String get currentTier {
    if (type == SubscriptionType.business) {
      return businessTier?.name ?? 'unknown';
    } else {
      return privateTier?.name ?? 'unknown';
    }
  }

  /// Check if subscription is expired
  bool get isExpired => DateTime.now().isAfter(endDate);

  /// Check if subscription is expiring soon (within 7 days)
  bool get isExpiringSoon {
    final daysUntilExpiry = endDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 7 && daysUntilExpiry > 0;
  }

  /// Get feature value by key
  dynamic getFeature(String key) => features[key];

  /// Check if a specific feature is enabled
  bool hasFeature(String key) {
    final value = features[key];
    if (value is bool) return value;
    if (value is int) return value > 0;
    if (value is String) return value.isNotEmpty;
    return false;
  }

  /// Create Subscription from JSON
  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      laundretteId: json['laundretteId'] as String,
      type: SubscriptionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SubscriptionType.private,
      ),
      businessTier:
          json['businessTier'] != null
              ? BusinessTier.values.firstWhere(
                (e) => e.name == json['businessTier'],
                orElse: () => BusinessTier.starter,
              )
              : null,
      privateTier:
          json['privateTier'] != null
              ? PrivateTier.values.firstWhere(
                (e) => e.name == json['privateTier'],
                orElse: () => PrivateTier.basic,
              )
              : null,
      name: json['name'] as String,
      description: json['description'] as String,
      monthlyPrice: (json['monthlyPrice'] as num).toDouble(),
      currency: json['currency'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool,
      features: Map<String, dynamic>.from(json['features'] as Map),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert Subscription to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'laundretteId': laundretteId,
      'type': type.name,
      'businessTier': businessTier?.name,
      'privateTier': privateTier?.name,
      'name': name,
      'description': description,
      'monthlyPrice': monthlyPrice,
      'currency': currency,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'features': features,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy of Subscription with updated fields
  Subscription copyWith({
    String? id,
    String? laundretteId,
    SubscriptionType? type,
    BusinessTier? businessTier,
    PrivateTier? privateTier,
    String? name,
    String? description,
    double? monthlyPrice,
    String? currency,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    Map<String, dynamic>? features,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      laundretteId: laundretteId ?? this.laundretteId,
      type: type ?? this.type,
      businessTier: businessTier ?? this.businessTier,
      privateTier: privateTier ?? this.privateTier,
      name: name ?? this.name,
      description: description ?? this.description,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      currency: currency ?? this.currency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      features: features ?? this.features,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    laundretteId,
    type,
    businessTier,
    privateTier,
    name,
    description,
    monthlyPrice,
    currency,
    startDate,
    endDate,
    isActive,
    features,
    createdAt,
    updatedAt,
  ];
}

/// Subscription feature definitions
class SubscriptionFeatures {
  static const String maxBranches = 'maxBranches';
  static const String maxStaff = 'maxStaff';
  static const String advancedAnalytics = 'advancedAnalytics';
  static const String prioritySupport = 'prioritySupport';
  static const String customBranding = 'customBranding';
  static const String apiAccess = 'apiAccess';
  static const String multiLocationManagement = 'multiLocationManagement';
  static const String orderAutoAccept = 'orderAutoAccept';
  static const String priorityDelivery = 'priorityDelivery';
  static const String customPricing = 'customPricing';
  static const String staffScheduling = 'staffScheduling';
  static const String inventoryManagement = 'inventoryManagement';
  static const String customerCommunication = 'customerCommunication';
  static const String reportingAndInsights = 'reportingAndInsights';
}
