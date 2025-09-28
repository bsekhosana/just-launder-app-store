/// Onboarding status model for tenant app
class OnboardingStatusModel {
  final bool isCompleted;
  final String currentStep;
  final List<OnboardingStepModel> steps;
  final Map<String, dynamic>? summary;

  const OnboardingStatusModel({
    required this.isCompleted,
    required this.currentStep,
    required this.steps,
    this.summary,
  });

  factory OnboardingStatusModel.fromJson(Map<String, dynamic> json) {
    return OnboardingStatusModel(
      isCompleted: json['is_completed'] as bool,
      currentStep: json['current_step'] as String,
      steps:
          (json['steps'] as List<dynamic>)
              .map(
                (step) =>
                    OnboardingStepModel.fromJson(step as Map<String, dynamic>),
              )
              .toList(),
      summary: json['summary'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_completed': isCompleted,
      'current_step': currentStep,
      'steps': steps.map((step) => step.toJson()).toList(),
      'summary': summary,
    };
  }

  @override
  String toString() {
    return 'OnboardingStatusModel(isCompleted: $isCompleted, currentStep: $currentStep, steps: ${steps.length})';
  }
}

/// Individual onboarding step model
class OnboardingStepModel {
  final String id;
  final String name;
  final String description;
  final String status; // 'pending', 'in_progress', 'completed'
  final bool isRequired;
  final String? icon;
  final Map<String, dynamic>? data;

  const OnboardingStepModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.isRequired,
    this.icon,
    this.data,
  });

  factory OnboardingStepModel.fromJson(Map<String, dynamic> json) {
    return OnboardingStepModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      isRequired: json['is_required'] as bool,
      icon: json['icon'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'is_required': isRequired,
      'icon': icon,
      'data': data,
    };
  }

  bool get isCompleted => status == 'completed';
  bool get isInProgress => status == 'in_progress';
  bool get isPending => status == 'pending';

  @override
  String toString() {
    return 'OnboardingStepModel(id: $id, name: $name, status: $status)';
  }
}
