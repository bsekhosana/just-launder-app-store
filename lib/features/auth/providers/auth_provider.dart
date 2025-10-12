import 'package:flutter/material.dart';
import '../data/datasources/tenant_remote_data_source.dart';
import '../data/datasources/tenant_local_data_source.dart';
import '../data/models/tenant_model.dart';
import '../../../core/utils/log_helper.dart';

/// Authentication provider for laundrette management app
class AuthProvider extends ChangeNotifier {
  final TenantLocalDataSource _localDataSource = TenantLocalDataSource();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  bool _isInitializing = false;
  String? _error;
  TenantModel? _currentTenant;
  String? _pendingEmail;
  String? _pendingOTP;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get isInitializing => _isInitializing;
  String? get error => _error;
  TenantModel? get currentTenant => _currentTenant;
  String? get currentUserId => _currentTenant?.id.toString();
  String? get currentLaundretteId => _currentTenant?.id.toString();
  String? get pendingEmail => _pendingEmail;
  String? get pendingOTP => _pendingOTP;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setInitializing(bool initializing) {
    _isInitializing = initializing;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  /// Initialize authentication state on app start
  Future<void> initialize() async {
    _setInitializing(true);

    try {
      // Initialize remote data source with device info
      await TenantRemoteDataSource.initialize(
        deviceId: 'device_${DateTime.now().millisecondsSinceEpoch}',
        deviceName: 'Laundrette App',
        platform: 'android',
      );

      // Check if tenant is authenticated
      _isAuthenticated = await _localDataSource.isAuthenticated();

      if (_isAuthenticated) {
        // Load stored tenant data
        _currentTenant = await _localDataSource.getStoredTenant();

        // Load stored auth token
        final token = await _localDataSource.getAuthToken();
        if (token != null) {
          await TenantRemoteDataSource.setAuthToken(token);
        }

        LogHelper.auth(
          'Initialized with stored tenant: ${_currentTenant?.email}',
        );
      }
    } catch (e) {
      LogHelper.error('Failed to initialize authentication: ${e.toString()}');
      _setError('Failed to initialize authentication: ${e.toString()}');
    } finally {
      _setInitializing(false);
    }
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _clearError();
    notifyListeners();

    try {
      final response = await TenantRemoteDataSource().login(
        email: email,
        password: password,
      );

      LogHelper.auth(
        'Login response - success: ${response['success']}, error: ${response['error']}',
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        final tenantData = data['tenant'];
        final token = data['token'];

        LogHelper.auth('Login successful - setting token and tenant data');

        // Update tenant data
        _isAuthenticated = true;
        _currentTenant = TenantModel.fromJson(tenantData);

        // Store tenant data and token locally for persistence
        await _localDataSource.storeTenant(_currentTenant!, token);

        // Set authentication token for API calls
        await TenantRemoteDataSource.setAuthToken(token);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        LogHelper.auth('Login failed - error: ${response['error']}');
        _setError(response['error'] ?? 'Login failed');
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      LogHelper.error('Login exception: $e');
      _setError('Login error: ${e.toString()}');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Force logout (for handling 401 errors)
  Future<void> forceLogout() async {
    try {
      LogHelper.auth('Force logout triggered - clearing authentication state');

      // Clear authentication state
      _isAuthenticated = false;
      _currentTenant = null;
      _pendingEmail = null;
      _pendingOTP = null;
      _clearError();

      // Clear stored data
      await _localDataSource.clearAll();
      await TenantRemoteDataSource.clearAuthToken();

      LogHelper.auth('Force logout completed');
      notifyListeners();
    } catch (e) {
      LogHelper.error('Error during force logout: $e');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      // Call logout API
      await TenantRemoteDataSource().logout();
    } catch (e) {
      // Continue with logout even if API call fails
      LogHelper.error('Logout API call failed: $e');
    }

    // Clear all stored data
    await _localDataSource.clearAll();
    await TenantRemoteDataSource.clearAuthToken();

    // Clear local state
    _isAuthenticated = false;
    _currentTenant = null;
    _error = null;
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
    _clearError();
    notifyListeners();

    try {
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

        // Update tenant data
        _isAuthenticated = true;
        _currentTenant = TenantModel.fromJson(tenantData);

        // Store tenant data and token locally for persistence
        await _localDataSource.storeTenant(_currentTenant!, token);

        // Set authentication token for API calls
        await TenantRemoteDataSource.setAuthToken(token);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _setError(response['error'] ?? 'Registration failed');
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _setError('Registration error: ${e.toString()}');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await TenantRemoteDataSource().forgotPassword(email);

      if (response.success) {
        _pendingEmail = email;
        _setLoading(false);
        return true;
      } else {
        _setError(response.error ?? 'Failed to send reset email');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('An error occurred: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Verify OTP code (for password reset)
  Future<bool> verifyOTP(String email, String otp) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await TenantRemoteDataSource().verifyOtp(
        email: email,
        otp: otp,
      );

      if (response.success) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'OTP verification failed');
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      LogHelper.error('Error verifying OTP: $e');
      _setError('Error verifying OTP: $e');
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
      // Mark onboarding as completed locally
      if (_currentTenant != null) {
        // Update the current tenant's onboarding status
        _isAuthenticated = true;
        _pendingEmail = null;
        _pendingOTP = null;

        // Update local storage
        await _localDataSource.updateOnboardingStatus(true);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      LogHelper.error('Error completing onboarding: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Check email verification status
  Future<bool> checkEmailVerificationStatus(String email) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await TenantRemoteDataSource()
          .checkEmailVerificationStatus(email);

      if (response.success && response.data != null) {
        final isVerified = response.data!['verified'] ?? false;

        // Update local storage if verified
        if (isVerified && _currentTenant != null) {
          await _localDataSource.updateEmailVerificationStatus(true);
          _currentTenant = _currentTenant!.copyWith(
            emailVerifiedAt: DateTime.now(),
          );
          notifyListeners();
        }

        _setLoading(false);
        return isVerified;
      } else {
        _setError(response.error ?? 'Failed to check verification status');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('An error occurred: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Resend verification email
  Future<bool> resendVerificationEmail(String email) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await TenantRemoteDataSource().resendVerificationEmail(
        email,
      );

      if (response.success) {
        _setLoading(false);
        return true;
      } else {
        _setError(response.error ?? 'Failed to resend verification email');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('An error occurred: ${e.toString()}');
      _setLoading(false);
      return false;
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

      LogHelper.auth(
        'Tenant profile update response - success: ${response.success}, data: ${response.data}, error: ${response.error}',
      );

      if (response.success && response.data != null) {
        // Update the current tenant with new data
        if (_currentTenant != null) {
          _currentTenant = TenantModel.fromJson(response.data!);

          // Update local storage
          await _localDataSource.updateTenant(_currentTenant!);
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

  /// Update tenant profile (wrapper for updateProfileWithOtp)
  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    String? mobile,
    String? otp,
  }) async {
    return await updateProfileWithOtp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      mobile: mobile,
      otp: otp,
    );
  }

  /// Send OTP for profile changes
  Future<bool> sendProfileOtp({required String type}) async {
    try {
      _setLoading(true);
      _clearError();

      LogHelper.auth('Sending tenant profile OTP for type: $type');

      final response = await TenantRemoteDataSource().sendProfileOtp(
        type: type,
      );

      LogHelper.auth(
        'Send tenant profile OTP response - success: ${response.success}, error: ${response.error}',
      );

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

  /// Get current user (alias for currentTenant)
  TenantModel? get currentUser => _currentTenant;

  /// Forgot password
  Future<bool> forgotPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();
      LogHelper.auth('Sending password reset for email: $email');
      final response = await TenantRemoteDataSource().forgotPassword(email);
      LogHelper.auth(
        'Forgot password response - success: ${response.success}, error: ${response.error}',
      );
      if (response.success) {
        LogHelper.auth('Password reset email sent successfully');
        return true;
      } else {
        _setError(response.error ?? 'Failed to send password reset email');
        LogHelper.auth('Forgot password failed: ${response.error}');
        return false;
      }
    } catch (e) {
      _setError('Failed to send password reset email: $e');
      LogHelper.error('Forgot password exception: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Reset password
  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      LogHelper.auth('Resetting password for email: $email');
      final response = await TenantRemoteDataSource().resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      LogHelper.auth(
        'Reset password response - success: ${response.success}, error: ${response.error}',
      );
      if (response.success) {
        LogHelper.auth('Password reset successfully');
        return true;
      } else {
        _setError(response.error ?? 'Failed to reset password');
        LogHelper.auth('Reset password failed: ${response.error}');
        return false;
      }
    } catch (e) {
      _setError('Failed to reset password: $e');
      LogHelper.error('Reset password exception: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
