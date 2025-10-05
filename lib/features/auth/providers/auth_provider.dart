import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/datasources/tenant_remote_data_source.dart';
import '../data/models/tenant_model.dart';
import '../../../core/utils/log_helper.dart';

/// Authentication provider for laundrette management app
class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  bool _isInitializing = false;
  TenantModel? _currentTenant;
  String? _pendingEmail;
  String? _pendingOTP;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get isInitializing => _isInitializing;
  TenantModel? get currentTenant => _currentTenant;
  String? get currentUserId => _currentTenant?.id.toString();
  String? get currentLaundretteId => _currentTenant?.id.toString();
  String? get pendingEmail => _pendingEmail;
  String? get pendingOTP => _pendingOTP;

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Initialize remote data source if not already done
      await TenantRemoteDataSource.initialize(
        deviceId: 'device_${DateTime.now().millisecondsSinceEpoch}',
        deviceName: 'Laundrette App',
        platform: 'android',
      );

      final response = await TenantRemoteDataSource().login(
        email: email,
        password: password,
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        final tenantData = data['tenant'];
        final token = data['token'];

        // Set authentication token
        await TenantRemoteDataSource.setAuthToken(token);

        // Update tenant data
        _isAuthenticated = true;
        _currentTenant = TenantModel.fromJson(tenantData);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      // Call logout API
      await TenantRemoteDataSource().logout();
    } catch (e) {
      // Continue with logout even if API call fails
    }

    // Clear local state
    _isAuthenticated = false;
    _currentTenant = null;
    notifyListeners();
  }

  /// Register new account
  Future<bool> register({
    required String tenantType,
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
    required bool termsAccepted,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Initialize remote data source if not already done
      await TenantRemoteDataSource.initialize(
        deviceId: 'device_${DateTime.now().millisecondsSinceEpoch}',
        deviceName: 'Laundrette App',
        platform: 'android',
      );

      final response = await TenantRemoteDataSource().register(
        tenantType: tenantType,
        firstName: firstName,
        lastName: lastName,
        email: email,
        mobile: mobile,
        password: password,
        passwordConfirmation: passwordConfirmation,
        termsAccepted: termsAccepted,
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        final tenantData = data['tenant'];
        final token = data['token'];

        // Set authentication token
        await TenantRemoteDataSource.setAuthToken(token);

        // Update tenant data
        _isAuthenticated = true;
        _currentTenant = TenantModel.fromJson(tenantData);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock - in real app, send reset email
      _pendingEmail = email;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Verify OTP
  Future<bool> verifyOTP(String otp) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock OTP verification - in real app, verify with backend
      if (otp == '123456') {
        _pendingOTP = otp;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Reset password
  Future<bool> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock password reset - in real app, call reset API
      _pendingEmail = null;
      _pendingOTP = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Complete onboarding
  Future<bool> completeOnboarding() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock onboarding completion
      _isAuthenticated = true;
      _currentUserId = 'user_new_1';
      _currentLaundretteId = 'laundrette_new_1';
      _pendingEmail = null;
      _pendingOTP = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Check authentication status
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate checking stored auth token
      await Future.delayed(const Duration(milliseconds: 100));

      // Mock - in real app, check stored token
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update tenant profile with OTP support
  Future<bool> updateProfileWithOtp({
    required String firstName,
    required String lastName,
    required String email,
    String? mobile,
    String? otp,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      LogHelper.auth('Updating tenant profile for user: $email');

      final response = await TenantRemoteDataSource().updateProfileWithOtp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        mobile: mobile,
        otp: otp,
      );

      LogHelper.auth('Tenant profile update response - success: ${response.success}, data: ${response.data}, error: ${response.error}');

      if (response.success && response.data != null) {
        // Update the current tenant with new data
        if (_currentTenant != null) {
          _currentTenant = TenantModel.fromJson(response.data!);
          await _saveTenantToStorage();
        }
        LogHelper.auth('Tenant profile updated successfully');
        return true;
      } else {
        _setError(response.error ?? 'Failed to update profile');
        LogHelper.auth('Tenant profile update failed: ${response.error}');
        return false;
      }
    } catch (e) {
      _setError('Failed to update profile: $e');
      LogHelper.error('Tenant profile update exception: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Send OTP for profile changes
  Future<bool> sendProfileOtp({
    required String type,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      LogHelper.auth('Sending tenant profile OTP for type: $type');

      final response = await TenantRemoteDataSource().sendProfileOtp(type: type);

      LogHelper.auth('Send tenant profile OTP response - success: ${response.success}, error: ${response.error}');

      if (response.success) {
        LogHelper.auth('Tenant profile OTP sent successfully');
        return true;
      } else {
        _setError(response.error ?? 'Failed to send OTP');
        LogHelper.auth('Send tenant profile OTP failed: ${response.error}');
        return false;
      }
    } catch (e) {
      _setError('Failed to send OTP: $e');
      LogHelper.error('Send tenant profile OTP exception: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Save tenant to storage
  Future<void> _saveTenantToStorage() async {
    if (_currentTenant != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('tenant_data', jsonEncode(_currentTenant!.toJson()));
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set initializing state
  void _setInitializing(bool initializing) {
    _isInitializing = initializing;
    notifyListeners();
  }
}
