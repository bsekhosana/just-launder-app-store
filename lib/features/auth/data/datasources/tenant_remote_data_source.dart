import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tenant_model.dart';
import '../../onboarding/data/models/onboarding_status_model.dart';

/// Remote data source for tenant authentication API calls
class TenantRemoteDataSource {
  static const String baseUrl = 'https://justlaunder.co.uk/api/v1';
  static const String localBaseUrl = 'http://127.0.0.1:8000/api/v1';

  // Use local URL for development, production URL for release
  static String get apiBaseUrl =>
      const bool.fromEnvironment('dart.vm.product') ? baseUrl : localBaseUrl;

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
        Uri.parse('$apiBaseUrl/auth/tenant/forgot-password'),
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
        Uri.parse('$apiBaseUrl/auth/tenant/reset-password'),
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
        Uri.parse('$apiBaseUrl/tenant/logout'),
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
        return {
          'success': false,
          'error': jsonData['message'] ?? 'Request failed',
          'statusCode': statusCode,
          'errors': jsonData['errors'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to parse response: $e',
        'statusCode': statusCode,
      };
    }
  }

  /// Check if user is authenticated
  static bool get isAuthenticated => _authToken != null;

  /// Get current auth token
  static String? get authToken => _authToken;
}
