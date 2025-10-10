import 'package:flutter/material.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../utils/log_helper.dart';
import '../widgets/custom_snackbar.dart';

/// Global authentication handler service
/// Handles authentication state changes across the app
class AuthHandlerService {
  static final AuthHandlerService _instance = AuthHandlerService._internal();
  factory AuthHandlerService() => _instance;
  AuthHandlerService._internal();

  AuthProvider? _authProvider;
  BuildContext? _context;

  /// Initialize the auth handler with provider and context
  void initialize(AuthProvider authProvider, BuildContext context) {
    _authProvider = authProvider;
    _context = context;
    LogHelper.auth('AuthHandlerService initialized');
  }

  /// Handle unauthorized access (401 errors)
  Future<void> handleUnauthorized() async {
    if (_authProvider == null || _context == null) {
      LogHelper.error(
        'AuthHandlerService not initialized - cannot handle unauthorized',
      );
      return;
    }

    try {
      LogHelper.auth('AuthHandlerService handling unauthorized access');

      // Show user notification about session expiry
      if (_context!.mounted) {
        CustomSnackbar.showInfo(
          _context!,
          message: 'Your session has expired. Please log in again.',
          duration: const Duration(seconds: 3),
        );
      }

      // Force logout through the provider
      await _authProvider!.forceLogout();

      LogHelper.auth('Unauthorized access handled - user logged out');
    } catch (e) {
      LogHelper.error('Error handling unauthorized access: $e');
    }
  }

  /// Check if handler is initialized
  bool get isInitialized => _authProvider != null && _context != null;
}
