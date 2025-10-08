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

    // Get web URL and ensure it points to admin dashboard for authenticated users
    // The admin dashboard automatically shows onboarding steps for incomplete onboarding
    String webUrl = json['web_url'] as String? ?? 'https://justlaunder.co.uk';
    if (!webUrl.contains('/admin') && !webUrl.contains('/tenant')) {
      // If base URL, append admin/dashboard (where onboarding continues for logged-in users)
      webUrl =
          webUrl.endsWith('/')
              ? '${webUrl}admin/dashboard'
              : '$webUrl/admin/dashboard';
    }

    return OnboardingStatusModel(
      tenantId: json['tenant_id']?.toString() ?? '',
      isCompleted:
          OnboardingStep._parseBool(json['onboarding_completed']) ?? false,
      currentStep: _parseCurrentStep(json['current_step']),
      completedSteps: completedStepsList,
      totalSteps: json['total_steps'] as int? ?? 7,
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
  static int _parseCurrentStep(dynamic value) {
    if (value == null) return 1;
    if (value is int) return value;
    if (value is String) {
      // Map step IDs to step numbers
      switch (value) {
        case 'personal_info':
          return 1;
        case 'business_info':
          return 2;
        case 'business_documents':
          return 3;
        case 'bank_details':
          return 4;
        case 'subscription':
          return 5;
        case 'branches':
          return 6;
        case 'service_items':
          return 7;
        default:
          return 1;
      }
    }
    return 1;
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
