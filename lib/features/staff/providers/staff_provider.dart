import 'package:flutter/foundation.dart';
import '../../../data/models/staff_member.dart';

class StaffProvider with ChangeNotifier {
  List<StaffMember> _staff = [];
  bool _isLoading = false;

  List<StaffMember> get staff => _staff;
  bool get isLoading => _isLoading;

  /// Get staff by role
  List<StaffMember> getStaffByRole(StaffRole role) {
    return _staff.where((s) => s.role == role).toList();
  }

  /// Get active staff
  List<StaffMember> get activeStaff => _staff.where((s) => s.isActive).toList();

  /// Get drivers
  List<StaffMember> get drivers => getStaffByRole(StaffRole.driver);

  /// Get managers
  List<StaffMember> get managers => getStaffByRole(StaffRole.manager);

  /// Get staff by branch
  List<StaffMember> getStaffByBranch(String branchId) {
    return _staff.where((s) => s.branchIds.contains(branchId)).toList();
  }

  /// Load staff for a laundrette
  Future<void> loadStaff(String laundretteId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - replace with real API call
      _staff = [
        StaffMember(
          id: 'staff_1',
          laundretteId: 'laundrette_business_1',
          userId: 'user_owner_1',
          firstName: 'Alex',
          lastName: 'Thompson',
          email: 'alex@elitelaundry.com',
          phoneNumber: '+1-555-0101',
          role: StaffRole.owner,
          status: StaffStatus.active,
          profileImageUrl: 'https://example.com/alex.jpg',
          branchIds: ['branch_1', 'branch_2'],
          permissions: {
            'manage_orders': true,
            'manage_staff': true,
            'manage_branches': true,
            'view_analytics': true,
            'manage_subscription': true,
          },
          workingHours: {
            'monday': '09:00-17:00',
            'tuesday': '09:00-17:00',
            'wednesday': '09:00-17:00',
            'thursday': '09:00-17:00',
            'friday': '09:00-17:00',
            'saturday': '10:00-14:00',
            'sunday': 'closed',
          },
          hourlyRate: 0.0, // Owner
          hireDate: DateTime.now().subtract(const Duration(days: 365)),
          lastActiveAt: DateTime.now().subtract(const Duration(minutes: 5)),
          metadata: {
            'department': 'Management',
            'emergency_contact': '+1-555-9999',
          },
          createdAt: DateTime.now().subtract(const Duration(days: 365)),
          updatedAt: DateTime.now(),
        ),
        StaffMember(
          id: 'staff_2',
          laundretteId: 'laundrette_business_1',
          userId: 'user_manager_1',
          firstName: 'Sarah',
          lastName: 'Johnson',
          email: 'sarah@elitelaundry.com',
          phoneNumber: '+1-555-0102',
          role: StaffRole.manager,
          status: StaffStatus.active,
          profileImageUrl: 'https://example.com/sarah.jpg',
          branchIds: ['branch_1'],
          permissions: {
            'manage_orders': true,
            'manage_staff': false,
            'manage_branches': false,
            'view_analytics': true,
            'manage_subscription': false,
          },
          workingHours: {
            'monday': '08:00-16:00',
            'tuesday': '08:00-16:00',
            'wednesday': '08:00-16:00',
            'thursday': '08:00-16:00',
            'friday': '08:00-16:00',
            'saturday': '09:00-13:00',
            'sunday': 'closed',
          },
          hourlyRate: 28.0,
          hireDate: DateTime.now().subtract(const Duration(days: 200)),
          lastActiveAt: DateTime.now().subtract(const Duration(minutes: 15)),
          metadata: {
            'department': 'Operations',
            'emergency_contact': '+1-555-8888',
          },
          createdAt: DateTime.now().subtract(const Duration(days: 200)),
          updatedAt: DateTime.now(),
        ),
        StaffMember(
          id: 'staff_3',
          laundretteId: 'laundrette_business_1',
          userId: 'user_staff_1',
          firstName: 'Mike',
          lastName: 'Chen',
          email: 'mike@elitelaundry.com',
          phoneNumber: '+1-555-0103',
          role: StaffRole.staff,
          status: StaffStatus.active,
          profileImageUrl: 'https://example.com/mike.jpg',
          branchIds: ['branch_1'],
          permissions: {
            'manage_orders': false,
            'manage_staff': false,
            'manage_branches': false,
            'view_analytics': false,
            'manage_subscription': false,
          },
          workingHours: {
            'monday': '10:00-18:00',
            'tuesday': '10:00-18:00',
            'wednesday': '10:00-18:00',
            'thursday': '10:00-18:00',
            'friday': '10:00-18:00',
            'saturday': 'closed',
            'sunday': 'closed',
          },
          hourlyRate: 20.0,
          hireDate: DateTime.now().subtract(const Duration(days: 120)),
          lastActiveAt: DateTime.now().subtract(const Duration(hours: 2)),
          metadata: {
            'department': 'Operations',
            'emergency_contact': '+1-555-7777',
          },
          createdAt: DateTime.now().subtract(const Duration(days: 120)),
          updatedAt: DateTime.now(),
        ),
        StaffMember(
          id: 'staff_4',
          laundretteId: 'laundrette_business_1',
          userId: 'user_driver_1',
          firstName: 'David',
          lastName: 'Rodriguez',
          email: 'david@elitelaundry.com',
          phoneNumber: '+1-555-0104',
          role: StaffRole.driver,
          status: StaffStatus.active,
          profileImageUrl: 'https://example.com/david.jpg',
          branchIds: ['branch_1', 'branch_2'],
          permissions: {
            'manage_orders': false,
            'manage_staff': false,
            'manage_branches': false,
            'view_analytics': false,
            'manage_subscription': false,
          },
          workingHours: {
            'monday': '09:00-17:00',
            'tuesday': '09:00-17:00',
            'wednesday': '09:00-17:00',
            'thursday': '09:00-17:00',
            'friday': '09:00-17:00',
            'saturday': '10:00-16:00',
            'sunday': 'closed',
          },
          hourlyRate: 22.0,
          hireDate: DateTime.now().subtract(const Duration(days: 90)),
          lastActiveAt: DateTime.now().subtract(const Duration(minutes: 30)),
          metadata: {
            'department': 'Delivery',
            'emergency_contact': '+1-555-6666',
            'vehicle_type': 'Van',
            'license_plate': 'ABC-123',
          },
          createdAt: DateTime.now().subtract(const Duration(days: 90)),
          updatedAt: DateTime.now(),
        ),
        StaffMember(
          id: 'staff_5',
          laundretteId: 'laundrette_business_1',
          userId: 'user_cleaner_1',
          firstName: 'Lisa',
          lastName: 'Wang',
          email: 'lisa@elitelaundry.com',
          phoneNumber: '+1-555-0105',
          role: StaffRole.cleaner,
          status: StaffStatus.active,
          profileImageUrl: 'https://example.com/lisa.jpg',
          branchIds: ['branch_1'],
          permissions: {
            'manage_orders': false,
            'manage_staff': false,
            'manage_branches': false,
            'view_analytics': false,
            'manage_subscription': false,
          },
          workingHours: {
            'monday': '06:00-14:00',
            'tuesday': '06:00-14:00',
            'wednesday': '06:00-14:00',
            'thursday': '06:00-14:00',
            'friday': '06:00-14:00',
            'saturday': '07:00-12:00',
            'sunday': 'closed',
          },
          hourlyRate: 18.0,
          hireDate: DateTime.now().subtract(const Duration(days: 60)),
          lastActiveAt: DateTime.now().subtract(const Duration(hours: 1)),
          metadata: {
            'department': 'Cleaning',
            'emergency_contact': '+1-555-5555',
            'specialization': 'Delicate fabrics',
          },
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
          updatedAt: DateTime.now(),
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new staff member
  Future<bool> addStaff(StaffMember staff) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _staff.add(staff);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update an existing staff member
  Future<bool> updateStaff(StaffMember staff) async {
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
      return false;
    }
  }

  /// Delete a staff member
  Future<bool> deleteStaff(String staffId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _staff.removeWhere((s) => s.id == staffId);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
