/// Laundry service model representing a service offered by branches
class LaundryService {
  final int id;
  final String slug;
  final String name;
  final String description;
  final ServiceIcon icon;
  final bool isCoreService;
  final bool allowsBundling;
  final bool requiresWeight;
  final String? displayName;

  // Pricing (from branch_services pivot)
  final double? pricePerKg;
  final double? minimumCharge;
  final double? maximumCharge;
  final double? minimumWeightKg;
  final double? maximumWeightKg;
  final int? estimatedHours;

  const LaundryService({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.icon,
    required this.isCoreService,
    required this.allowsBundling,
    required this.requiresWeight,
    this.displayName,
    this.pricePerKg,
    this.minimumCharge,
    this.maximumCharge,
    this.minimumWeightKg,
    this.maximumWeightKg,
    this.estimatedHours,
  });

  factory LaundryService.fromJson(Map<String, dynamic> json) {
    return LaundryService(
      id: json['id'] as int,
      slug: json['slug'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      icon: ServiceIcon.fromJson(json['icon'] as Map<String, dynamic>? ?? {}),
      isCoreService: json['is_core_service'] == true,
      allowsBundling: json['allows_bundling'] == true,
      requiresWeight: json['requires_weight'] == true,
      displayName: json['display_name'] as String?,
      // Pricing from pivot (if available)
      pricePerKg: _parseDouble(json['price_per_kg']),
      minimumCharge: _parseDouble(json['minimum_charge']),
      maximumCharge: _parseDouble(json['maximum_charge']),
      minimumWeightKg: _parseDouble(json['minimum_weight_kg']),
      maximumWeightKg: _parseDouble(json['maximum_weight_kg']),
      estimatedHours: json['estimated_hours'] as int?,
    );
  }

  /// Calculate price for a given weight
  double calculatePrice(double weightKg) {
    if (pricePerKg == null) return 0.0;
    
    double price = pricePerKg! * weightKg;
    
    // Apply minimum charge
    if (minimumCharge != null && price < minimumCharge!) {
      price = minimumCharge!;
    }
    
    // Apply maximum charge
    if (maximumCharge != null && price > maximumCharge!) {
      price = maximumCharge!;
    }
    
    return price;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'description': description,
      'icon': icon.toJson(),
      'is_core_service': isCoreService,
      'allows_bundling': allowsBundling,
      'requires_weight': requiresWeight,
      'display_name': displayName,
      'price_per_kg': pricePerKg,
      'minimum_charge': minimumCharge,
      'maximum_charge': maximumCharge,
      'minimum_weight_kg': minimumWeightKg,
      'maximum_weight_kg': maximumWeightKg,
      'estimated_hours': estimatedHours,
    };
  }
}

/// Service icon model
class ServiceIcon {
  final String name;
  final String type;
  final String emoji;
  final String color;
  final String backgroundColor;

  const ServiceIcon({
    required this.name,
    required this.type,
    required this.emoji,
    required this.color,
    required this.backgroundColor,
  });

  factory ServiceIcon.fromJson(Map<String, dynamic> json) {
    return ServiceIcon(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'material',
      emoji: json['emoji'] as String? ?? '',
      color: json['color'] as String? ?? '#000000',
      backgroundColor: json['background_color'] as String? ?? '#FFFFFF',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'emoji': emoji,
      'color': color,
      'background_color': backgroundColor,
    };
  }
}

