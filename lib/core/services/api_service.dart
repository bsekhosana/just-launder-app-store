import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// API Service for making HTTP requests to tenant endpoints (Singleton)
class ApiService {
  static const String baseUrl = 'https://justlaunder.co.uk';

  // Always use production URL
  static String get apiBaseUrl => baseUrl;

  // Singleton instance
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  String? _authToken;
  bool _tokenLoaded = false;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-App-Type': 'laundrette',
        },
      ),
    );

    _setupInterceptors();
    _loadAuthToken();
  }

  /// Setup request/response interceptors
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Ensure token is loaded before making request
          if (!_tokenLoaded) {
            await _loadAuthToken();
          }

          // Add auth token if available
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
            debugPrint('[API Tenant] 🔑 Adding auth header to ${options.path}');
          } else {
            debugPrint(
              '[API Tenant] ⚠️ No token available for ${options.path}',
            );
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
            '[API Tenant] ✅ ${response.requestOptions.method} ${response.requestOptions.path} - ${response.statusCode}',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint(
            '[API Tenant] ❌ ${error.requestOptions.method} ${error.requestOptions.path} - ${error.response?.statusCode}',
          );
          if (error.response?.statusCode == 401) {
            // Handle unauthorized access
            clearAuthToken();
          }
          handler.next(error);
        },
      ),
    );
  }

  /// Load auth token from storage
  Future<void> _loadAuthToken() async {
    if (_tokenLoaded) return;

    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
    _tokenLoaded = true;

    if (_authToken != null) {
      debugPrint(
        '[API Tenant] ✅ Auth token loaded: ${_authToken!.substring(0, 20)}...',
      );
    } else {
      debugPrint('[API Tenant] ⚠️ No auth token found in storage');
    }
  }

  /// Set authentication token
  Future<void> setAuthToken(String token) async {
    _authToken = token;
    _tokenLoaded = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    debugPrint('[API Tenant] 🔐 Auth token saved');
  }

  /// Clear authentication token
  Future<void> clearAuthToken() async {
    _authToken = null;
    _tokenLoaded = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    debugPrint('[API Tenant] 🗑️ Auth token cleared');
  }

  /// Get current auth token
  String? get authToken => _authToken;

  /// Check if user is authenticated
  bool get isAuthenticated => _authToken != null;

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        final message = _getErrorMessage(statusCode, responseData);
        return Exception(message);
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      default:
        return Exception('An unexpected error occurred: ${error.message}');
    }
  }

  /// Get user-friendly error message based on status code
  String _getErrorMessage(int? statusCode, dynamic responseData) {
    // Priority 1: Try to get message from API response first
    if (responseData is Map<String, dynamic> &&
        responseData['message'] != null) {
      final apiMessage = responseData['message'] as String;
      if (apiMessage.isNotEmpty) {
        return apiMessage;
      }
    }

    // Priority 2: Try to get validation errors from API response
    if (responseData is Map<String, dynamic> &&
        responseData['errors'] != null) {
      final errors = responseData['errors'] as Map<String, dynamic>;
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
        return 'Authentication failed. Please login again.';
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
}
