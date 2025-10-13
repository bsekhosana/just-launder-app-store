import 'package:flutter/material.dart';
import '../data/datasources/branch_configuration_remote_data_source.dart';
import '../data/models/branch_configuration_model.dart';

/// Provider for managing branch configuration and payment dashboard
class BranchConfigurationProvider extends ChangeNotifier {
  final BranchConfigurationRemoteDataSource _dataSource;

  BranchConfigurationProvider({BranchConfigurationRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? BranchConfigurationRemoteDataSource();

  // State
  BranchConfigurationModel? _configuration;
  PaymentDashboardModel? _dashboard;
  Map<String, dynamic>? _stripeConnectStatus;
  
  bool _isLoading = false;
  bool _isLoadingDashboard = false;
  bool _isLoadingStripe = false;
  bool _isSaving = false;
  
  String? _errorMessage;

  // Getters
  BranchConfigurationModel? get configuration => _configuration;
  PaymentDashboardModel? get dashboard => _dashboard;
  Map<String, dynamic>? get stripeConnectStatus => _stripeConnectStatus;
  
  bool get isLoading => _isLoading;
  bool get isLoadingDashboard => _isLoadingDashboard;
  bool get isLoadingStripe => _isLoadingStripe;
  bool get isSaving => _isSaving;
  
  String? get errorMessage => _errorMessage;

  bool get isStripeConnected =>
      _stripeConnectStatus?['is_connected'] as bool? ?? false;
  String? get stripeAccountId => _stripeConnectStatus?['account_id'] as String?;

  /// Load branch configuration
  Future<void> loadBranchConfiguration(String branchId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _configuration = await _dataSource.getBranchConfiguration(branchId);
      debugPrint('✅ Branch configuration loaded');
    } catch (e) {
      _errorMessage = 'Failed to load configuration: $e';
      debugPrint('❌ Failed to load configuration: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update branch configuration
  Future<bool> updateBranchConfiguration(
    String branchId,
    Map<String, dynamic> updates,
  ) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _configuration = await _dataSource.updateBranchConfiguration(
        branchId,
        updates,
      );
      debugPrint('✅ Branch configuration updated');
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update configuration: $e';
      debugPrint('❌ Failed to update configuration: $e');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Load payment dashboard
  Future<void> loadPaymentDashboard({
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _isLoadingDashboard = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dashboard = await _dataSource.getPaymentDashboard(
        branchId: branchId,
        startDate: startDate,
        endDate: endDate,
      );
      debugPrint('✅ Payment dashboard loaded');
    } catch (e) {
      _errorMessage = 'Failed to load dashboard: $e';
      debugPrint('❌ Failed to load dashboard: $e');
    } finally {
      _isLoadingDashboard = false;
      notifyListeners();
    }
  }

  /// Load Stripe Connect status
  Future<void> loadStripeConnectStatus() async {
    _isLoadingStripe = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stripeConnectStatus = await _dataSource.getStripeConnectStatus();
      debugPrint('✅ Stripe Connect status loaded');
    } catch (e) {
      _errorMessage = 'Failed to load Stripe status: $e';
      debugPrint('❌ Failed to load Stripe status: $e');
    } finally {
      _isLoadingStripe = false;
      notifyListeners();
    }
  }

  /// Create Stripe Connect account link
  Future<String?> createStripeConnectLink() async {
    _isLoadingStripe = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = await _dataSource.createStripeConnectLink();
      debugPrint('✅ Stripe Connect link created');
      return url;
    } catch (e) {
      _errorMessage = 'Failed to create Stripe link: $e';
      debugPrint('❌ Failed to create Stripe link: $e');
      return null;
    } finally {
      _isLoadingStripe = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

