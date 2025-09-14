import 'package:flutter/material.dart';

/// Authentication provider for laundrette management app
class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _currentUserId;
  String? _currentLaundretteId;
  String? _pendingEmail;
  String? _pendingOTP;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get currentUserId => _currentUserId;
  String? get currentLaundretteId => _currentLaundretteId;
  String? get pendingEmail => _pendingEmail;
  String? get pendingOTP => _pendingOTP;

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock authentication - replace with real API call
      if (email == 'business@laundrette.com' && password == 'password') {
        _isAuthenticated = true;
        _currentUserId = 'user_business_1';
        _currentLaundretteId = 'laundrette_business_1';
        _isLoading = false;
        notifyListeners();
        return true;
      } else if (email == 'private@laundrette.com' && password == 'password') {
        _isAuthenticated = true;
        _currentUserId = 'user_private_1';
        _currentLaundretteId = 'laundrette_private_1';
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
    _isAuthenticated = false;
    _currentUserId = null;
    _currentLaundretteId = null;
    notifyListeners();
  }

  /// Register new account
  Future<bool> register({
    required String businessName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock registration - in real app, call registration API
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
      await Future.delayed(const Duration(seconds: 1));

      // Mock - in real app, check stored token
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
}
