import 'package:equatable/equatable.dart';

enum SubscriptionFeatures {
  basicOrders,
  advancedAnalytics,
  multiBranchSupport,
  staffManagement,
  customBranding,
  prioritySupport,
}

class SubscriptionPlan extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String billingPeriod;
  final List<SubscriptionFeatures> features;
  final int maxBranches;
  final int maxStaff;
  final bool isActive;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.billingPeriod,
    required this.features,
    required this.maxBranches,
    required this.maxStaff,
    required this.isActive,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      billingPeriod: json['billing_period'] as String,
      features: (json['features'] as List<dynamic>?)
              ?.map((f) => _parseFeature(f))
              .toList() ??
          [],
      maxBranches: json['max_branches'] as int,
      maxStaff: json['max_staff'] as int,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  static SubscriptionFeatures _parseFeature(dynamic feature) {
    if (feature is String) {
      switch (feature.toLowerCase()) {
        case 'basic_orders':
          return SubscriptionFeatures.basicOrders;
        case 'advanced_analytics':
          return SubscriptionFeatures.advancedAnalytics;
        case 'multi_branch_support':
          return SubscriptionFeatures.multiBranchSupport;
        case 'staff_management':
          return SubscriptionFeatures.staffManagement;
        case 'custom_branding':
          return SubscriptionFeatures.customBranding;
        case 'priority_support':
          return SubscriptionFeatures.prioritySupport;
        default:
          return SubscriptionFeatures.basicOrders;
      }
    }
    return SubscriptionFeatures.basicOrders;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        currency,
        billingPeriod,
        features,
        maxBranches,
        maxStaff,
        isActive,
      ];
}
