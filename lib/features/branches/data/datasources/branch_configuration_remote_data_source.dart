import '../../../../core/services/api_service.dart';
import '../models/branch_configuration_model.dart';

class BranchConfigurationRemoteDataSource {
  final ApiService _apiService;

  BranchConfigurationRemoteDataSource({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get branch configuration
  Future<BranchConfigurationModel> getBranchConfiguration(
    String branchId,
  ) async {
    try {
      final response = await _apiService.get(
        '/api/v1/tenant/branches/$branchId/configuration',
      );
      return BranchConfigurationModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to get branch configuration: $e');
    }
  }

  /// Update branch configuration
  Future<BranchConfigurationModel> updateBranchConfiguration(
    String branchId,
    Map<String, dynamic> configuration,
  ) async {
    try {
      final response = await _apiService.put(
        '/api/v1/tenant/branches/$branchId/configuration',
        data: configuration,
      );
      return BranchConfigurationModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to update branch configuration: $e');
    }
  }

  /// Get payment dashboard data
  Future<PaymentDashboardModel> getPaymentDashboard({
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (branchId != null) queryParams['branch_id'] = branchId;
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

      final response = await _apiService.get(
        '/api/v1/tenant/payment/dashboard',
        queryParameters: queryParams,
      );
      return PaymentDashboardModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to get payment dashboard: $e');
    }
  }

  /// Get Stripe Connect account status
  Future<Map<String, dynamic>> getStripeConnectStatus() async {
    try {
      final response = await _apiService.get(
        '/api/v1/tenant/payment/stripe-connect/status',
      );
      return response['data'];
    } catch (e) {
      throw Exception('Failed to get Stripe Connect status: $e');
    }
  }

  /// Create Stripe Connect account link
  Future<String> createStripeConnectLink() async {
    try {
      final response = await _apiService.post(
        '/api/v1/tenant/payment/stripe-connect/create-link',
      );
      return response['data']['url'] as String;
    } catch (e) {
      throw Exception('Failed to create Stripe Connect link: $e');
    }
  }
}

