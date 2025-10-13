import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// API Service for handling HTTP requests
class ApiService {
  static const String baseUrl = 'https://justlaunder.co.uk';
  
  final http.Client _client;
  String? _token;
  
  ApiService({http.Client? client}) : _client = client ?? http.Client();
  
  /// Initialize the service by loading the auth token
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }
  
  /// Set the authentication token
  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  /// Clear the authentication token
  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
  
  /// Get headers with authentication
  Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }
  
  /// GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl$endpoint');
      
      if (queryParameters != null) {
        uri = uri.replace(queryParameters: queryParameters);
      }
      
      final response = await _client.get(uri, headers: _getHeaders());
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }
  
  /// POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      
      final response = await _client.post(
        uri,
        headers: _getHeaders(),
        body: data != null ? jsonEncode(data) : null,
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }
  
  /// PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      
      final response = await _client.put(
        uri,
        headers: _getHeaders(),
        body: data != null ? jsonEncode(data) : null,
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }
  
  /// DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      
      final response = await _client.delete(uri, headers: _getHeaders());
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }
  
  /// Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (statusCode == 401) {
      throw Exception('Unauthorized: Please log in again');
    } else if (statusCode == 404) {
      throw Exception('Resource not found');
    } else if (statusCode == 422) {
      final error = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(error['message'] ?? 'Validation error');
    } else if (statusCode >= 500) {
      final error = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(error['message'] ?? 'Server error');
    } else {
      throw Exception('Request failed with status: $statusCode');
    }
  }
}

