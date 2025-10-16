import 'package:equatable/equatable.dart';

enum BranchStatus { active, inactive, maintenance }

class LaundretteBranch extends Equatable {
  final String id;
  final String name;
  final String description;
  final String address;
  final String city;
  final String postcode;
  final String phone;
  final String email;
  final BranchStatus status;
  final List<String> services;
  final Map<String, dynamic> operatingHours;
  final double latitude;
  final double longitude;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LaundretteBranch({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.postcode,
    required this.phone,
    required this.email,
    required this.status,
    required this.services,
    required this.operatingHours,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LaundretteBranch.fromJson(Map<String, dynamic> json) {
    return LaundretteBranch(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      address: json['address'] as String,
      city: json['city'] as String,
      postcode: json['postcode'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      status: _parseBranchStatus(json['status']),
      services: List<String>.from(json['services'] ?? []),
      operatingHours: json['operating_hours'] as Map<String, dynamic>? ?? {},
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static BranchStatus _parseBranchStatus(dynamic status) {
    if (status is String) {
      switch (status.toLowerCase()) {
        case 'active':
          return BranchStatus.active;
        case 'inactive':
          return BranchStatus.inactive;
        case 'maintenance':
          return BranchStatus.maintenance;
        default:
          return BranchStatus.active;
      }
    } else if (status is bool) {
      return status ? BranchStatus.active : BranchStatus.inactive;
    }
    return BranchStatus.active;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'city': city,
      'postcode': postcode,
      'phone': phone,
      'email': email,
      'status': status.name,
      'services': services,
      'operating_hours': operatingHours,
      'latitude': latitude,
      'longitude': longitude,
      'images': images,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  LaundretteBranch copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? city,
    String? postcode,
    String? phone,
    String? email,
    BranchStatus? status,
    List<String>? services,
    Map<String, dynamic>? operatingHours,
    double? latitude,
    double? longitude,
    List<String>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LaundretteBranch(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      postcode: postcode ?? this.postcode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      status: status ?? this.status,
      services: services ?? this.services,
      operatingHours: operatingHours ?? this.operatingHours,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Computed properties for backward compatibility
  String get phoneNumber => phone;
  String get fullAddress => '$address, $city, $postcode';
  bool get isCurrentlyOpen => status == BranchStatus.active;
  int get currentOrderCount => 0; // Retrieved from API when needed
  int get maxConcurrentOrders => 100; // Default value
  bool get autoAcceptOrders => false; // Default value
  bool get supportsPriorityDelivery => true; // Default value
  Map<String, double> get bagPricing => {}; // Default empty
  Map<String, double> get servicePricing => {}; // Default empty
  String get country => 'UK'; // Default value
  bool get isOpen => status == BranchStatus.active; // Based on status

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    address,
    city,
    postcode,
    phone,
    email,
    status,
    services,
    operatingHours,
    latitude,
    longitude,
    images,
    createdAt,
    updatedAt,
  ];
}
