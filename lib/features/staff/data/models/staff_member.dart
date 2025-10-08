import 'package:equatable/equatable.dart';

enum StaffPermission {
  viewOrders,
  updateOrders,
  manageStaff,
  viewAnalytics,
  manageSettings,
}

class StaffMember extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String branchId;
  final List<StaffPermission> permissions;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StaffMember({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.branchId,
    required this.permissions,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StaffMember.fromJson(Map<String, dynamic> json) {
    return StaffMember(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      branchId: json['branch_id'] as String,
      permissions:
          (json['permissions'] as List<dynamic>?)
              ?.map((p) => _parsePermission(p))
              .toList() ??
          [],
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static StaffPermission _parsePermission(dynamic permission) {
    if (permission is String) {
      switch (permission.toLowerCase()) {
        case 'view_orders':
          return StaffPermission.viewOrders;
        case 'update_orders':
          return StaffPermission.updateOrders;
        case 'manage_staff':
          return StaffPermission.manageStaff;
        case 'view_analytics':
          return StaffPermission.viewAnalytics;
        case 'manage_settings':
          return StaffPermission.manageSettings;
        default:
          return StaffPermission.viewOrders;
      }
    }
    return StaffPermission.viewOrders;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    branchId,
    permissions,
    isActive,
    createdAt,
    updatedAt,
  ];
}
