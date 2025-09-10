import 'package:flutter/material.dart';
import '../../../data/models/laundrette_branch.dart';

/// Branch provider for managing laundrette branches
class BranchProvider extends ChangeNotifier {
  List<LaundretteBranch> _branches = [];
  bool _isLoading = false;

  List<LaundretteBranch> get branches => _branches;
  bool get isLoading => _isLoading;

  /// Load branches for a laundrette
  Future<void> loadBranches(String laundretteId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - replace with real API call
      if (laundretteId == 'laundrette_business_1') {
        _branches = [
          LaundretteBranch(
            id: 'branch_1',
            laundretteId: 'laundrette_business_1',
            name: 'Downtown Branch',
            description: 'Main downtown location with full services',
            imageUrl: 'https://example.com/branch1.jpg',
            address: '123 Main Street',
            city: 'New York',
            postcode: '10001',
            country: 'USA',
            latitude: 40.7128,
            longitude: -74.0060,
            status: BranchStatus.active,
            isOpen: true,
            operatingHours: {
              'monday': '08:00-20:00',
              'tuesday': '08:00-20:00',
              'wednesday': '08:00-20:00',
              'thursday': '08:00-20:00',
              'friday': '08:00-20:00',
              'saturday': '09:00-18:00',
              'sunday': '10:00-16:00',
            },
            bagPricing: {
              'small': 15.99,
              'medium': 19.99,
              'large': 24.99,
              'extra_large': 29.99,
            },
            servicePricing: {
              'wash_and_fold': 2.50,
              'dry_clean': 8.99,
              'ironing': 1.99,
              'express': 5.00,
              'stain_removal': 3.50,
            },
            autoAcceptOrders: false,
            supportsPriorityDelivery: true,
            phoneNumber: '+1-555-0123',
            email: 'downtown@elitelaundry.com',
            maxConcurrentOrders: 50,
            currentOrderCount: 23,
            settings: {'notifications': true, 'autoAssignDrivers': true},
            createdAt: DateTime.now().subtract(const Duration(days: 300)),
            updatedAt: DateTime.now(),
          ),
          LaundretteBranch(
            id: 'branch_2',
            laundretteId: 'laundrette_business_1',
            name: 'Uptown Branch',
            description: 'Uptown location with premium services',
            imageUrl: 'https://example.com/branch2.jpg',
            address: '456 Uptown Avenue',
            city: 'New York',
            postcode: '10028',
            country: 'USA',
            latitude: 40.7831,
            longitude: -73.9712,
            status: BranchStatus.active,
            isOpen: true,
            operatingHours: {
              'monday': '07:00-21:00',
              'tuesday': '07:00-21:00',
              'wednesday': '07:00-21:00',
              'thursday': '07:00-21:00',
              'friday': '07:00-21:00',
              'saturday': '08:00-19:00',
              'sunday': '09:00-17:00',
            },
            bagPricing: {
              'small': 17.99,
              'medium': 22.99,
              'large': 27.99,
              'extra_large': 32.99,
            },
            servicePricing: {
              'wash_and_fold': 2.99,
              'dry_clean': 9.99,
              'ironing': 2.49,
              'express': 6.00,
              'stain_removal': 4.00,
            },
            autoAcceptOrders: true,
            supportsPriorityDelivery: true,
            phoneNumber: '+1-555-0124',
            email: 'uptown@elitelaundry.com',
            maxConcurrentOrders: 75,
            currentOrderCount: 45,
            settings: {'notifications': true, 'autoAssignDrivers': true},
            createdAt: DateTime.now().subtract(const Duration(days: 200)),
            updatedAt: DateTime.now(),
          ),
        ];
      } else if (laundretteId == 'laundrette_private_1') {
        _branches = [
          LaundretteBranch(
            id: 'branch_3',
            laundretteId: 'laundrette_private_1',
            name: 'Home Location',
            description: 'Home-based laundry service',
            imageUrl: 'https://example.com/branch3.jpg',
            address: '456 Home Avenue',
            city: 'Los Angeles',
            postcode: '90210',
            country: 'USA',
            latitude: 34.0522,
            longitude: -118.2437,
            status: BranchStatus.active,
            isOpen: true,
            operatingHours: {
              'monday': '09:00-17:00',
              'tuesday': '09:00-17:00',
              'wednesday': '09:00-17:00',
              'thursday': '09:00-17:00',
              'friday': '09:00-17:00',
              'saturday': '10:00-15:00',
              'sunday': 'closed',
            },
            bagPricing: {
              'small': 12.99,
              'medium': 16.99,
              'large': 20.99,
              'extra_large': 24.99,
            },
            servicePricing: {
              'wash_and_fold': 2.00,
              'dry_clean': 7.99,
              'ironing': 1.50,
              'express': 3.00,
              'stain_removal': 2.50,
            },
            autoAcceptOrders: true,
            supportsPriorityDelivery: false,
            phoneNumber: '+1-555-0456',
            email: 'home@laundrysolutions.com',
            maxConcurrentOrders: 20,
            currentOrderCount: 8,
            settings: {'notifications': true, 'autoAssignDrivers': false},
            createdAt: DateTime.now().subtract(const Duration(days: 180)),
            updatedAt: DateTime.now(),
          ),
        ];
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add new branch
  Future<bool> addBranch(LaundretteBranch branch) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _branches.add(branch);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update branch
  Future<bool> updateBranch(LaundretteBranch updatedBranch) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final index = _branches.indexWhere((b) => b.id == updatedBranch.id);
      if (index != -1) {
        _branches[index] = updatedBranch;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Delete branch
  Future<bool> deleteBranch(String branchId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _branches.removeWhere((b) => b.id == branchId);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get branch by ID
  LaundretteBranch? getBranchById(String branchId) {
    try {
      return _branches.firstWhere((b) => b.id == branchId);
    } catch (e) {
      return null;
    }
  }
}
