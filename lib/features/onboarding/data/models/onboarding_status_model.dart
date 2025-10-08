import 'package:equatable/equatable.dart';

class OnboardingStatusModel extends Equatable {
  final String id;
  final String tenantId;
  final bool isCompleted;
  final Map<String, dynamic> progress;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OnboardingStatusModel({
    required this.id,
    required this.tenantId,
    required this.isCompleted,
    required this.progress,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OnboardingStatusModel.fromJson(Map<String, dynamic> json) {
    return OnboardingStatusModel(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      isCompleted: json['is_completed'] as bool,
      progress: json['progress'] as Map<String, dynamic>,
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant_id': tenantId,
      'is_completed': isCompleted,
      'progress': progress,
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  OnboardingStatusModel copyWith({
    String? id,
    String? tenantId,
    bool? isCompleted,
    Map<String, dynamic>? progress,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OnboardingStatusModel(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      isCompleted: isCompleted ?? this.isCompleted,
      progress: progress ?? this.progress,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tenantId,
        isCompleted,
        progress,
        completedAt,
        createdAt,
        updatedAt,
      ];
}