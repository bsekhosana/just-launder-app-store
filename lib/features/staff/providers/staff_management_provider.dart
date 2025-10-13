import 'package:flutter/material.dart';
import '../data/models/staff_model.dart';
import '../data/datasources/staff_remote_data_source.dart';
import '../../../core/utils/log_helper.dart';

/// Provider for managing staff operations
class StaffManagementProvider extends ChangeNotifier {
  // State variables
  List<StaffModel> _staff = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic> _staffAnalytics = {};
  Map<String, dynamic> _staffStatistics = {};

  // Getters
  List<StaffModel> get staff => _staff;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic> get staffAnalytics => _staffAnalytics;
  Map<String, dynamic> get staffStatistics => _staffStatistics;

  /// Get staff by role
  List<StaffModel> getStaffByRole(StaffRole role) {
    return _staff.where((member) => member.role == role).toList();
  }

  /// Get staff by status
  List<StaffModel> getStaffByStatus(StaffStatus status) {
    return _staff.where((member) => member.status == status).toList();
  }

  /// Get active staff
  List<StaffModel> get activeStaff => getStaffByStatus(StaffStatus.active);

  /// Get inactive staff
  List<StaffModel> get inactiveStaff => getStaffByStatus(StaffStatus.inactive);

  /// Get suspended staff
  List<StaffModel> get suspendedStaff =>
      getStaffByStatus(StaffStatus.suspended);

  /// Get terminated staff
  List<StaffModel> get terminatedStaff =>
      getStaffByStatus(StaffStatus.terminated);

  /// Get managers
  List<StaffModel> get managers => getStaffByRole(StaffRole.manager);

  /// Get supervisors
  List<StaffModel> get supervisors => getStaffByRole(StaffRole.supervisor);

  /// Get operators
  List<StaffModel> get operators => getStaffByRole(StaffRole.operator);

  /// Get cleaners
  List<StaffModel> get cleaners => getStaffByRole(StaffRole.cleaner);

  /// Get drivers
  List<StaffModel> get drivers => getStaffByRole(StaffRole.driver);

  /// Get admins
  List<StaffModel> get admins => getStaffByRole(StaffRole.admin);

  /// Get staff by ID
  StaffModel? getStaffById(String staffId) {
    try {
      return _staff.firstWhere((member) => member.id == staffId);
    } catch (e) {
      return null;
    }
  }

  /// Load staff
  Future<void> loadStaff(String tenantId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - replace with real API call
      _staff = [
        StaffModel(
          id: 'staff_1',
          tenantId: tenantId,
          firstName: 'John',
          lastName: 'Smith',
          email: 'john.smith@laundrex.com',
          phone: '+1-555-0101',
          role: StaffRole.manager,
          status: StaffStatus.active,
          permissions: [
            StaffPermission.viewOrders,
            StaffPermission.updateOrders,
            StaffPermission.manageOrders,
            StaffPermission.viewAnalytics,
            StaffPermission.manageStaff,
            StaffPermission.managePricing,
            StaffPermission.manageCustomers,
            StaffPermission.manageSettings,
          ],
          profileImageUrl: null,
          lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
          metadata: {
            'department': 'Operations',
            'shift': 'Day',
            'performance_rating': 4.8,
          },
        ),
        StaffModel(
          id: 'staff_2',
          tenantId: tenantId,
          firstName: 'Sarah',
          lastName: 'Johnson',
          email: 'sarah.johnson@laundrex.com',
          phone: '+1-555-0102',
          role: StaffRole.supervisor,
          status: StaffStatus.active,
          permissions: [
            StaffPermission.viewOrders,
            StaffPermission.updateOrders,
            StaffPermission.manageOrders,
            StaffPermission.viewAnalytics,
          ],
          profileImageUrl: null,
          lastLoginAt: DateTime.now().subtract(const Duration(hours: 4)),
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
          metadata: {
            'department': 'Operations',
            'shift': 'Evening',
            'performance_rating': 4.5,
          },
        ),
        StaffModel(
          id: 'staff_3',
          tenantId: tenantId,
          firstName: 'Mike',
          lastName: 'Wilson',
          email: 'mike.wilson@laundrex.com',
          phone: '+1-555-0103',
          role: StaffRole.operator,
          status: StaffStatus.active,
          permissions: [
            StaffPermission.viewOrders,
            StaffPermission.updateOrders,
          ],
          profileImageUrl: null,
          lastLoginAt: DateTime.now().subtract(const Duration(minutes: 30)),
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
          metadata: {
            'department': 'Processing',
            'shift': 'Day',
            'performance_rating': 4.2,
          },
        ),
        StaffModel(
          id: 'staff_4',
          tenantId: tenantId,
          firstName: 'Emily',
          lastName: 'Davis',
          email: 'emily.davis@laundrex.com',
          phone: '+1-555-0104',
          role: StaffRole.cleaner,
          status: StaffStatus.active,
          permissions: [
            StaffPermission.viewOrders,
            StaffPermission.updateOrders,
          ],
          profileImageUrl: null,
          lastLoginAt: DateTime.now().subtract(const Duration(hours: 1)),
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
          metadata: {
            'department': 'Cleaning',
            'shift': 'Day',
            'performance_rating': 4.0,
          },
        ),
        StaffModel(
          id: 'staff_5',
          tenantId: tenantId,
          firstName: 'David',
          lastName: 'Brown',
          email: 'david.brown@laundrex.com',
          phone: '+1-555-0105',
          role: StaffRole.driver,
          status: StaffStatus.active,
          permissions: [
            StaffPermission.viewOrders,
            StaffPermission.updateOrders,
          ],
          profileImageUrl: null,
          lastLoginAt: DateTime.now().subtract(const Duration(minutes: 15)),
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
          metadata: {
            'department': 'Delivery',
            'shift': 'Flexible',
            'performance_rating': 4.6,
            'vehicle_id': 'vehicle_1',
          },
        ),
        StaffModel(
          id: 'staff_6',
          tenantId: tenantId,
          firstName: 'Lisa',
          lastName: 'Garcia',
          email: 'lisa.garcia@laundrex.com',
          phone: '+1-555-0106',
          role: StaffRole.operator,
          status: StaffStatus.inactive,
          permissions: [
            StaffPermission.viewOrders,
            StaffPermission.updateOrders,
          ],
          profileImageUrl: null,
          lastLoginAt: DateTime.now().subtract(const Duration(days: 3)),
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
          updatedAt: DateTime.now().subtract(const Duration(days: 3)),
          metadata: {
            'department': 'Processing',
            'shift': 'Night',
            'performance_rating': 3.8,
          },
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add new staff member via API
  Future<Map<String, dynamic>> addStaffViaAPI({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
    bool isActive = true,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final remoteDataSource = StaffRemoteDataSource();
      final response = await remoteDataSource.createStaff(
        firstName: firstName,
        lastName: lastName,
        email: email,
        mobile: mobile,
        password: password,
        passwordConfirmation: passwordConfirmation,
        isActive: isActive,
      );

      _isLoading = false;
      notifyListeners();

      if (response['success'] == true) {
        LogHelper.info('Staff member created successfully');
        // Refresh staff list
        await loadStaff('tenant_id');
      }

      return response;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      LogHelper.error('Error adding staff via API: $e');
      return {
        'success': false,
        'message': 'Failed to create staff member',
        'error': e.toString(),
      };
    }
  }

  /// Add new staff member (local/mock)
  Future<bool> addStaff(StaffModel staff) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _staff.add(staff);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update staff member
  Future<bool> updateStaff(StaffModel staff) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final index = _staff.indexWhere((s) => s.id == staff.id);
      if (index != -1) {
        _staff[index] = staff;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Delete staff member
  Future<bool> deleteStaff(String staffId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _staff.removeWhere((s) => s.id == staffId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update staff status
  Future<bool> updateStaffStatus(String staffId, StaffStatus status) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final index = _staff.indexWhere((s) => s.id == staffId);
      if (index != -1) {
        _staff[index] = _staff[index].copyWith(
          status: status,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update staff permissions
  Future<bool> updateStaffPermissions(
    String staffId,
    List<StaffPermission> permissions,
  ) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final index = _staff.indexWhere((s) => s.id == staffId);
      if (index != -1) {
        _staff[index] = _staff[index].copyWith(
          permissions: permissions,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Load staff analytics
  Future<void> loadStaffAnalytics(String tenantId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final topPerformers =
          _staff.where((s) => s.isActive).toList()..sort((a, b) {
            final ratingA = a.metadata['performance_rating'] as double? ?? 0.0;
            final ratingB = b.metadata['performance_rating'] as double? ?? 0.0;
            return ratingB.compareTo(ratingA);
          });

      final recentActivity =
          _staff.where((s) => s.lastLoginAt != null).toList()
            ..sort((a, b) => b.lastLoginAt!.compareTo(a.lastLoginAt!));

      _staffAnalytics = {
        'total_staff': _staff.length,
        'active_staff': activeStaff.length,
        'inactive_staff': inactiveStaff.length,
        'suspended_staff': suspendedStaff.length,
        'terminated_staff': terminatedStaff.length,
        'role_distribution': {
          'managers': managers.length,
          'supervisors': supervisors.length,
          'operators': operators.length,
          'cleaners': cleaners.length,
          'drivers': drivers.length,
          'admins': admins.length,
        },
        'performance_metrics': {
          'average_rating':
              _staff.fold<double>(0, (sum, s) {
                final rating =
                    s.metadata['performance_rating'] as double? ?? 0.0;
                return sum + rating;
              }) /
              _staff.length,
          'top_performers':
              topPerformers
                  .take(3)
                  .map(
                    (s) => {
                      'id': s.id,
                      'name': s.fullName,
                      'rating': s.metadata['performance_rating'],
                      'role': s.roleDisplayText,
                    },
                  )
                  .toList(),
        },
        'recent_activity':
            recentActivity
                .take(5)
                .map(
                  (s) => {
                    'id': s.id,
                    'name': s.fullName,
                    'last_login': s.lastLoginAt!.toIso8601String(),
                    'role': s.roleDisplayText,
                  },
                )
                .toList(),
      };

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Load staff statistics
  Future<void> loadStaffStatistics(String tenantId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _staffStatistics = {
        'total_staff': _staff.length,
        'active_staff': activeStaff.length,
        'inactive_staff': inactiveStaff.length,
        'suspended_staff': suspendedStaff.length,
        'terminated_staff': terminatedStaff.length,
        'attendance_rate': 95.5,
        'average_performance':
            _staff.fold<double>(0, (sum, s) {
              final rating = s.metadata['performance_rating'] as double? ?? 0.0;
              return sum + rating;
            }) /
            _staff.length,
        'department_distribution': {
          'operations':
              _staff
                  .where((s) => s.metadata['department'] == 'Operations')
                  .length,
          'processing':
              _staff
                  .where((s) => s.metadata['department'] == 'Processing')
                  .length,
          'cleaning':
              _staff
                  .where((s) => s.metadata['department'] == 'Cleaning')
                  .length,
          'delivery':
              _staff
                  .where((s) => s.metadata['department'] == 'Delivery')
                  .length,
        },
        'shift_distribution': {
          'day': _staff.where((s) => s.metadata['shift'] == 'Day').length,
          'evening':
              _staff.where((s) => s.metadata['shift'] == 'Evening').length,
          'night': _staff.where((s) => s.metadata['shift'] == 'Night').length,
          'flexible':
              _staff.where((s) => s.metadata['shift'] == 'Flexible').length,
        },
      };

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Refresh staff data
  Future<void> refreshStaff(String tenantId) async {
    await loadStaff(tenantId);
    await loadStaffAnalytics(tenantId);
    await loadStaffStatistics(tenantId);
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Get staff summary
  Map<String, int> getStaffSummary() {
    return {
      'total': _staff.length,
      'active': activeStaff.length,
      'inactive': inactiveStaff.length,
      'suspended': suspendedStaff.length,
      'terminated': terminatedStaff.length,
    };
  }

  /// Get role summary
  Map<String, int> getRoleSummary() {
    return {
      'managers': managers.length,
      'supervisors': supervisors.length,
      'operators': operators.length,
      'cleaners': cleaners.length,
      'drivers': drivers.length,
      'admins': admins.length,
    };
  }

  /// Get department summary
  Map<String, int> getDepartmentSummary() {
    final departments = <String, int>{};
    for (final member in _staff) {
      final dept = member.metadata['department'] as String? ?? 'Unknown';
      departments[dept] = (departments[dept] ?? 0) + 1;
    }
    return departments;
  }

  /// Get shift summary
  Map<String, int> getShiftSummary() {
    final shifts = <String, int>{};
    for (final member in _staff) {
      final shift = member.metadata['shift'] as String? ?? 'Unknown';
      shifts[shift] = (shifts[shift] ?? 0) + 1;
    }
    return shifts;
  }

  /// Get average performance rating
  double getAveragePerformanceRating() {
    if (_staff.isEmpty) return 0.0;

    final totalRating = _staff.fold<double>(0, (sum, s) {
      final rating = s.metadata['performance_rating'] as double? ?? 0.0;
      return sum + rating;
    });

    return totalRating / _staff.length;
  }

  /// Get top performers
  List<StaffModel> getTopPerformers({int limit = 5}) {
    final activeStaff = _staff.where((s) => s.isActive).toList();
    activeStaff.sort((a, b) {
      final ratingA = a.metadata['performance_rating'] as double? ?? 0.0;
      final ratingB = b.metadata['performance_rating'] as double? ?? 0.0;
      return ratingB.compareTo(ratingA);
    });
    return activeStaff.take(limit).toList();
  }

  /// Get recent activity
  List<StaffModel> getRecentActivity({int limit = 5}) {
    final staffWithLogin = _staff.where((s) => s.lastLoginAt != null).toList();
    staffWithLogin.sort((a, b) => b.lastLoginAt!.compareTo(a.lastLoginAt!));
    return staffWithLogin.take(limit).toList();
  }
}
