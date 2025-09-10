import 'package:equatable/equatable.dart';

/// Branch status types
enum BranchStatus {
  active,
  inactive,
  maintenance,
  closed,
}

/// Branch model for laundrette management
class LaundretteBranch extends Equatable {
  final String id;
  final String laundretteId;
  final String name;
  final String? description;
  final String? imageUrl;
  final String address;
  final String city;
  final String postcode;
  final String country;
  final double latitude;
  final double longitude;
  final BranchStatus status;
  final bool isOpen;
  final Map<String, String> operatingHours; // day -> hours
  final Map<String, double> bagPricing; // bagType -> price
  final Map<String, double> servicePricing; // service -> price
  final bool autoAcceptOrders;
  final bool supportsPriorityDelivery;
  final String? phoneNumber;
  final String? email;
  final int maxConcurrentOrders;
  final int currentOrderCount;
  final Map<String, dynamic> settings;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LaundretteBranch({
    required this.id,
    required this.laundretteId,
    required this.name,
    this.description,
    this.imageUrl,
    required this.address,
    required this.city,
    required this.postcode,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.isOpen,
    required this.operatingHours,
    required this.bagPricing,
    required this.servicePricing,
    required this.autoAcceptOrders,
    required this.supportsPriorityDelivery,
    this.phoneNumber,
    this.email,
    required this.maxConcurrentOrders,
    required this.currentOrderCount,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get full address string
  String get fullAddress => '$address, $city, $postcode, $country';

  /// Get short address (city, country)
  String get shortAddress => '$city, $country';

  /// Check if branch is currently open based on operating hours
  bool get isCurrentlyOpen {
    if (!isOpen || status != BranchStatus.active) return false;
    
    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final hours = operatingHours[dayName];
    
    if (hours == null || hours.isEmpty) return false;
    
    // Parse hours (format: "09:00-17:00")
    final parts = hours.split('-');
    if (parts.length != 2) return false;
    
    try {
      final openTime = _parseTime(parts[0].trim());
      final closeTime = _parseTime(parts[1].trim());
      final currentTime = now.hour * 60 + now.minute;
      
      return currentTime >= openTime && currentTime <= closeTime;
    } catch (e) {
      return false;
    }
  }

  /// Check if branch can accept new orders
  bool get canAcceptOrders {
    return isCurrentlyOpen && 
           currentOrderCount < maxConcurrentOrders &&
           status == BranchStatus.active;
  }

  /// Get bag price for specific type
  double getBagPrice(String bagType) {
    return bagPricing[bagType] ?? 0.0;
  }

  /// Get service price for specific service
  double getServicePrice(String service) {
    return servicePricing[service] ?? 0.0;
  }

  /// Get setting value by key
  dynamic getSetting(String key) => settings[key];

  /// Set setting value
  Map<String, dynamic> updateSetting(String key, dynamic value) {
    final updatedSettings = Map<String, dynamic>.from(settings);
    updatedSettings[key] = value;
    return updatedSettings;
  }

  /// Get day name from weekday number
  String _getDayName(int weekday) {
    const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    return days[weekday - 1];
  }

  /// Parse time string to minutes since midnight
  int _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return hour * 60 + minute;
  }

  /// Create LaundretteBranch from JSON
  factory LaundretteBranch.fromJson(Map<String, dynamic> json) {
    return LaundretteBranch(
      id: json['id'] as String,
      laundretteId: json['laundretteId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      address: json['address'] as String,
      city: json['city'] as String,
      postcode: json['postcode'] as String,
      country: json['country'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      status: BranchStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BranchStatus.active,
      ),
      isOpen: json['isOpen'] as bool,
      operatingHours: Map<String, String>.from(json['operatingHours'] as Map),
      bagPricing: Map<String, double>.from(
        (json['bagPricing'] as Map).map((k, v) => MapEntry(k as String, (v as num).toDouble())),
      ),
      servicePricing: Map<String, double>.from(
        (json['servicePricing'] as Map).map((k, v) => MapEntry(k as String, (v as num).toDouble())),
      ),
      autoAcceptOrders: json['autoAcceptOrders'] as bool,
      supportsPriorityDelivery: json['supportsPriorityDelivery'] as bool,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      maxConcurrentOrders: json['maxConcurrentOrders'] as int,
      currentOrderCount: json['currentOrderCount'] as int,
      settings: Map<String, dynamic>.from(json['settings'] as Map),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert LaundretteBranch to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'laundretteId': laundretteId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'address': address,
      'city': city,
      'postcode': postcode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'status': status.name,
      'isOpen': isOpen,
      'operatingHours': operatingHours,
      'bagPricing': bagPricing,
      'servicePricing': servicePricing,
      'autoAcceptOrders': autoAcceptOrders,
      'supportsPriorityDelivery': supportsPriorityDelivery,
      'phoneNumber': phoneNumber,
      'email': email,
      'maxConcurrentOrders': maxConcurrentOrders,
      'currentOrderCount': currentOrderCount,
      'settings': settings,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy of LaundretteBranch with updated fields
  LaundretteBranch copyWith({
    String? id,
    String? laundretteId,
    String? name,
    String? description,
    String? imageUrl,
    String? address,
    String? city,
    String? postcode,
    String? country,
    double? latitude,
    double? longitude,
    BranchStatus? status,
    bool? isOpen,
    Map<String, String>? operatingHours,
    Map<String, double>? bagPricing,
    Map<String, double>? servicePricing,
    bool? autoAcceptOrders,
    bool? supportsPriorityDelivery,
    String? phoneNumber,
    String? email,
    int? maxConcurrentOrders,
    int? currentOrderCount,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LaundretteBranch(
      id: id ?? this.id,
      laundretteId: laundretteId ?? this.laundretteId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      city: city ?? this.city,
      postcode: postcode ?? this.postcode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      isOpen: isOpen ?? this.isOpen,
      operatingHours: operatingHours ?? this.operatingHours,
      bagPricing: bagPricing ?? this.bagPricing,
      servicePricing: servicePricing ?? this.servicePricing,
      autoAcceptOrders: autoAcceptOrders ?? this.autoAcceptOrders,
      supportsPriorityDelivery: supportsPriorityDelivery ?? this.supportsPriorityDelivery,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      maxConcurrentOrders: maxConcurrentOrders ?? this.maxConcurrentOrders,
      currentOrderCount: currentOrderCount ?? this.currentOrderCount,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        laundretteId,
        name,
        description,
        imageUrl,
        address,
        city,
        postcode,
        country,
        latitude,
        longitude,
        status,
        isOpen,
        operatingHours,
        bagPricing,
        servicePricing,
        autoAcceptOrders,
        supportsPriorityDelivery,
        phoneNumber,
        email,
        maxConcurrentOrders,
        currentOrderCount,
        settings,
        createdAt,
        updatedAt,
      ];
}
