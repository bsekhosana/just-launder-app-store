import 'package:equatable/equatable.dart';

class OnboardingStepModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final bool isOptional;
  final String? icon;
  final Map<String, dynamic>? data;

  const OnboardingStepModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    this.isOptional = false,
    this.icon,
    this.data,
  });

  factory OnboardingStepModel.fromJson(Map<String, dynamic> json) {
    return OnboardingStepModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['is_completed'] as bool,
      isOptional: json['is_optional'] as bool? ?? false,
      icon: json['icon'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
      'is_optional': isOptional,
      'icon': icon,
      'data': data,
    };
  }

  OnboardingStepModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    bool? isOptional,
    String? icon,
    Map<String, dynamic>? data,
  }) {
    return OnboardingStepModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isOptional: isOptional ?? this.isOptional,
      icon: icon ?? this.icon,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isCompleted,
        isOptional,
        icon,
        data,
      ];
}
