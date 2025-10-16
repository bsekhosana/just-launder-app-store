import '../../../../core/services/api_service.dart';

/// Remote data source for profile-related API calls
class ProfileRemoteDataSource {
  final ApiService _apiService;

  ProfileRemoteDataSource({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get tenant profile
  Future<Map<String, dynamic>> getProfile() async {
    final response = await _apiService.get('/api/v1/tenant/profile');

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return data['data'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load profile: ${response.statusCode}');
    }
  }

  /// Update tenant profile
  Future<Map<String, dynamic>> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    String? mobile,
    String? businessName,
    String? otp,
  }) async {
    final requestData = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      if (mobile != null) 'mobile': mobile,
      if (businessName != null) 'business_name': businessName,
      if (otp != null) 'otp': otp,
    };

    final response = await _apiService.put(
      '/api/v1/tenant/profile',
      data: requestData,
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      return data['data'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to update profile: ${response.statusCode}');
    }
  }

  /// Send OTP for profile changes
  Future<bool> sendProfileOtp({required String type}) async {
    final response = await _apiService.post(
      '/api/v1/tenant/profile/send-otp',
      data: {'type': type},
    );

    return response.statusCode == 200;
  }
}

