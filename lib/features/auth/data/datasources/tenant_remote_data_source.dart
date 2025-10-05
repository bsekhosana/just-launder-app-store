import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tenant_model.dart';
import '../../onboarding/data/models/onboarding_status_model.dart';

/// Remote data source for tenant authentication API calls
class TenantRemoteDataSource {
  static const String baseUrl = 'https://justlaunder.co.uk/api/v1';

  // Always use production URL
  static String get apiBaseUrl => baseUrl;

  static String? _authToken;
  static String? _deviceId;
  static String? _deviceName;
  static String? _platform;

  /// Initialize with device information
  static Future<void> initialize({
    required String deviceId,
    String? deviceName,
    String? platform,
  }) async {
    _deviceId = deviceId;
    _deviceName = deviceName;
    _platform = platform ?? 'android';

    // Load stored auth token
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
  }

  /// Set authentication token
  static Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Clear authentication token
  static Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  /// Get headers for API requests
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    if (_deviceId != null) 'X-Device-ID': _deviceId!,
    if (_deviceName != null) 'X-Device-Name': _deviceName!,
    if (_platform != null) 'X-Platform': _platform!,
  };

  /// Tenant registration
  Future<Map<String, dynamic>> register({
    required String tenantType,
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
    required bool termsAccepted,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/auth/tenant/register'),
        headers: _headers,
        body: jsonEncode({
          'tenant_type': tenantType,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'mobile': mobile,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'terms_accepted': termsAccepted,
          'device_id': _deviceId,
          'device_name': _deviceName,
        }),
      );

      return _handleResponse(response);
    } on SocketException {
      return {'success': false, 'error': 'No internet connection'};
    } on HttpException catch (e) {
      return {'success': false, 'error': 'HTTP error: ${e.message}'};
    } catch (e) {
      return {'success': false, 'error': 'Unexpected error: $e'};
    }
  }

  /// Tenant login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/auth/tenant/login'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
          'device_id': _deviceId,
          'device_name': _deviceName,
        }),
      );

      return _handleResponse(response);
    } on SocketException {
      return {'success': false, 'error': 'No internet connection'};
    } on HttpException catch (e) {
      return {'success': false, 'error': 'HTTP error: ${e.message}'};
    } catch (e) {
      return {'success': false, 'error': 'Unexpected error: $e'};
    }
  }

  /// Forgot password
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/v1/auth/tenant/forgot-password'),
        headers: _headers,
        body: jsonEncode({'email': email}),
      );

      return _handleResponse(response);
    } on SocketException {
      return {'success': false, 'error': 'No internet connection'};
    } on HttpException catch (e) {
      return {'success': false, 'error': 'HTTP error: ${e.message}'};
    } catch (e) {
      return {'success': false, 'error': 'Unexpected error: $e'};
    }
  }

  /// Reset password with OTP
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/v1/auth/tenant/reset-password'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      return _handleResponse(response);
    } on SocketException {
      return {'success': false, 'error': 'No internet connection'};
    } on HttpException catch (e) {
      return {'success': false, 'error': 'HTTP error: ${e.message}'};
    } catch (e) {
      return {'success': false, 'error': 'Unexpected error: $e'};
    }
  }

  /// Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/v1/tenant/logout'),
        headers: _headers,
      );

      return _handleResponse(response);
    } on SocketException {
      return {'success': false, 'error': 'No internet connection'};
    } on HttpException catch (e) {
      return {'success': false, 'error': 'HTTP error: ${e.message}'};
    } catch (e) {
      return {'success': false, 'error': 'Unexpected error: $e'};
    }
  }

  /// Get onboarding status
  Future<Map<String, dynamic>> getOnboardingStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/tenant/onboarding/status'),
        headers: _headers,
      );

      return _handleResponse(response);
    } on SocketException {
      return {'success': false, 'error': 'No internet connection'};
    } on HttpException catch (e) {
      return {'success': false, 'error': 'HTTP error: ${e.message}'};
    } catch (e) {
      return {'success': false, 'error': 'Unexpected error: $e'};
    }
  }

  /// Get onboarding progress
  Future<Map<String, dynamic>> getOnboardingProgress() async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/tenant/onboarding/progress'),
        headers: _headers,
      );

      return _handleResponse(response);
    } on SocketException {
      return {'success': false, 'error': 'No internet connection'};
    } on HttpException catch (e) {
      return {'success': false, 'error': 'HTTP error: ${e.message}'};
    } catch (e) {
      return {'success': false, 'error': 'Unexpected error: $e'};
    }
  }

  /// Submit onboarding
  Future<Map<String, dynamic>> submitOnboarding() async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/tenant/onboarding/submit'),
        headers: _headers,
      );

      return _handleResponse(response);
    } on SocketException {
      return {'success': false, 'error': 'No internet connection'};
    } on HttpException catch (e) {
      return {'success': false, 'error': 'HTTP error: ${e.message}'};
    } catch (e) {
      return {'success': false, 'error': 'Unexpected error: $e'};
    }
  }

  /// Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    try {
      final jsonData = jsonDecode(body);

      if (statusCode >= 200 && statusCode < 300) {
        return {
          'success': jsonData['success'] ?? true,
          'data': jsonData['data'],
          'message': jsonData['message'],
        };
      } else {
        // Handle specific error cases
        String errorMessage = _getErrorMessage(statusCode, jsonData);

        return {
          'success': false,
          'error': errorMessage,
          'statusCode': statusCode,
          'errors': jsonData['errors'],
        };
      }
    } catch (e) {
      // Handle JSON parsing errors
      String errorMessage = _getErrorMessage(statusCode, null);
      return {
        'success': false,
        'error': errorMessage,
        'statusCode': statusCode,
      };
    }
  }

  /// Get user-friendly error message based on status code
  String _getErrorMessage(int statusCode, Map<String, dynamic>? jsonData) {
    // Priority 1: Try to get message from API response first
    if (jsonData != null && jsonData['message'] != null) {
      final apiMessage = jsonData['message'] as String;
      if (apiMessage.isNotEmpty) {
        return apiMessage;
      }
    }

    // Priority 2: Try to get validation errors from API response
    if (jsonData != null && jsonData['errors'] != null) {
      final errors = jsonData['errors'] as Map<String, dynamic>;
      if (errors.isNotEmpty) {
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          final errorMessage = firstError.first as String;
          if (errorMessage.isNotEmpty) {
            return errorMessage;
          }
        }
      }
    }

    // Priority 3: Apply our own fallback messages based on status code
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input and try again.';
      case 401:
        return 'Invalid email or password. Please check your credentials and try again.';
      case 403:
        return 'Access denied. You do not have permission to perform this action.';
      case 404:
        return 'The requested resource was not found.';
      case 422:
        return 'Validation failed. Please check your input and try again.';
      case 429:
        return 'Too many requests. Please wait a moment and try again.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
      case 503:
      case 504:
        return 'Service temporarily unavailable. Please try again later.';
      default:
        return 'Request failed. Please try again.';
    }
  }

  /// Check if user is authenticated
  static bool get isAuthenticated => _authToken != null;

  /// Get current auth token
  static String? get authToken => _authToken;
}
