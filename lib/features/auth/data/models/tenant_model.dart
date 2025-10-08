/// Tenant model for laundrette app
class TenantModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String role;
  final bool onboardingCompleted;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TenantModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.role,
    required this.onboardingCompleted,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      id: json['id'] as int,
      firstName: (json['first_name'] ?? json['name']?.toString().split(' ').first ?? '') as String,
      lastName: (json['last_name'] ?? json['name']?.toString().split(' ').skip(1).join(' ') ?? '') as String,
      email: json['email'] as String,
      mobile: (json['mobile'] ?? json['phone'] ?? '') as String,
      role: (json['role'] is String ? json['role'] : json['role']?['value'] ?? 'tenant') as String,
      onboardingCompleted: (json['onboarding_completed'] ?? false) as bool,
      emailVerifiedAt:
          json['email_verified_at'] != null
              ? DateTime.parse(json['email_verified_at'] as String)
              : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'mobile': mobile,
      'role': role,
      'onboarding_completed': onboardingCompleted,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  TenantModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    String? role,
    bool? onboardingCompleted,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TenantModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      role: role ?? this.role,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isEmailVerified => emailVerifiedAt != null;
  String get fullName => '$firstName $lastName';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TenantModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TenantModel(id: $id, name: $fullName, email: $email, role: $role)';
  }
}
