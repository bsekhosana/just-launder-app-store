import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tenant_model.dart';
import '../models/api_response_model.dart';
import '../../../onboarding/data/models/onboarding_status_model.dart';
import '../../../../core/utils/log_helper.dart';

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
    'X-App-Type': 'laundrette', // Mandatory app type for all API calls
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
          'app_type': 'laundrette',
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
          'app_type': 'laundrette',
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
  Future<ApiResponseModel<Map<String, dynamic>>> forgotPassword(
    String email,
  ) async {
    try {
      LogHelper.api(
        'Making forgot password request to $apiBaseUrl/auth/tenant/forgot-password',
      );
      LogHelper.api('Forgot password payload: ${jsonEncode({'email': email})}');

      final response = await http.post(
        Uri.parse('$apiBaseUrl/auth/tenant/forgot-password'),
        headers: _headers,
        body: jsonEncode({'email': email, 'app_type': 'laundrette'}),
      );

      LogHelper.api('Forgot password response status: ${response.statusCode}');
      LogHelper.api('Forgot password response body: ${response.body}');

      return _handleApiResponse<Map<String, dynamic>>(response);
    } on SocketException {
      return ApiResponseModel.error('No internet connection');
    } on HttpException catch (e) {
      return ApiResponseModel.error('HTTP error: ${e.message}');
    } catch (e) {
      return ApiResponseModel.error('Unexpected error: $e');
    }
  }

  /// Verify OTP code
  Future<ApiResponseModel<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      LogHelper.api(
        'Making verify OTP request to $apiBaseUrl/tenant/verify-otp',
      );
      LogHelper.api(
        'Verify OTP payload: ${jsonEncode({'email': email, 'otp': otp})}',
      );

      final response = await http.post(
        Uri.parse('$apiBaseUrl/tenant/verify-otp'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'app_type': 'laundrette',
        }),
      );

      LogHelper.api('Verify OTP response status: ${response.statusCode}');
      LogHelper.api('Verify OTP response body: ${response.body}');

      return _handleApiResponse<Map<String, dynamic>>(response);
    } on SocketException {
      return ApiResponseModel.error('No internet connection');
    } on HttpException catch (e) {
      return ApiResponseModel.error('HTTP error: ${e.message}');
    } catch (e) {
      return ApiResponseModel.error('Unexpected error: $e');
    }
  }

  /// Reset password with OTP
  Future<ApiResponseModel<Map<String, dynamic>>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      LogHelper.api(
        'Making reset password request to $apiBaseUrl/tenant/reset-password',
      );
      LogHelper.api(
        'Reset password payload: ${jsonEncode({'email': email, 'otp': otp, 'password': newPassword, 'password_confirmation': confirmPassword})}',
      );

      final response = await http.post(
        Uri.parse('$apiBaseUrl/tenant/reset-password'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'password': newPassword,
          'password_confirmation': confirmPassword,
          'app_type': 'laundrette',
        }),
      );

      LogHelper.api('Reset password response status: ${response.statusCode}');
      LogHelper.api('Reset password response body: ${response.body}');

      return _handleApiResponse<Map<String, dynamic>>(response);
    } on SocketException {
      return ApiResponseModel.error('No internet connection');
    } on HttpException catch (e) {
      return ApiResponseModel.error('HTTP error: ${e.message}');
    } catch (e) {
      return ApiResponseModel.error('Unexpected error: $e');
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
      final url = '$apiBaseUrl/tenant/onboarding/status';
      print('🔍 Full URL: $url');
      print('🔍 API Base URL: $apiBaseUrl');
      print('🔍 Has Auth Token: ${_authToken != null}');

      final response = await http.get(Uri.parse(url), headers: _headers);

      print('🔍 Response Status: ${response.statusCode}');
      print('🔍 Response Body: ${response.body}');

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

  /// Update tenant profile with OTP support
  Future<ApiResponseModel<Map<String, dynamic>>> updateProfileWithOtp({
    required String firstName,
    required String lastName,
    required String email,
    String? mobile,
    String? otp,
  }) async {
    try {
      if (_authToken == null) {
        throw Exception('User not authenticated');
      }

      final data = <String, dynamic>{
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        if (mobile != null) 'mobile': mobile,
        if (otp != null) 'otp': otp,
      };

      LogHelper.api(
        'Making profile update request to $apiBaseUrl/tenant/profile',
      );
      LogHelper.api('Profile update payload: ${jsonEncode(data)}');

      final response = await http.put(
        Uri.parse('$apiBaseUrl/tenant/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
          'Accept': 'application/json',
          'X-App-Type': 'laundrette',
        },
        body: jsonEncode(data),
      );

      LogHelper.api('Profile update response status: ${response.statusCode}');
      LogHelper.api('Profile update response body: ${response.body}');

      return _handleApiResponse<Map<String, dynamic>>(response);
    } on SocketException {
      return ApiResponseModel.error('No internet connection');
    } on HttpException catch (e) {
      return ApiResponseModel.error('HTTP error: ${e.message}');
    } catch (e) {
      return ApiResponseModel.error('Unexpected error: $e');
    }
  }

  /// Send OTP for profile changes
  Future<ApiResponseModel<Map<String, dynamic>>> sendProfileOtp({
    required String type,
  }) async {
    try {
      if (_authToken == null) {
        throw Exception('User not authenticated');
      }

      final data = <String, dynamic>{'type': type};

      LogHelper.api(
        'Making send profile OTP request to $apiBaseUrl/tenant/profile/send-otp',
      );

      final response = await http.post(
        Uri.parse('$apiBaseUrl/tenant/profile/send-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
          'Accept': 'application/json',
          'X-App-Type': 'laundrette',
        },
        body: jsonEncode(data),
      );

      LogHelper.api('Send profile OTP response status: ${response.statusCode}');
      LogHelper.api('Send profile OTP response body: ${response.body}');

      return _handleApiResponse<Map<String, dynamic>>(response);
    } on SocketException {
      return ApiResponseModel.error('No internet connection');
    } on HttpException catch (e) {
      return ApiResponseModel.error('HTTP error: ${e.message}');
    } catch (e) {
      return ApiResponseModel.error('Unexpected error: $e');
    }
  }

  /// Handle API response for new methods (returns ApiResponseModel)
  ApiResponseModel<T> _handleApiResponse<T>(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    LogHelper.api('_handleApiResponse: Status code: $statusCode');
    LogHelper.api('_handleApiResponse: Body: $body');

    try {
      final jsonData = jsonDecode(body);
      LogHelper.api('_handleApiResponse: Parsed JSON: $jsonData');

      if (statusCode >= 200 && statusCode < 300) {
        final success = jsonData['success'] ?? true;
        final message = jsonData['message'];
        final data = jsonData['data'];

        LogHelper.api(
          '_handleApiResponse: Success case - success: $success, message: $message, data: $data',
        );

        return ApiResponseModel<T>.success(data: data as T?, message: message);
      } else {
        final errorMessage =
            jsonData['message'] ?? jsonData['error'] ?? 'Request failed';
        LogHelper.api(
          '_handleApiResponse: Error case - status: $statusCode, message: $errorMessage',
        );

        return ApiResponseModel<T>.error(
          errorMessage,
          statusCode: statusCode,
          errors: jsonData['errors'],
        );
      }
    } catch (e) {
      LogHelper.error('_handleApiResponse: JSON parsing error: $e');
      String errorMessage = _getErrorMessage(statusCode, null);
      return ApiResponseModel<T>.error(errorMessage, statusCode: statusCode);
    }
  }

  /// Check email verification status
  Future<ApiResponseModel<Map<String, dynamic>>> checkEmailVerificationStatus(
    String email,
  ) async {
    try {
      LogHelper.api(
        'Making check email verification request to $apiBaseUrl/auth/tenant/email-verification-status',
      );
      LogHelper.api('Payload: ${jsonEncode({'email': email})}');

      final response = await http.post(
        Uri.parse('$apiBaseUrl/auth/tenant/email-verification-status'),
        headers: _headers,
        body: jsonEncode({'email': email, 'app_type': 'laundrette'}),
      );

      LogHelper.api(
        'Email verification status response: ${response.statusCode}',
      );
      LogHelper.api('Email verification status body: ${response.body}');

      return _handleApiResponse<Map<String, dynamic>>(response);
    } on SocketException {
      return ApiResponseModel.error('No internet connection');
    } on HttpException catch (e) {
      return ApiResponseModel.error('HTTP error: ${e.message}');
    } catch (e) {
      return ApiResponseModel.error('Unexpected error: $e');
    }
  }

  /// Resend verification email
  Future<ApiResponseModel<Map<String, dynamic>>> resendVerificationEmail(
    String email,
  ) async {
    try {
      LogHelper.api(
        'Making resend verification email request to $apiBaseUrl/auth/tenant/resend-verification-email',
      );
      LogHelper.api('Payload: ${jsonEncode({'email': email})}');

      final response = await http.post(
        Uri.parse('$apiBaseUrl/auth/tenant/resend-verification-email'),
        headers: _headers,
        body: jsonEncode({'email': email, 'app_type': 'laundrette'}),
      );

      LogHelper.api(
        'Resend verification email response: ${response.statusCode}',
      );
      LogHelper.api('Resend verification email body: ${response.body}');

      return _handleApiResponse<Map<String, dynamic>>(response);
    } on SocketException {
      return ApiResponseModel.error('No internet connection');
    } on HttpException catch (e) {
      return ApiResponseModel.error('HTTP error: ${e.message}');
    } catch (e) {
      return ApiResponseModel.error('Unexpected error: $e');
    }
  }

  /// Check if user is authenticated
  static bool get isAuthenticated => _authToken != null;

  /// Get current auth token
  static String? get authToken => _authToken;
}
