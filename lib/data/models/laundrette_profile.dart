import 'package:equatable/equatable.dart';
import 'subscription.dart';

/// Laundrette profile types
enum LaundretteType {
  business,
  private,
}

/// Laundrette profile model representing a laundrette business
class LaundretteProfile extends Equatable {
  final String id;
  final String ownerId;
  final String businessName;
  final LaundretteType type;
  final String? businessRegistrationNumber;
  final String? taxId;
  final String? description;
  final String? logoUrl;
  final String? website;
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? city;
  final String? postcode;
  final String? country;
  final double? latitude;
  final double? longitude;
  final Subscription? currentSubscription;
  final bool isActive;
  final bool isVerified;
  final Map<String, dynamic> settings;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LaundretteProfile({
    required this.id,
    required this.ownerId,
    required this.businessName,
    required this.type,
    this.businessRegistrationNumber,
    this.taxId,
    this.description,
    this.logoUrl,
    this.website,
    this.phoneNumber,
    this.email,
    this.address,
    this.city,
    this.postcode,
    this.country,
    this.latitude,
    this.longitude,
    this.currentSubscription,
    required this.isActive,
    required this.isVerified,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get full address string
  String get fullAddress {
    final parts = [address, city, postcode, country]
        .where((part) => part != null && part.isNotEmpty)
        .toList();
    return parts.join(', ');
  }

  /// Get short address (city, country)
  String get shortAddress {
    final parts = [city, country]
        .where((part) => part != null && part.isNotEmpty)
        .toList();
    return parts.join(', ');
  }

  /// Check if profile has active subscription
  bool get hasActiveSubscription => 
      currentSubscription != null && currentSubscription!.isActive;

  /// Check if profile is business type
  bool get isBusiness => type == LaundretteType.business;

  /// Check if profile is private type
  bool get isPrivate => type == LaundretteType.private;

  /// Get setting value by key
  dynamic getSetting(String key) => settings[key];

  /// Set setting value
  Map<String, dynamic> updateSetting(String key, dynamic value) {
    final updatedSettings = Map<String, dynamic>.from(settings);
    updatedSettings[key] = value;
    return updatedSettings;
  }

  /// Create LaundretteProfile from JSON
  factory LaundretteProfile.fromJson(Map<String, dynamic> json) {
    return LaundretteProfile(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      businessName: json['businessName'] as String,
      type: LaundretteType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => LaundretteType.private,
      ),
      businessRegistrationNumber: json['businessRegistrationNumber'] as String?,
      taxId: json['taxId'] as String?,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      website: json['website'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      postcode: json['postcode'] as String?,
      country: json['country'] as String?,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      currentSubscription: json['currentSubscription'] != null
          ? Subscription.fromJson(json['currentSubscription'] as Map<String, dynamic>)
          : null,
      isActive: json['isActive'] as bool,
      isVerified: json['isVerified'] as bool,
      settings: Map<String, dynamic>.from(json['settings'] as Map),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert LaundretteProfile to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'businessName': businessName,
      'type': type.name,
      'businessRegistrationNumber': businessRegistrationNumber,
      'taxId': taxId,
      'description': description,
      'logoUrl': logoUrl,
      'website': website,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'city': city,
      'postcode': postcode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'currentSubscription': currentSubscription?.toJson(),
      'isActive': isActive,
      'isVerified': isVerified,
      'settings': settings,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy of LaundretteProfile with updated fields
  LaundretteProfile copyWith({
    String? id,
    String? ownerId,
    String? businessName,
    LaundretteType? type,
    String? businessRegistrationNumber,
    String? taxId,
    String? description,
    String? logoUrl,
    String? website,
    String? phoneNumber,
    String? email,
    String? address,
    String? city,
    String? postcode,
    String? country,
    double? latitude,
    double? longitude,
    Subscription? currentSubscription,
    bool? isActive,
    bool? isVerified,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LaundretteProfile(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      businessName: businessName ?? this.businessName,
      type: type ?? this.type,
      businessRegistrationNumber: businessRegistrationNumber ?? this.businessRegistrationNumber,
      taxId: taxId ?? this.taxId,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      website: website ?? this.website,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      postcode: postcode ?? this.postcode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      currentSubscription: currentSubscription ?? this.currentSubscription,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        ownerId,
        businessName,
        type,
        businessRegistrationNumber,
        taxId,
        description,
        logoUrl,
        website,
        phoneNumber,
        email,
        address,
        city,
        postcode,
        country,
        latitude,
        longitude,
        currentSubscription,
        isActive,
        isVerified,
        settings,
        createdAt,
        updatedAt,
      ];
}
