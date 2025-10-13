import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/utils/log_helper.dart';

/// Remote data source for staff management API calls
class StaffRemoteDataSource {
  static const String baseUrl = 'https://justlaunder.co.uk/api/v1';
  static String? _authToken;

  /// Set authentication token
  static Future<void> setAuthToken(String token) async {
    _authToken = token;
    LogHelper.api('Staff auth token set');
  }

  /// Clear authentication token
  static Future<void> clearAuthToken() async {
    _authToken = null;
    LogHelper.api('Staff auth token cleared');
  }

  /// Get headers with auth token
  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    };
  }

  /// Create new staff member
  /// POST /api/v1/tenant/staff
  Future<Map<String, dynamic>> createStaff({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
    bool isActive = true,
  }) async {
    try {
      LogHelper.api('Creating staff member: $email');

      final url = Uri.parse('$baseUrl/tenant/staff');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'mobile': mobile,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'is_active': isActive,
        }),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      LogHelper.api('Staff creation response: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        LogHelper.api('Staff created successfully');
        return responseData;
      } else {
        LogHelper.error('Staff creation failed: ${response.statusCode}');
        return responseData;
      }
    } catch (e) {
      LogHelper.error('Unexpected error creating staff: $e');
      return {
        'success': false,
        'message': 'Failed to create staff member',
        'error': e.toString(),
      };
    }
  }

  /// Get all staff members
  /// GET /api/v1/tenant/staff
  Future<Map<String, dynamic>> getStaffList() async {
    try {
      LogHelper.api('Fetching staff list');

      final url = Uri.parse('$baseUrl/tenant/staff');
      final response = await http.get(url, headers: _getHeaders());

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      LogHelper.api('Staff list response: ${response.statusCode}');

      return responseData;
    } catch (e) {
      LogHelper.error('Get staff list error: $e');
      return {
        'success': false,
        'message': 'Failed to fetch staff list',
        'error': e.toString(),
      };
    }
  }

  /// Get staff member by ID
  /// GET /api/v1/tenant/staff/{id}
  Future<Map<String, dynamic>> getStaff(String staffId) async {
    try {
      LogHelper.api('Fetching staff: $staffId');

      final url = Uri.parse('$baseUrl/tenant/staff/$staffId');
      final response = await http.get(url, headers: _getHeaders());

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      LogHelper.api('Staff fetch response: ${response.statusCode}');

      return responseData;
    } catch (e) {
      LogHelper.error('Get staff error: $e');
      return {
        'success': false,
        'message': 'Failed to fetch staff member',
        'error': e.toString(),
      };
    }
  }

  /// Update staff member
  /// PUT /api/v1/tenant/staff/{id}
  Future<Map<String, dynamic>> updateStaff({
    required String staffId,
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    bool? isActive,
  }) async {
    try {
      LogHelper.api('Updating staff: $staffId');

      final url = Uri.parse('$baseUrl/tenant/staff/$staffId');
      final response = await http.put(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'mobile': mobile,
          if (isActive != null) 'is_active': isActive,
        }),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      LogHelper.api('Staff update response: ${response.statusCode}');

      return responseData;
    } catch (e) {
      LogHelper.error('Update staff error: $e');
      return {
        'success': false,
        'message': 'Failed to update staff member',
        'error': e.toString(),
      };
    }
  }

  /// Delete staff member
  /// DELETE /api/v1/tenant/staff/{id}
  Future<Map<String, dynamic>> deleteStaff(String staffId) async {
    try {
      LogHelper.api('Deleting staff: $staffId');

      final url = Uri.parse('$baseUrl/tenant/staff/$staffId');
      final response = await http.delete(url, headers: _getHeaders());

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      LogHelper.api('Staff delete response: ${response.statusCode}');

      return responseData;
    } catch (e) {
      LogHelper.error('Delete staff error: $e');
      return {
        'success': false,
        'message': 'Failed to delete staff member',
        'error': e.toString(),
      };
    }
  }
}

