import 'package:equatable/equatable.dart';

/// Staff role types
enum StaffRole { owner, manager, staff, driver, cleaner }

/// Staff status
enum StaffStatus { active, inactive, suspended, terminated }

/// Staff member model for laundrette management
class StaffMember extends Equatable {
  final String id;
  final String laundretteId;
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final StaffRole role;
  final StaffStatus status;
  final String? profileImageUrl;
  final List<String> branchIds; // Branches this staff member can work at
  final Map<String, dynamic> permissions;
  final Map<String, String> workingHours; // day -> hours
  final double? hourlyRate;
  final DateTime? hireDate;
  final DateTime? lastActiveAt;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StaffMember({
    required this.id,
    required this.laundretteId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.status,
    this.profileImageUrl,
    required this.branchIds,
    required this.permissions,
    required this.workingHours,
    this.hourlyRate,
    this.hireDate,
    this.lastActiveAt,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get full name
  String get fullName => '$firstName $lastName';

  /// Get display name (first name + last initial)
  String get displayName => '$firstName ${lastName[0]}.';

  /// Check if staff member is active
  bool get isActive => status == StaffStatus.active;

  /// Check if staff member is owner
  bool get isOwner => role == StaffRole.owner;

  /// Check if staff member is manager or owner
  bool get isManager => role == StaffRole.manager || role == StaffRole.owner;

  /// Check if staff member is driver
  bool get isDriver => role == StaffRole.driver;

  /// Check if staff member can work at specific branch
  bool canWorkAtBranch(String branchId) {
    return branchIds.contains(branchId);
  }

  /// Check if staff member has specific permission
  bool hasPermission(String permission) {
    return permissions[permission] == true;
  }

  /// Get working hours for specific day
  String? getWorkingHours(String day) {
    return workingHours[day.toLowerCase()];
  }

  /// Check if staff member is currently working (based on working hours)
  bool get isCurrentlyWorking {
    if (!isActive) return false;

    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final hours = getWorkingHours(dayName);

    if (hours == null || hours.isEmpty) return false;

    // Parse hours (format: "09:00-17:00")
    final parts = hours.split('-');
    if (parts.length != 2) return false;

    try {
      final startTime = _parseTime(parts[0].trim());
      final endTime = _parseTime(parts[1].trim());
      final currentTime = now.hour * 60 + now.minute;

      return currentTime >= startTime && currentTime <= endTime;
    } catch (e) {
      return false;
    }
  }

  /// Get day name from weekday number
  String _getDayName(int weekday) {
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return days[weekday - 1];
  }

  /// Parse time string to minutes since midnight
  int _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return hour * 60 + minute;
  }

  /// Get role display text
  String get roleDisplayText {
    switch (role) {
      case StaffRole.owner:
        return 'Owner';
      case StaffRole.manager:
        return 'Manager';
      case StaffRole.staff:
        return 'Staff';
      case StaffRole.driver:
        return 'Driver';
      case StaffRole.cleaner:
        return 'Cleaner';
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

  /// Get metadata value by key
  dynamic getMetadata(String key) => metadata[key];

  /// Set metadata value
  Map<String, dynamic> updateMetadata(String key, dynamic value) {
    final updatedMetadata = Map<String, dynamic>.from(metadata);
    updatedMetadata[key] = value;
    return updatedMetadata;
  }

  /// Create StaffMember from JSON
  factory StaffMember.fromJson(Map<String, dynamic> json) {
    return StaffMember(
      id: json['id'] as String,
      laundretteId: json['laundretteId'] as String,
      userId: json['userId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      role: StaffRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => StaffRole.staff,
      ),
      status: StaffStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => StaffStatus.active,
      ),
      profileImageUrl: json['profileImageUrl'] as String?,
      branchIds: List<String>.from(json['branchIds'] as List),
      permissions: Map<String, dynamic>.from(json['permissions'] as Map),
      workingHours: Map<String, String>.from(json['workingHours'] as Map),
      hourlyRate:
          json['hourlyRate'] != null
              ? (json['hourlyRate'] as num).toDouble()
              : null,
      hireDate:
          json['hireDate'] != null
              ? DateTime.parse(json['hireDate'] as String)
              : null,
      lastActiveAt:
          json['lastActiveAt'] != null
              ? DateTime.parse(json['lastActiveAt'] as String)
              : null,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert StaffMember to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'laundretteId': laundretteId,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role.name,
      'status': status.name,
      'profileImageUrl': profileImageUrl,
      'branchIds': branchIds,
      'permissions': permissions,
      'workingHours': workingHours,
      'hourlyRate': hourlyRate,
      'hireDate': hireDate?.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy of StaffMember with updated fields
  StaffMember copyWith({
    String? id,
    String? laundretteId,
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    StaffRole? role,
    StaffStatus? status,
    String? profileImageUrl,
    List<String>? branchIds,
    Map<String, dynamic>? permissions,
    Map<String, String>? workingHours,
    double? hourlyRate,
    DateTime? hireDate,
    DateTime? lastActiveAt,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StaffMember(
      id: id ?? this.id,
      laundretteId: laundretteId ?? this.laundretteId,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      status: status ?? this.status,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      branchIds: branchIds ?? this.branchIds,
      permissions: permissions ?? this.permissions,
      workingHours: workingHours ?? this.workingHours,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      hireDate: hireDate ?? this.hireDate,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    laundretteId,
    userId,
    firstName,
    lastName,
    email,
    phoneNumber,
    role,
    status,
    profileImageUrl,
    branchIds,
    permissions,
    workingHours,
    hourlyRate,
    hireDate,
    lastActiveAt,
    metadata,
    createdAt,
    updatedAt,
  ];
}
