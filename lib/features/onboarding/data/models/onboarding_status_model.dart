import 'package:equatable/equatable.dart';

class OnboardingStatusModel extends Equatable {
  final String tenantId;
  final bool isCompleted;
  final int currentStep;
  final List<String> completedSteps;
  final int totalSteps;
  final double progressPercentage;
  final List<OnboardingStep> steps;
  final String webUrl;
  final String? nextAction;

  const OnboardingStatusModel({
    required this.tenantId,
    required this.isCompleted,
    required this.currentStep,
    required this.completedSteps,
    required this.totalSteps,
    required this.progressPercentage,
    required this.steps,
    required this.webUrl,
    this.nextAction,
  });

  factory OnboardingStatusModel.fromJson(Map<String, dynamic> json) {
    final stepsData = json['steps'] as List<dynamic>? ?? [];
    final completedStepsList =
        (json['completed_steps'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    // Get web URL and ensure it points to tenant login page
    // Users will login and then be redirected to admin dashboard for onboarding
    String webUrl = json['web_url'] as String? ?? 'https://justlaunder.co.uk';
    if (!webUrl.contains('/admin') && !webUrl.contains('/tenant')) {
      // If base URL, append tenant/login (where users login to access onboarding)
      webUrl =
          webUrl.endsWith('/')
              ? '${webUrl}tenant/login'
              : '$webUrl/tenant/login';
    }

    return OnboardingStatusModel(
      tenantId: json['tenant_id']?.toString() ?? '',
      isCompleted:
          OnboardingStep._parseBool(json['onboarding_completed']) ?? false,
      currentStep: _parseCurrentStep(json['current_step']),
      completedSteps: completedStepsList,
      totalSteps: json['total_steps'] as int? ?? 5,
      progressPercentage:
          (json['progress_percentage'] as num?)?.toDouble() ?? 0.0,
      steps:
          stepsData
              .map(
                (step) => OnboardingStep.fromJson(step as Map<String, dynamic>),
              )
              .toList(),
      webUrl: webUrl,
      nextAction: json['next_action'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenant_id': tenantId,
      'onboarding_completed': isCompleted,
      'current_step': currentStep,
      'completed_steps': completedSteps,
      'total_steps': totalSteps,
      'progress_percentage': progressPercentage,
      'steps': steps.map((s) => s.toJson()).toList(),
      'web_url': webUrl,
      'next_action': nextAction,
    };
  }

  @override
  List<Object?> get props => [
    tenantId,
    isCompleted,
    currentStep,
    completedSteps,
    totalSteps,
    progressPercentage,
    steps,
    webUrl,
    nextAction,
  ];

  /// Helper method to parse current step from various types (int, string)
  /// This method is used for fallback only - the actual current step should be determined
  /// dynamically based on the steps fetched from the backend
  static int _parseCurrentStep(dynamic value) {
    if (value == null) return 1;
    if (value is int) return value;
    if (value is String) {
      // For string step IDs, return 1 as fallback
      // The actual current step will be determined dynamically in the UI
      return 1;
    }
    return 1;
  }

  /// Get the current step index based on the current step ID from backend
  /// This dynamically finds the step index in the steps array
  int get currentStepIndex {
    // Find the first step that is not completed
    for (int i = 0; i < steps.length; i++) {
      if (!completedSteps.contains(steps[i].id)) {
        return i;
      }
    }
    // If all steps are completed, return the last step
    return steps.length - 1;
  }

  /// Get the current step ID from backend (the step that needs to be completed next)
  String? get currentStepId {
    // Find the first step that is not completed
    for (final step in steps) {
      if (!completedSteps.contains(step.id)) {
        return step.id;
      }
    }
    // If all steps are completed, return null
    return null;
  }
}

class OnboardingStep extends Equatable {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool required;
  final bool webOnly;

  const OnboardingStep({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.required,
    this.webOnly = false,
  });

  factory OnboardingStep.fromJson(Map<String, dynamic> json) {
    return OnboardingStep(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String? ?? 'circle',
      required: _parseBool(json['required']) ?? true,
      webOnly: _parseBool(json['web_only']) ?? false,
    );
  }

  /// Helper method to parse bool from various types (bool, int, string)
  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == 'true' || lower == '1';
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'required': required,
      'web_only': webOnly,
    };
  }

  @override
  List<Object?> get props => [id, title, description, icon, required, webOnly];
}
