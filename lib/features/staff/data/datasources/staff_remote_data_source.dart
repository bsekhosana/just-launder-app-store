import '../../../../core/services/api_service.dart';

/// Remote data source for staff management API calls
class StaffRemoteDataSource {
  final ApiService _apiService;

  StaffRemoteDataSource({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get all staff members for tenant
  Future<List<Map<String, dynamic>>> getStaff({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiService.get(
      '/api/v1/tenant/staff',
      queryParameters: {'page': page, 'per_page': perPage},
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return List<Map<String, dynamic>>.from(data['data'] as List);
    } else {
      throw Exception('Failed to load staff: ${response.statusCode}');
    }
  }

  /// Get staff member details
  Future<Map<String, dynamic>> getStaffDetails(String staffId) async {
    final response = await _apiService.get('/api/v1/tenant/staff/$staffId');

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return data['data'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load staff details: ${response.statusCode}');
    }
  }

  /// Create new staff member
  Future<Map<String, dynamic>> createStaff({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
    bool isActive = true,
  }) async {
    final response = await _apiService.post(
      '/api/v1/tenant/staff',
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'mobile': mobile,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'is_active': isActive,
      },
    );

    if (response.statusCode == 201 && response.data != null) {
      final data = response.data;
      return data['data'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to create staff: ${response.statusCode}');
    }
  }

  /// Update staff member
  Future<Map<String, dynamic>> updateStaff(
    String staffId,
    Map<String, dynamic> updates,
  ) async {
    final response = await _apiService.put(
      '/api/v1/tenant/staff/$staffId',
      data: updates,
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return data['data'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to update staff: ${response.statusCode}');
    }
  }

  /// Delete staff member
  Future<bool> deleteStaff(String staffId) async {
    final response = await _apiService.delete('/api/v1/tenant/staff/$staffId');

    return response.statusCode == 200;
  }
}
