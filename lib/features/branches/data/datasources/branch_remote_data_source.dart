import '../../../../core/services/api_service.dart';

/// Remote data source for branch management API calls
class BranchRemoteDataSource {
  final ApiService _apiService;

  BranchRemoteDataSource({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get all branches for tenant
  Future<List<Map<String, dynamic>>> getBranches() async {
    final response = await _apiService.get('/api/v1/tenant/branches');

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return List<Map<String, dynamic>>.from(data['data'] as List);
    } else {
      throw Exception('Failed to load branches: ${response.statusCode}');
    }
  }

  /// Get branch details
  Future<Map<String, dynamic>> getBranchDetails(String branchId) async {
    final response = await _apiService.get('/api/v1/tenant/branches/$branchId');

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return data['data'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load branch details: ${response.statusCode}');
    }
  }

  /// Create new branch
  Future<Map<String, dynamic>> createBranch({
    required String name,
    required String address,
    required String city,
    required String postcode,
    required String phone,
    String? email,
  }) async {
    final response = await _apiService.post(
      '/api/v1/tenant/branches',
      data: {
        'name': name,
        'address': address,
        'city': city,
        'postcode': postcode,
        'phone': phone,
        if (email != null) 'email': email,
      },
    );

    if (response.statusCode == 201 && response.data != null) {
      final data = response.data;
      return data['data'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to create branch: ${response.statusCode}');
    }
  }

  /// Update branch
  Future<Map<String, dynamic>> updateBranch(
    String branchId,
    Map<String, dynamic> updates,
  ) async {
    final response = await _apiService.put(
      '/api/v1/tenant/branches/$branchId',
      data: updates,
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return data['data'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to update branch: ${response.statusCode}');
    }
  }

  /// Delete branch
  Future<bool> deleteBranch(String branchId) async {
    final response = await _apiService.delete('/api/v1/tenant/branches/$branchId');

    return response.statusCode == 200;
  }
}

