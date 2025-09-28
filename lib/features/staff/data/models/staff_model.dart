import 'package:equatable/equatable.dart';

/// Staff role enum
enum StaffRole { manager, supervisor, operator, cleaner, driver, admin }

/// Staff status enum
enum StaffStatus { active, inactive, suspended, terminated }

/// Staff permission enum
enum StaffPermission {
  viewOrders,
  updateOrders,
  manageOrders,
  viewAnalytics,
  manageStaff,
  manageInventory,
  managePricing,
  manageCustomers,
  manageDrivers,
  manageSettings,
}

/// Staff model
class StaffModel extends Equatable {
  final String id;
  final String tenantId;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final StaffRole role;
  final StaffStatus status;
  final List<StaffPermission> permissions;
  final String? profileImageUrl;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> metadata;

  const StaffModel({
    required this.id,
    required this.tenantId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    required this.role,
    required this.status,
    required this.permissions,
    this.profileImageUrl,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    required this.metadata,
  });

  /// Get full name
  String get fullName => '$firstName $lastName';

  /// Get display name
  String get displayName => fullName;

  /// Get role display text
  String get roleDisplayText {
    switch (role) {
      case StaffRole.manager:
        return 'Manager';
      case StaffRole.supervisor:
        return 'Supervisor';
      case StaffRole.operator:
        return 'Operator';
      case StaffRole.cleaner:
        return 'Cleaner';
      case StaffRole.driver:
        return 'Driver';
      case StaffRole.admin:
        return 'Admin';
    }
  }

  /// Get status display text
  String get statusDisplayText {
    switch (status) {
      case StaffStatus.active:
        return 'Active';
      case StaffStatus.inactive:
        return 'Inactive';
      case StaffStatus.suspended:
        return 'Suspended';
      case StaffStatus.terminated:
        return 'Terminated';
    }
  }

  /// Get status color
  String get statusColor {
    switch (status) {
      case StaffStatus.active:
        return 'success';
      case StaffStatus.inactive:
        return 'warning';
      case StaffStatus.suspended:
        return 'error';
      case StaffStatus.terminated:
        return 'neutral';
    }
  }

  /// Get role color
  String get roleColor {
    switch (role) {
      case StaffRole.manager:
        return 'primary';
      case StaffRole.supervisor:
        return 'info';
      case StaffRole.operator:
        return 'success';
      case StaffRole.cleaner:
        return 'warning';
      case StaffRole.driver:
        return 'info';
      case StaffRole.admin:
        return 'error';
    }
  }

  /// Check if staff has permission
  bool hasPermission(StaffPermission permission) {
    return permissions.contains(permission);
  }

  /// Check if staff is active
  bool get isActive => status == StaffStatus.active;

  /// Check if staff is manager or admin
  bool get isManager => role == StaffRole.manager || role == StaffRole.admin;

  /// Check if staff can manage orders
  bool get canManageOrders => hasPermission(StaffPermission.manageOrders);

  /// Check if staff can view analytics
  bool get canViewAnalytics => hasPermission(StaffPermission.viewAnalytics);

  /// Check if staff can manage other staff
  bool get canManageStaff => hasPermission(StaffPermission.manageStaff);

  /// Get last login display text
  String get lastLoginDisplayText {
    if (lastLoginAt == null) return 'Never';

    final now = DateTime.now();
    final difference = now.difference(lastLoginAt!);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  /// Create StaffModel from JSON
  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: StaffRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => StaffRole.operator,
      ),
      status: StaffStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => StaffStatus.active,
      ),
      permissions:
          (json['permissions'] as List?)
              ?.map(
                (p) => StaffPermission.values.firstWhere(
                  (e) => e.name == p,
                  orElse: () => StaffPermission.viewOrders,
                ),
              )
              .toList() ??
          [],
      profileImageUrl: json['profile_image_url'] as String?,
      lastLoginAt:
          json['last_login_at'] != null
              ? DateTime.parse(json['last_login_at'] as String)
              : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  /// Convert StaffModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant_id': tenantId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'role': role.name,
      'status': status.name,
      'permissions': permissions.map((p) => p.name).toList(),
      'profile_image_url': profileImageUrl,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create a copy of StaffModel with updated fields
  StaffModel copyWith({
    String? id,
    String? tenantId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    StaffRole? role,
    StaffStatus? status,
    List<StaffPermission>? permissions,
    String? profileImageUrl,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return StaffModel(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      status: status ?? this.status,
      permissions: permissions ?? this.permissions,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
    id,
    tenantId,
    firstName,
    lastName,
    email,
    phone,
    role,
    status,
    permissions,
    profileImageUrl,
    lastLoginAt,
    createdAt,
    updatedAt,
    metadata,
  ];
}
