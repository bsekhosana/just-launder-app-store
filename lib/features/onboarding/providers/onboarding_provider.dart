import 'package:flutter/material.dart';
import '../../auth/data/datasources/tenant_remote_data_source.dart';
import '../data/models/onboarding_status_model.dart';

/// Onboarding provider for tenant app
class OnboardingProvider extends ChangeNotifier {
  OnboardingStatusModel? _onboardingStatus;
  bool _isLoading = false;
  String? _error;

  // Getters
  OnboardingStatusModel? get onboardingStatus => _onboardingStatus;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load onboarding status
  Future<void> loadOnboardingStatus() async {
    _setLoading(true);
    _clearError();

    try {
      print('🌐 API: Calling getOnboardingStatus...');
      final response = await TenantRemoteDataSource().getOnboardingStatus();
      print('🌐 API: Response received: $response');

      if (response['success'] == true && response['data'] != null) {
        print('🌐 API: Parsing onboarding status data...');
        _onboardingStatus = OnboardingStatusModel.fromJson(response['data']);
        print(
          '🌐 API: Status parsed successfully - Completed: ${_onboardingStatus!.isCompleted}, Steps: ${_onboardingStatus!.completedSteps.length}/${_onboardingStatus!.totalSteps}',
        );
      } else {
        print('🌐 API: Error in response: ${response['error']}');
        _setError(response['error'] ?? 'Failed to load onboarding status');
      }
    } catch (e) {
      print('🌐 API: Exception occurred: $e');
      _setError('Failed to load onboarding status: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load onboarding progress
  Future<void> loadOnboardingProgress() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await TenantRemoteDataSource().getOnboardingProgress();

      if (response['success'] == true && response['data'] != null) {
        _onboardingStatus = OnboardingStatusModel.fromJson(response['data']);
      } else {
        _setError(response['error'] ?? 'Failed to load onboarding progress');
      }
    } catch (e) {
      _setError('Failed to load onboarding progress: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Submit onboarding
  Future<bool> submitOnboarding() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await TenantRemoteDataSource().submitOnboarding();

      if (response['success'] == true) {
        // Reload status after submission
        await loadOnboardingStatus();
        return true;
      } else {
        _setError(response['error'] ?? 'Failed to submit onboarding');
        return false;
      }
    } catch (e) {
      _setError('Failed to submit onboarding: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh onboarding data
  Future<void> refresh() async {
    await loadOnboardingStatus();
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
